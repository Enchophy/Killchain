# KillChain: Rollback Component

Revert a specific component implementation to enable safe experimentation.

## Prerequisites

This command requires:
1. Git repository initialized (`.git/` exists)
2. Component commits follow KillChain format (one commit per kcXXX)
3. Component file exists in `.claude/killchain/`

## Rollback Process

### 1. Parse Component ID

Extract component ID from command:
```
/killchain-rollback kc015
```

Component ID: `kc015`

### 2. Verify Component Exists

```bash
# Check for component file
ls .claude/killchain/kc015_*.md
```

If not found:
```
Component kc015 not found in project.
Use /killchain-status to see all components.
```

### 3. Check Git Repository

```bash
# Verify git repo
if [ ! -d .git ]; then
  echo "Error: This command requires a git repository."
  echo "Initialize with: git init"
  exit 1
fi
```

### 4. Find Component Commit

Search git history for component commit:

```bash
# Find commit with kcXXX in message
git log --all --oneline --grep="kc015"
```

Expected format:
```
abc1234 [feat] Component kc015: <description>
```

If multiple commits found:
```
Multiple commits found for kc015:
1. abc1234 - [feat] Component kc015: Initial implementation
2. def5678 - [revision] kc015 revisions: <changes>

Which commit would you like to rollback?
Options:
- 'latest' - Rollback most recent kc015 commit
- 'all' - Rollback all kc015 commits
- <commit_hash> - Rollback specific commit
```

### 5. Identify Affected Files

Determine what files were changed in the commit:

```bash
# Show files in commit
git show --name-only <commit_hash>
```

Present to user:
```markdown
## Rollback Preview: kc015

**Commit:** <commit_hash>
**Message:** <commit_message>
**Date:** <commit_date>

### Files to Revert
<list of files from commit>

### Warning
This will:
- Revert all code changes from this commit
- Update component status to 'active' or 'todo'
- Create a revert commit in git history
- NOT delete the files (use git if you want that)

Proceed with rollback? (yes/no)
```

### 6. Wait for Confirmation

If user confirms, proceed. If not, abort.

### 7. Execute Rollback

**Revert Git Commit:**
```bash
# Create revert commit
git revert <commit_hash> --no-edit
```

This creates a new commit that undoes the changes.

**Update Component Status:**
Update `killchain_context.json` to mark component as "todo" or "rollback"

**Update Component File:**
Add rollback notice to file:
```markdown
## ROLLBACK NOTICE
**Date:** <timestamp>
**Reason:** User-initiated rollback
**Previous Status:** Completed
**New Status:** Todo

All tasks need to be re-implemented.

---

# kc015 <Component Name>
...
```

Reset all task checkboxes:
```markdown
## TODO
[ ] Task 1  # Was: [ completed ]
[ ] Task 2  # Was: [ completed ]
```

### 8. Update Context

Update `.claude/killchain/killchain_context.json`:

```json
{
  "completed_components": [
    // Remove "kc015" from array
  ],
  "rollbacks": [
    {
      "component": "kc015",
      "timestamp": "<timestamp>",
      "commit_reverted": "<commit_hash>",
      "reason": "user_requested",
      "notes": "<any user comments>"
    }
  ],
  "decisions_made": [
    {
      "timestamp": "<timestamp>",
      "type": "rollback",
      "component": "kc015",
      "decision": "Rollback to re-implement with different approach"
    }
  ]
}
```

If this was current_component, set to previous component or leave as is.

### 9. Update Manifest

Update `.claude/killchain/killchain_manifest.json`:
- Remove file references from this component
- Adjust dependency tree if needed
- Update version with rollback note

### 10. Create Rollback Commit

Commit the KillChain file changes:
```bash
git add .claude/killchain/
git commit -m "[rollback] Rolled back component kc015

- Reverted implementation commit <commit_hash>
- Reset component status to todo
- Updated project context"
```

### 11. Present Results

Show user:
```markdown
## Rollback Complete: kc015

### Actions Taken
✓ Reverted commit <commit_hash>
✓ Updated component status: completed → todo
✓ Reset task checkboxes
✓ Updated project context
✓ Created rollback commits

### Current State
- Component file: .claude/killchain/kc015_<name>.md
- Status: Todo (tracked in killchain_context.json)
- Git history: Contains revert commit

### Next Steps
Options:
1. Re-implement using /killchain-execute
2. Revise component plan before implementing
3. Skip this component (if no longer needed)

The component is ready for a fresh implementation attempt.
```

## Rollback Multiple Components

If user wants to rollback a range:
```
/killchain-rollback kc010-kc015
```

1. Verify all components in range
2. Show combined preview
3. Revert in reverse order (kc015, kc014, kc013, ...)
4. Update context accordingly

## Rollback to Checkpoint

If user wants to rollback to a specific state:
```
/killchain-rollback --to kc010
```

1. Rollback all components AFTER kc010
2. Keep kc010 and earlier intact
3. Reset current_component to kc010

## Partial Rollback

If user wants to keep some changes:
```
/killchain-rollback kc015 --keep <file_path>
```

1. Perform normal rollback
2. Cherry-pick specific files to restore
3. Create new commit with kept changes

## Safety Features

### Prevent Accidental Rollback
- Always require confirmation
- Show clear preview of what will change
- Explain consequences

### Dependency Checking
- Warn if other components depend on rolled-back component
- Suggest rolling back dependent components too

### Backup Option
```
/killchain-rollback kc015 --backup
```
Create a branch before rollback:
```bash
git branch backup-kc015-$(date +%Y%m%d_%H%M%S)
```

## Important Notes

- Rollback uses `git revert`, not `git reset` (preserves history)
- One commit per component makes rollback granular
- Can rollback multiple times if needed
- Does not affect other components unless dependencies exist
- Context is updated to reflect rollback

---

Specify which component to rollback.
