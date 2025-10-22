# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Project Overview

KillChain is a multi-agent project orchestration system for Claude Code. It breaks down complex software projects into manageable components and coordinates specialized agents to implement, test, and integrate them systematically.

## Repository Structure

```
KillChain/
├── .claude/
│   ├── commands/          # Slash commands for user interaction
│   │   ├── killchain-plan.md
│   │   ├── killchain-execute.md
│   │   ├── killchain-resume.md
│   │   ├── killchain-status.md
│   │   ├── killchain-approve.md
│   │   ├── killchain-revise.md
│   │   └── killchain-rollback.md
│   │
│   ├── agents/            # Specialized agent prompts
│   │   ├── killchain_plan_subplanner.md
│   │   ├── killchain_exec_developer.md
│   │   ├── killchain_exec_qa.md
│   │   ├── killchain_exec_reviewer.md
│   │   ├── killchain_exec_kanban.md
│   │   └── killchain_exec_e2e.md
│   │
│   └── killchain/
│       └── templates/     # Template files for new projects
│           ├── kcXXX_template.md
│           ├── killchain_init_template.md
│           ├── killchain_context_template.json
│           └── killchain_manifest_template.json
│
├── install.sh             # Installation script
├── README.md              # User-facing documentation
├── initial_prompt.md      # System design specification
├── CLAUDE.md             # This file (development guidance)
└── LICENSE               # MIT License

```

## Development Workflow

### Working on KillChain Itself

When modifying KillChain components:

1. **Slash Commands** ([.claude/commands/](.claude/commands/))
   - These are markdown files that Claude Code interprets
   - Each command should be self-contained with clear instructions
   - Use consistent structure and formatting
   - Test commands after modifications

2. **Agent Prompts** ([.claude/agents/](.claude/agents/))
   - Detailed instructions for specialized agents
   - Must be comprehensive and autonomous
   - Include error handling guidance
   - Specify expected inputs and outputs

3. **Templates** ([.claude/killchain/templates/](.claude/killchain/templates/))
   - Standard formats for component files
   - JSON templates must be valid JSON
   - Markdown templates should follow consistent structure

### Testing Changes

1. Test installation:
   ```bash
   ./install.sh --dir /tmp/test-project
   ```

2. Test individual commands by using them in Claude Code

3. Verify agent prompts produce expected behavior when launched via Task tool

### Code Style

- Use clear, descriptive variable names
- Comment complex logic
- Keep functions focused and modular
- Follow existing patterns in the codebase

### Documentation

- Update README.md for user-facing changes
- Update this CLAUDE.md for development changes
- Keep initial_prompt.md as the source of truth for system design
- Add comments in code for future maintainers
