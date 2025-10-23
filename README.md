# KillChain

**Multi-Agent Project Orchestration System for Claude Code**

KillChain is a sophisticated agent orchestration system designed to manage complex software projects while maintaining low token usage and enabling stateless operation. The system breaks down large projects into manageable components and coordinates specialized agents to implement, test, and integrate them systematically.

## Key Features

- **Context Window Optimization**: Delegates work to specialized agents to keep main context minimal
- **Stateless Resume**: Pick up where you left off across multiple sessions
- **Structured Planning**: Break complex projects into trackable, manageable components
- **Multi-Agent Quality Pipeline**: Developer → QA → Code Review → E2E Testing
- **Zero Tech Debt Policy**: No TODOs, placeholders, or shortcuts allowed
- **Git Integration**: One commit per component for easy rollback
- **Progress Tracking**: Real-time status monitoring with TodoWrite integration
- **Bulk Permission Requests**: One-time upfront permissions to avoid interruptions
- **Interactive Suggestions**: Multiple-choice questions for handling blockers and ambiguities
- **Parallel Execution**: Process multiple independent components concurrently
- **Smart Python Detection**: Auto-detects conda vs standard Python environments

## Use Cases

KillChain is ideal for:
- New project creation from scratch
- Large-scale codebase refactoring
- Complex feature implementation across multiple files
- Data/ML pipeline development
- Projects requiring resumable, long-running development

## Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/Enchophy/killchain.git

