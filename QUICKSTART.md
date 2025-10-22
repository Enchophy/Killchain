# KillChain Quick Start Guide

Get started with KillChain in 5 minutes!

## Installation

### Option 1: Quick Install (Recommended)

```bash
# Clone the repository
git clone https://github.com/Enchophy/killchain.git
cd killchain

# Run installer
./install.sh
```

### Option 2: Install to Existing Project

```bash
cd your-project
/path/to/killchain/install.sh --dir .
```

## Your First KillChain Project

### Step 1: Initialize Your Project

Open Claude Code in your project directory and run:

```
/killchain-plan
```

You'll be guided through:
1. Describing your project goals
2. Choosing technology stack
3. Breaking down into components

**Example conversation:**

```
User: I want to build a simple todo list application with a Python backend and basic CLI

Claude: I'll help you plan this todo list application. Let me break this down:

1. kc001 - Task Data Model
2. kc002 - Task Storage (file-based)
3. kc003 - Task CRUD Operations
4. kc004 - CLI Interface
5. kc005 - Main Application Loop

Does this structure look good?

User: Yes, looks great!

Claude: Creating detailed component specifications...
[Creates kc001_t_task_data_model.md through kc005_t_main_loop.md]

Component planning complete! Review the files in .claude/killchain/
Ready to start implementation? Use /killchain-execute
```

### Step 2: Review the Plan

Check the generated files:

```bash
ls .claude/killchain/
# kc001_t_task_data_model.md
# kc002_t_task_storage.md
# kc003_t_task_crud.md
# kc004_t_cli_interface.md
# kc005_t_main_loop.md
# killchain_init.md
```

Open and review `killchain_init.md` for the master plan.

Review individual component files (kcXXX) to see detailed specs.

### Step 3: Execute Implementation

When you're ready:

```
/killchain-execute
```

**What happens:**

```
Component kc001: Task Data Model
  ▸ Developer Agent implementing...
  ✓ Implementation complete
  ▸ QA Agent testing...
  ✓ All tests pass (coverage: 95%)
  ▸ Code Review Agent reviewing...
  ✓ Code review approved
  ✓ Component kc001 complete!

Moving to kc002...
```

### Step 4: Monitor Progress

Check status anytime:

```
/killchain-status
```

**Example output:**

```
# KillChain Status Report
Project: Todo List Application
Generated: 2025-01-01 10:30:00

## Progress Overview
Total Components: 5
Completed: 2 (40%)
In Progress: 1
Pending: 2

Progress: [████████░░░░░░░░░░░░] 40%

## Current Component
ID: kc003
Name: Task CRUD Operations
Status: Development in progress
Started: 10:25:00

## Timeline
Started: 10:00:00
Total Time: 30 minutes
Average per Component: 15 minutes
Estimated Remaining: 45 minutes
```

### Step 5: Handle Checkpoints

At major milestones, KillChain will pause:

```
## Milestone Checkpoint: Foundation Complete

Completed Components:
- kc001: Task Data Model (✓)
- kc002: Task Storage (✓)

Integration Status:
- E2E tests: Pass

Next Steps:
- kc003: Task CRUD Operations
- kc004: CLI Interface
- kc005: Main Application Loop

Ready to proceed?
```

**Approve to continue:**
```
/killchain-approve
```

**Or request changes:**
```
/killchain-revise
```

## Common Workflows

### Resume After Break

If you close Claude Code:

```
/killchain-resume
```

Picks up exactly where you left off.

### Check What's Done

```
/killchain-status
```

Shows completion percentage and current work.

### Undo a Component

If you want to redo something:

```
/killchain-rollback kc003
```

Reverts the component and marks it todo again.

## Tips for Success

### 1. Be Specific in Planning

**Bad:**
> "Build a web app"

**Good:**
> "Build a todo list web app with Python Flask backend, SQLite database, and REST API. Include user authentication and CRUD operations for tasks."

### 2. Review Component Files

Before executing, open the kcXXX files and check:
- Are the tasks clear?
- Are the acceptance criteria correct?
- Are dependencies in the right order?

### 3. Use Milestones

Don't use `--auto-approve`. Review at checkpoints to:
- Verify quality
- Adjust direction if needed
- Understand what was built

### 4. Trust the Quality Pipeline

Every component goes through:
- Developer (implementation)
- QA (testing)
- Reviewer (code review)
- E2E (integration testing)

This catches issues early.

### 5. Keep Git Commits

Each component gets one commit:
```
[feat] Component kc003: Task CRUD operations

- Implemented create_task() function
- Implemented read_task() function
- Implemented update_task() function
- Implemented delete_task() function
```

Easy to rollback if needed!

## Example Projects

### Simple CLI Tool (5 components)

```
1. Argument parsing
2. Core logic
3. Output formatting
4. Error handling
5. Main entry point
```

**Time:** ~1-2 hours

### REST API (12 components)

```
1. Database models
2. Database connection
3. CRUD operations
4. API routes
5. Authentication
6. Middleware
7. Error handling
8. Validation
9. Testing utilities
10. Integration tests
11. API documentation
12. Deployment config
```

**Time:** ~4-6 hours

### Data Processing Pipeline (8 components)

```
1. Data loader
2. Data validator
3. Data transformer
4. Data aggregator
5. Output writer
6. Error recovery
7. Logging
8. Pipeline orchestrator
```

**Time:** ~2-3 hours

## Troubleshooting

### "No killchain files found"

Run `/killchain-plan` first to create the project structure.

### "Component file not found: kcXXX"

Check if file exists:
```bash
ls .claude/killchain/kc*.md
```

If missing, you may need to re-run planning.

### "Git repository required"

For rollback functionality:
```bash
git init
git add .
git commit -m "Initial commit"
```

### Agent seems stuck

Check for blockers:
```
/killchain-status
```

Look for blockers or questions that need your input.

## Next Steps

- Read the full [README.md](README.md) for advanced features
- Check [initial_prompt.md](initial_prompt.md) for system design details
- Try building a simple project to learn the workflow

## Getting Help

- **Issues:** Report bugs on GitHub
- **Questions:** Check README.md FAQ section

---

**Happy building with KillChain!**
