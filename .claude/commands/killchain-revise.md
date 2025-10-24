# KillChain: Revise Milestone

Request revisions at a milestone checkpoint before continuing execution.

## Revision Process

### 1. Verify Checkpoint Context

This command should only be used when execution has paused at a milestone checkpoint. Check the conversation history for a checkpoint message.

If no checkpoint is active:
```
No active checkpoint found. This command is used to request
revisions at milestones during execution. Use /killchain-status
to see current project state.
```

### 2. Gather Revision Requirements

Ask the user what needs to be revised:

```markdown
## Revision Request

Please specify what you'd like to revise:

1. **Component-specific changes**
   - Which component(s) need revision? (kcXXX)
   - What specific changes are needed?

2. **Cross-cutting changes**
   - Architecture adjustments?
   - Style or convention changes?
   - Performance optimizations?

3. **Quality concerns**
   - Test coverage issues?
   - Security vulnerabilities?
   - Documentation gaps?

4. **Scope changes**
   - Add new requirements?
   - Remove functionality?
   - Reprioritize components?

Please describe your revision requests in detail.
```

### 3. Categorize Revisions

Organize user's requests:

**Immediate Revisions (current milestone):**
- Changes to completed components in this batch
- Fixes that block forward progress
- Critical issues

**Future Revisions (upcoming work):**
- Guidance for remaining components
- New requirements to incorporate
- Process adjustments

**Plan Revisions (structural changes):**
- Component reordering
- New components needed
- Components to remove

### 4. Execute Immediate Revisions

For each component requiring changes:

**Update Status in Context:**
Update `killchain_context.json` to mark component status as "in_revision"

**Create Revision Tasks:**
Add to component file:
```markdown
## REVISION TASKS
[ ] <user request 1>
[ ] <user request 2>
[ ] <user request 3>

### Revision Context
Requested by user at milestone <name>
Reason: <user's explanation>
```

**Launch Developer Agent:**
```
You are revising component kcXXX based on user feedback.

Component file: .kcplan/kcXXX_name.md

Revision tasks are listed in the "REVISION TASKS" section.

Your tasks:
1. Review original implementation
2. Implement each revision task
3. Maintain all existing acceptance criteria
4. Update tests as needed
5. Ensure no regressions introduced

After completion, mark revision tasks as completed and report back.
```

**Run Quality Pipeline:**
After developer completes revisions:
1. Launch QA agent to validate changes
2. Launch reviewer for code review
3. Update kanban status when approved

**Update Context:**
```json
{
  "decisions_made": [
    {
      "timestamp": "<timestamp>",
      "type": "milestone_revision",
      "milestone": "<name>",
      "components_revised": ["kcXXX"],
      "revision_reason": "<user's explanation>",
      "revision_tasks": ["task1", "task2"]
    }
  ]
}
```

### 5. Apply Future Guidance

For guidance affecting upcoming components:

**Update Master Plan:**
Add section to `killchain_init.md`:
```markdown
## User Guidance (Updated <timestamp>)

### <Topic>
<User's guidance>

Applied to: kc<start> through kc<end>
```

**Update Affected Component Files:**
Add notes to pending (todo) components:
```markdown
## User Guidance
<Relevant guidance for this component>
```

**Update Agent Prompts:**
When launching agents for future components, include:
```
IMPORTANT: User has provided guidance:
<user's guidance>

Ensure your implementation incorporates this guidance.
```

### 6. Handle Plan Revisions

If structural changes needed:

**Component Reordering:**
1. Verify dependencies allow reordering
2. Rename files with new sequence numbers
3. Update killchain_init.md with new order
4. Update context with current_component

**New Components:**
1. Determine insertion point
2. Renumber subsequent components
3. Create new kcXXX_name.md file(s)
4. Add to killchain_context.json with status "todo"
5. Update total count and estimates

**Component Removal:**
1. Verify no dependencies on removed component
2. Remove kcXXX file(s)
3. Renumber subsequent components
4. Update plan and estimates

### 7. Commit Revisions

If git repository:
```bash
git add <revised files>
git commit -m "[revision] Milestone revisions: <summary>

- Revised kcXXX: <change>
- Revised kcYYY: <change>
- Updated plan: <change>"
```

### 8. Present Revision Summary

Show user:
```markdown
## Revisions Applied

### Immediate Changes
- kcXXX: <revision summary>
- kcYYY: <revision summary>

### Future Guidance
- <topic>: Will be applied to kc<start>-kc<end>

### Plan Updates
- <structural change>

### Next Steps
<Describe what happens next>

Ready to proceed? Use /killchain-approve to continue.
```

## Revision Patterns

### Minor Revisions
- Small code changes
- Documentation updates
- Test improvements
→ Quick fix, continue execution

### Major Revisions
- Architecture changes
- Significant refactoring
- Cross-component impacts
→ May need to re-plan, discuss with user

### Blocking Revisions
- Critical bugs
- Security issues
- Data corruption risks
→ Must fix before proceeding

## Important Notes

- Revisions go through full quality pipeline (QA, review)
- No shortcuts - maintain quality standards
- Document revision reasoning in context
- Update estimates if revisions add time
- Can request multiple rounds of revision if needed

---

Begin by asking the user what they'd like to revise.
