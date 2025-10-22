# KillChain: Resume Operation

You are resuming a KillChain project from a previous session. This command enables stateless operation across multiple Claude Code sessions.

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
1. Present each question with options
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
4. Commit progress with git

### 8. Maintain Context Throughout

After every significant action:
- Update killchain_context.json
- Write decisions_made entries
- Add new blockers if encountered
- Queue questions_for_user if ambiguities arise

This ensures next resume is seamless.

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