# Run the installer
cd killchain
./install.sh
```

### Manual Install

```bash
# Copy KillChain files to your project's .claude directory
cp -r .claude/commands/* your-project/.claude/commands/
cp -r .claude/agents/* your-project/.claude/agents/
cp -r .claude/killchain/* your-project/.claude/killchain/
```

### Install to Specific Directory

```bash
./install.sh --dir /path/to/your/project
```

## Quick Start

### 1. Plan Your Project

Start Claude Code in your project directory and run:

```
/killchain-plan
```

This will:
- Guide you through project requirements discussion
- Create a high-level implementation plan
- Break down components into detailed specifications
- Generate component files (kc001, kc002, etc.)

**Tip:** Set thinking tokens to maximum during planning for best results.

### 2. Execute Implementation

After approving your plan:

```
/killchain-execute
```

This will:
- Process each component sequentially
- Coordinate specialized agents (developer, QA, reviewer, E2E)
- Track progress and maintain state
- Create git commits for each component
- Pause at milestones for your approval

### 3. Monitor Progress

Check status anytime:

```
/killchain-status
```

Shows:
- Completion percentage
- Current component being worked on
- Time estimates based on velocity
- Blockers or issues
- Recent activity

### 4. Resume After Interruption

If you need to stop and come back later:

```
/killchain-resume
```

Picks up exactly where you left off using checkpoint data.

## Architecture

### Command Overview

| Command | Purpose |
|---------|---------|
| `/killchain-plan` | Initialize planning phase and create component breakdown |
| `/killchain-execute` | Begin implementation with multi-agent coordination |
| `/killchain-resume` | Resume from last checkpoint |
| `/killchain-status` | Display progress and metrics |
| `/killchain-toolcheck` | Validate tool availability before execution |
| `/killchain-approve` | Approve milestone and continue |
| `/killchain-revise` | Request changes at milestone |
| `/killchain-rollback` | Revert specific component (requires git) |

### Agent Overview

| Agent | Role |
|-------|------|
| **killchain_plan_subplanner** | Creates detailed component specifications from high-level plan |
| **killchain_exec_developer** | Implements code according to specifications |
| **killchain_exec_qa** | Tests implementation and verifies acceptance criteria |
| **killchain_exec_reviewer** | Reviews code for style, security, and performance |
| **killchain_exec_kanban** | Manages TODO status tracking across files |
| **killchain_exec_e2e** | Performs integration testing between components |

### Quality Pipeline

Every component goes through:

```
1. Developer Agent
   ↓ (implements code)

2. QA Agent
   ↓ (tests, verifies acceptance criteria)

3. Reviewer Agent
   ↓ (code review for style/security/performance)

4. Kanban Agent
   ↓ (updates status)

5. Git Commit
   ↓

6. E2E Testing (periodic)
   ↓

7. Next Component
```

## Project Structure

When you use KillChain, it creates:

```
your-project/
├── .claude/
│   ├── commands/
│   │   ├── killchain-plan.md
│   │   ├── killchain-execute.md
│   │   ├── killchain-resume.md
│   │   ├── killchain-status.md
│   │   ├── killchain-approve.md
│   │   ├── killchain-revise.md
│   │   └── killchain-rollback.md
│   │
│   ├── agents/
│   │   ├── killchain_plan_subplanner.md
│   │   ├── killchain_exec_developer.md
│   │   ├── killchain_exec_qa.md
│   │   ├── killchain_exec_reviewer.md
│   │   ├── killchain_exec_kanban.md
│   │   └── killchain_exec_e2e.md
│   │
│   └── killchain/
│       ├── templates/
│       │   ├── kcXXX_template.md
│       │   ├── killchain_init_template.md
│       │   ├── killchain_context_template.json
│       │   └── killchain_manifest_template.json
│       │
│       ├── killchain_init.md           # Master plan
│       ├── killchain_context.json      # Project state
│       ├── killchain_manifest.json     # Project metadata
│       │
│       └── kc*.md                      # Component files
│           ├── kc001_component.md
│           ├── kc002_component.md
│           └── kc003_component.md
│
└── your-code/
    └── ... (implemented by KillChain)
```

## Component File Structure

Each component follows a standard format:

```markdown
# kcXXX Component Name

## Overview
Brief description of purpose

## Dependencies
- Component dependencies (other kcXXX files)
- External dependencies (libraries)

## TODO
[ ] Task 1
[ ] Task 2

## Task 1

### TODO
[ ] Sub-task 1.1
[ ] Sub-task 1.2

### Implementation Details
- Approach description
- Key considerations
- Type specifications
- Required assertions

### Acceptance Criteria
[ ] Criterion 1
[ ] Criterion 2
```

## File Naming Convention

Components use this naming pattern:

```
kc<NNN>_<description>.md
```

- **NNN**: Zero-padded sequence number (001, 002, 003...)
- **description**: Snake_case component name

**Status tracking** is maintained in `killchain_context.json` under the `component_status` field, not in filenames.

**Examples:**
- `kc001_data_loader.md` - First component
- `kc015_validation_logic.md` - Component 15
- `kc023_output_writer.md` - Component 23

**Status values in context:**
- `"todo"` - Not started
- `"in_progress"` - Work in progress
- `"in_qa"` - Being tested
- `"in_review"` - Being code reviewed
- `"completed"` - Finished and approved
- `"blocked"` - Has blockers

## State Management

### Context File

`.claude/killchain/killchain_context.json` tracks:
- Current component being worked on
- Completed components list
- Active tasks and their status
- Blockers and issues
- Decisions made during development
- Questions for user
- Performance metrics

### Manifest File

`.claude/killchain/killchain_manifest.json` contains:
- Project metadata
- Technology stack
- Dependencies
- File structure
- Component mapping
- Build configuration

## Quality Standards

KillChain enforces strict quality requirements:

### Type Safety
- All functions must have type hints
- Static type checking must pass
- Runtime assertions for type enforcement

### Testing
- Minimum 80% code coverage
- Unit tests for all functions
- Integration tests between components
- E2E tests for critical paths

### Documentation
- Docstrings on all functions/classes
- Usage examples for public APIs
- Inline comments explaining "why", not "what"

### Code Quality
- **Zero tolerance for TODOs or FIXMEs**
- All code must be production-ready
- Linting must pass
- Code review required

## Advanced Features

### Bulk Permission Requests

Before execution begins, KillChain requests all necessary permissions upfront in a single prompt:
- File operations (create, edit, read)
- Testing commands (pytest, mypy, linters)
- Git operations (status, add, commit, diff)
- Package management (pip, npm, cargo)
- Build and run commands

Grant blanket permission for the entire execution to avoid constant interruptions, or opt for granular control where you approve each operation type individually.

### Interactive Suggestions System

When blockers or ambiguities arise during execution, KillChain presents multiple-choice questions:

```markdown
# 1 - Should we use async or sync API?
- A: Async API (better performance, more complex)
- B: Sync API (simpler, easier to debug)
- C: Both with adapter pattern
- Other? (please specify)

Recommendation: B (Sync API) - simpler for initial implementation
```

This allows you to guide decisions without breaking agent flow.

### Parallel Execution

Execute independent components concurrently:

```
/killchain-execute --parallel
/killchain-resume --parallel
```

Automatically detects which components can run in parallel based on dependencies. Processes 1-10 components per batch while maintaining test isolation.

### Dangerous Vibe Mode

For fully automated execution:

```
/killchain-execute --dangerous-vibe-mode
/killchain-resume --dangerous-vibe-mode
```

**WARNING**: Claude auto-selects recommended answers without confirmation. Use only when you trust Claude's judgment completely. All decisions are logged in context for review.

### Milestone Checkpoints

KillChain pauses at major milestones for your approval:
- `/killchain-approve` - Continue to next phase
- `/killchain-revise` - Request changes before continuing

### Rollback

Safely revert components using git:

```
/killchain-rollback kc015
```

Reverts the component's git commit and resets it to todo status.

### Time Monitoring

Stop execution at a specific time:

```
"Please work on this until 3:30 PM"
"Continue execution until 5:00 PM"
```

KillChain monitors the clock and gracefully stops at the requested time, saving state for later resume.

### Python Environment Detection

KillChain automatically detects your Python environment:
- **Conda environments**: Uses `python` and `python -m pip`
- **Standard Python**: Uses `python3` and `python3 -m pip`

This ensures all test commands, type checkers, and linters work correctly regardless of your setup.

### Budget Controls

Set spending limits per component (default: $50):

```json
{
  "budget": {
    "max_per_component": 50,
    "currency": "USD"
  }
}
```

System warns at 75% and halts at 100% of budget.

## Examples

### Example 1: Chess Game

**Planning Output:**
```
1. kc001_game_piece_class.md
2. kc002_game_board_class.md
3. kc003_move_validation.md
4. kc004_game_state.md
5. kc005_gameplay_mechanics.md
6. kc006_gameplay_loop.md
7. kc007_ui_display.md
```

**Execution:**
Each component is implemented, tested, reviewed, and committed before moving to the next.

### Example 2: Webcam Recorder

**Planning Output:**
```
1. kc001_terminal_interface.md
2. kc002_camera_class.md
3. kc003_recording_logic.md
4. kc004_video_processing.md
5. kc005_configuration.md
```

## Best Practices

### During Planning

1. **Be Specific**: Provide detailed requirements and constraints
2. **Think Sequentially**: Order components by execution flow
3. **Break Down Large Tasks**: Keep components focused and manageable
4. **Define Interfaces**: Specify inputs/outputs between components
5. **Use Maximum Thinking**: Set thinking tokens high for thorough planning

### During Execution

1. **Grant Permissions**: Use bulk permission request for smoother execution
2. **Review Component Files**: Check specifications before approving execution
3. **Monitor Progress**: Use `/killchain-status` regularly or check TodoWrite updates
4. **Answer Suggestions**: Respond to multiple-choice questions when blockers arise
5. **Use Milestones**: Approve at checkpoints to maintain control
6. **Consider Parallel Mode**: Use `--parallel` for independent components
7. **Commit Often**: Git commits per component enable safe rollback

### For Best Results

1. **Start with Clear Goals**: Know what you want to build
2. **Review Master Plan**: Ensure high-level plan makes sense
3. **Check Component Dependencies**: Verify ordering is logical
4. **Trust the Process**: Let agents do their specialized work
5. **Iterate When Needed**: Use `/killchain-revise` for improvements

## Troubleshooting

### "Context file not found"

Run `/killchain-plan` first to initialize the project.

### "Component file missing"

Check `.claude/killchain/` directory. Re-run planning if files are missing.

### "Git repository required"

Initialize git for rollback functionality:
```bash
git init
```

### "Budget exceeded"

Increase budget in context file or approve override when prompted.

### Agent seems stuck

Check for blockers in `/killchain-status` and address them.

## Git Integration

### Commit Format

Each component gets one commit:

```
[feat] Component kc015: One-sentence summary

- Specific implementation detail 1
- Specific implementation detail 2
- Specific implementation detail 3
```

### Rollback Support

Because each component has its own commit, you can safely rollback:

```bash
# Via KillChain
/killchain-rollback kc015

# Or manually via git
git revert <commit-hash>
```

## Configuration

### Thinking Tokens

- **Planning**: Maximum thinking tokens recommended
- **Execution**: Default thinking tokens sufficient
- **E2E Testing**: Higher thinking tokens for thorough analysis

### Auto-Approval

Skip milestone checkpoints:

```
/killchain-approve --auto
```

Use cautiously - removes human oversight.

## FAQ

**Q: Can I modify component files manually?**
A: Yes, edit `.claude/killchain/kcXXX_*.md` files as needed. Status is tracked in `killchain_context.json`, so update that file if you change component status manually.

**Q: What happens if I interrupt execution?**
A: Use `/killchain-resume` to continue from the last checkpoint.

**Q: Can I skip components?**
A: Yes, delete or rename component files, or mark them complete manually.

**Q: How do I add more components mid-execution?**
A: Create new `kcXXX` files following the naming convention and template.

**Q: Can I use KillChain for non-code projects?**
A: Yes, but it's optimized for software development with type safety and testing requirements.

**Q: Does KillChain work with any programming language?**
A: Yes, the system is language-agnostic. Specify your language during planning.

**Q: What if an agent makes a mistake?**
A: The QA and review agents catch most issues. Use `/killchain-revise` or `/killchain-rollback` if needed.

**Q: What's the difference between `--parallel` and `--dangerous-vibe-mode`?**
A: `--parallel` executes multiple components concurrently (faster). `--dangerous-vibe-mode` auto-selects answers to questions (more autonomous). They can be combined.

**Q: How do I use the suggestions system?**
A: When KillChain encounters ambiguity, it presents multiple-choice questions. Select A, B, C, or provide your own answer. The recommended option is marked.

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) file

## Support

- **Issues**: Report bugs at [GitHub Issues](https://github.com/Enchophy/killchain/issues)
- **Documentation**: See [initial_prompt.md](initial_prompt.md) for detailed system design

## Acknowledgments

Built for [Claude Code](https://claude.com/claude-code) by Anthropic.

---

**Version:** 2.0.0

**What's New in 2.0:**
- Interactive suggestions system (multiple-choice questions)
- Bulk permission requests
- Parallel execution mode (`--parallel`)
- Dangerous vibe mode (`--dangerous-vibe-mode`)
- Python environment auto-detection (conda support)
- Time monitoring capability
- TodoWrite integration
- Simplified file naming (status in context only)

**Created with:** KillChain (yes, it was built using itself!)
