# KillChain: Approve Milestone

Approve the current milestone checkpoint and continue execution.

## Approval Process

### 1. Verify Checkpoint Context

This command should only be used when execution has paused at a milestone checkpoint. Check the conversation history for a milestone checkpoint message.

If no checkpoint is active, inform the user:
```
No active checkpoint found. This command is used to approve
milestones during execution. Use /killchain-execute to start
or resume execution.
```

### 2. Record Approval

Update `.claude/killchain/killchain_context.json`:

```json
{
  "decisions_made": [
    {
      "timestamp": "<current_timestamp>",
      "type": "milestone_approval",
      "milestone": "<milestone_name>",
      "components_reviewed": ["kcXXX", "kcYYY"],
      "decision": "approved",
      "notes": "<any user comments>"
    }
  ]
}
```

### 3. Clear Checkpoint State

Remove checkpoint flag from context:
```json
{
  "active_checkpoint": null,
  "checkpoint_cleared_at": "<timestamp>"
}
```

### 4. Resume Execution

Continue with the next component or phase:

**If mid-execution:**
- Move to next component in sequence
- Update current_component in context
- Launch developer agent for next kcXXX file

**If at phase boundary:**
- Begin next major phase
- Update phase tracking in context
- Continue with standard execution workflow

**If at E2E testing gate:**
- Integration tests passed
- Move to next batch of components
- Continue execution

### 5. Confirm Resumption

Show user:
```markdown
✓ Milestone approved

Resuming execution...
- Next component: kcXXX
- Components remaining: <count>
- Estimated time: <estimate>
```

## Approval with Comments

If user provides additional context:
```
/killchain-approve "Focus on performance in upcoming components"
```

Record the comment in decisions_made:
```json
{
  "decision": "approved",
  "notes": "Focus on performance in upcoming components",
  "action_items": [
    "Add performance considerations to review criteria"
  ]
}
```

Apply the guidance to subsequent execution:
- Update agent prompts to include user's focus areas
- Add specific criteria to review checklists
- Note in component files if needed

## Auto-Approval Option

If user wants to skip future checkpoints for this session:
```
/killchain-approve --auto
```

Update context:
```json
{
  "auto_approve_milestones": true,
  "auto_approve_set_at": "<timestamp>"
}
```

Continue execution without pausing at checkpoints until:
- Critical blocker encountered
- User intervention needed
- Project completion

## Important Notes

- Approval is permanent - cannot undo via KillChain commands
- Git commits may allow rollback at component level
- Approval means "proceed with next phase"
- Does not skip quality gates (QA, review, E2E still run)

---

Record approval and resume execution.
