# KillChain: Resume Operation

You are resuming a KillChain project from a previous session. This command enables stateless operation across multiple Claude Code sessions.

## Resume Modes

### Standard Mode (default)
Resume execution with user interaction for all decisions and questions.

### Parallel Mode (--parallel flag)
Resume with batch processing of multiple independent components. See "Parallel Execution" section below.

### Dangerous Vibe Mode (--dangerous-vibe-mode flag)
**WARNING**: This mode auto-selects recommended answers without user confirmation.
- When questions arise, Claude automatically picks the recommended option
- User is informed of the decision but not asked for approval
- Use only when you trust Claude's judgment completely
- Can be combined with --parallel mode
- All decisions are logged in `killchain_context.json` for review

## Resume Process

### 1. Verify KillChain Project

Check for required files:
```bash
# Master plan
ls .claude/killchain/killchain_init.md

# Context snapshot
ls .claude/killchain/killchain_context.json

# Component files
ls .claude/killchain/kc*.md
```

If these files don't exist, inform the user this doesn't appear to be a KillChain project.

### 2. Load Context

Read `.claude/killchain/killchain_context.json`:

```json
{
  "project_name": "...",
  "started_at": "...",
  "last_updated": "...",
  "current_component": "kcXXX",
  "completed_components": ["kc001", "kc002", ...],
  "active_tasks": {
    "kcXXX": {
      "status": "in_progress|blocked|review",
      "agent": "developer|qa|reviewer",
      "last_action": "...",
      "blockers": []
    }
  },
  "blockers": [
    {
      "component": "kcXXX",
      "issue": "description",
      "severity": "critical|major|minor"
    }
  ],
  "decisions_made": [
    {
      "timestamp": "...",
      "decision": "...",
      "rationale": "..."
    }
  ],
  "questions_for_user": [
    {
      "component": "kcXXX",
      "question": "...",
      "options": ["A", "B", "C"]
    }
  ]
}
```

### 3. Present Status Report

Show the user:

```markdown
## KillChain Resume: <project_name>

### Progress Summary
- Total components: <count>
- Completed: <count> (<percentage>%)
- In progress: <current_component>
- Remaining: <count>

### Current State
Component: <current_component>
Status: <status>
Last updated: <timestamp>

### Recent Activity
<Summary of last few actions from context>

### Blockers
<List any blockers that need resolution>

### Questions Pending
<List any questions for user>
```

### 4. Handle Blockers First

If blockers exist:
1. Present each blocker to the user
2. Discuss resolution approaches
3. Update context with decisions
4. Remove resolved blockers from context

### 5. Answer Pending Questions

If questions exist:
1. Present each question with options using the standard format:
```
# 1 - <question title>
- A: <option description>
- B: <option description>
- C: <option description>
- Other? (please specify)
I recommend <best option> because: <brief description why it's the best option>
```
2. Record user's decision in decisions_made
3. Update relevant component files with decisions
4. Clear questions from context

### 6. Determine Resume Point

Based on current_component status:

**Status: "in_progress"**
- Review what was last attempted
- Check if partially complete
- Ask user: Continue from here or restart this component?

**Status: "blocked"**
- Review blocker resolution
- Ready to retry or need more discussion?

**Status: "review"**
- Pick up at review stage
- Re-launch reviewer agent

**Status: "completed"**
- Move to next component

### 7. Resume Execution

Once resume point is clear:

**Recreate TodoWrite List:**
Rebuild the todo list from killchain_context.json to show current progress:

```
[completed] kc001: Terminal Interface
[completed] kc002: Camera Class
[in_progress] kc003: Recording Logic  <- Resuming here
[pending] kc004: Video Processing
[pending] kc005: Configuration Management
```

This syncs the TodoWrite tool with the actual project state.

**Update Context:**
```json
{
  "last_updated": "<new timestamp>",
  "resumed_at": "<timestamp>",
  "resume_count": <increment>
}
```

**Continue with standard execution flow:**
Use the same workflow as `/killchain-execute`:
1. Launch appropriate agent for current stage
2. Follow quality pipeline
3. Update context after each completion
4. Update TodoWrite as components complete
5. Commit progress with git

## Parallel Execution (if --parallel flag)

When `--parallel` flag is provided during resume:

### Batch Processing Strategy
1. **Batch Size**: Process 1-10 remaining components together based on:
   - Dependency relationships (only independent components)
   - Complexity estimates
   - Available context window

2. **Test Isolation Rule**:
   - **CRITICAL**: NEVER allow tests to run or be implemented while non-test features are being implemented
   - Tests (unit and integration) are ONLY executed AFTER the entire batch of feature components is complete
   - Developer agents should implement code WITHOUT running tests during parallel mode
   - QA phase happens after ALL components in the batch are implemented

### Execution Flow
1. Identify 1-10 independent pending components (no dependency chains between them)
2. Launch multiple developer agents concurrently for implementation only
3. Wait for ALL developer agents to complete implementation
4. THEN run QA and tests for the entire batch together
5. THEN run code review for approved implementations
6. Update all component statuses together

### File Conflict Prevention
- Implement file-level locking to prevent conflicts
- Each agent works on distinct files
- Merge results after all agents complete

### Batch Completion
- All components in batch must pass QA before proceeding to next batch
- If any component fails, fix it before starting next batch

### 8. Maintain Context Throughout

After every significant action:
- Update killchain_context.json
- Write decisions_made entries
- Add new blockers if encountered
- Queue questions_for_user if ambiguities arise

This ensures next resume is seamless.

## Time-Based Execution Limits

If the user specifies a time limit (e.g., "continue until 4:55PM"), implement the following:

### Time Monitoring
1. **Parse Time Limit**: Extract the target time from user's request
2. **Check Current Time**: Use `date` command via Bash tool to get current time
   ```bash
   date '+%H:%M'  # Returns time in HH:MM format
   ```
3. **Before Each Component**: Check if there's enough time remaining
4. **Graceful Stop**: If approaching deadline (within 5 minutes), stop gracefully:
   - Complete current stage (don't leave component mid-implementation)
   - Update `killchain_context.json` with current state
   - Inform user of progress and stopping point
   - Suggest using `/killchain-resume` to continue later

### Time Checking Strategy
- Check time before starting each new component
- Check time before launching each agent
- Allow current agent to finish if already in progress
- Never interrupt an agent mid-execution

### Stop Message Format
```markdown
## Time Limit Reached

**Target Time:** <user's specified time>
**Current Time:** <actual time from date command>
**Last Completed:** kcXXX
**Current Status:** <saved to context>

Execution stopped gracefully. Use `/killchain-resume` to continue.
```

## Resume from Specific Component

If user provides component number:
```
/killchain-resume kc015
```

1. Verify component exists
2. Check if already completed
3. If completed: ask user if they want to redo it
4. If not completed: start from there
5. Update current_component in context

## Intelligent Resume Features

### Detect Incomplete Work
- Check git commits vs completed_components
- Identify orphaned implementations
- Suggest cleanup or integration

### Context Refresh
- Review decisions_made to understand project choices
- Check for outdated dependencies
- Validate test suite still passes

### Time Estimation
Based on completed_components:
```
Average time per component: <calculate from timestamps>
Remaining components: <count>
Estimated completion: <estimate with confidence interval>
```

## Important Notes

- Always update killchain_context.json after changes
- Preserve decision history for continuity
- If context seems corrupted, ask user before proceeding
- Resume capability is why statelessness is powerful

---

Begin by loading and presenting the current project state.
