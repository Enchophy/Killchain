#!/usr/bin/env bash

# KillChain Installation Script
# Installs KillChain multi-agent system for Claude Code

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation paths
INSTALL_DIR="${KILLCHAIN_INSTALL_DIR:-.}"
CLAUDE_DIR="$INSTALL_DIR/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
AGENTS_DIR="$CLAUDE_DIR/agents"
KILLCHAIN_DIR="$INSTALL_DIR/.kcplan"
TEMPLATES_DIR="$KILLCHAIN_DIR/templates"

# Script directory (where this script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Functions
print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                                                        ║"
    echo "║                KillChain Installer                     ║"
    echo "║        Multi-Agent System for Claude Code              ║"
    echo "║                                                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}▸ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

check_prerequisites() {
    print_step "Checking prerequisites..."

    # Check for bash version
    if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
        print_warning "Bash version 4+ recommended (found ${BASH_VERSION})"
    else
        print_success "Bash version: ${BASH_VERSION}"
    fi

    # Check if running in Claude Code context
    if [ ! -d ".claude" ] && [ "$FORCE_INSTALL" != "true" ]; then
        print_warning "No .claude directory found"
        echo "This appears not to be a Claude Code project directory."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Installation cancelled"
            exit 1
        fi
    fi
}

create_directories() {
    print_step "Creating directory structure..."

    # Create directories if they don't exist
    mkdir -p "$CLAUDE_DIR"
    mkdir -p "$COMMANDS_DIR"
    mkdir -p "$AGENTS_DIR"
    mkdir -p "$KILLCHAIN_DIR"
    mkdir -p "$TEMPLATES_DIR"

    print_success "Directories created"
}

install_commands() {
    print_step "Installing slash commands..."

    local commands=(
        "killchain-plan.md"
        "killchain-execute.md"
        "killchain-resume.md"
        "killchain-status.md"
        "killchain-approve.md"
        "killchain-revise.md"
        "killchain-rollback.md"
    )

    local installed=0
    for cmd in "${commands[@]}"; do
        local source="$SCRIPT_DIR/.claude/commands/$cmd"
        local dest="$COMMANDS_DIR/$cmd"

        if [ -f "$source" ]; then
            cp "$source" "$dest"
            ((installed++))
        else
            print_warning "Command file not found: $cmd"
        fi
    done

    print_success "Installed $installed slash commands"
}

install_agents() {
    print_step "Installing agent prompts..."

    local agents=(
        "killchain_plan_subplanner.md"
        "killchain_exec_developer.md"
        "killchain_exec_qa.md"
        "killchain_exec_reviewer.md"
        "killchain_exec_kanban.md"
        "killchain_exec_e2e.md"
    )

    local installed=0
    for agent in "${agents[@]}"; do
        local source="$SCRIPT_DIR/.claude/agents/$agent"
        local dest="$AGENTS_DIR/$agent"

        if [ -f "$source" ]; then
            cp "$source" "$dest"
            ((installed++))
        else
            print_warning "Agent file not found: $agent"
        fi
    done

    print_success "Installed $installed agent prompts"
}

install_templates() {
    print_step "Installing templates..."

    local templates=(
        "kcXXX_template.md"
        "killchain_init_template.md"
        "killchain_context_template.json"
        "killchain_manifest_template.json"
    )

    local installed=0
    for template in "${templates[@]}"; do
        local source="$SCRIPT_DIR/.kcplan/templates/$template"
        local dest="$TEMPLATES_DIR/$template"

        if [ -f "$source" ]; then
            cp "$source" "$dest"
            ((installed++))
        else
            print_warning "Template file not found: $template"
        fi
    done

    print_success "Installed $installed templates"
}

create_readme() {
    print_step "Creating README if needed..."

    local readme="$KILLCHAIN_DIR/README.md"
    if [ -f "$readme" ]; then
        print_warning "README already exists, skipping"
    else
        cat > "$readme" << 'EOF'
# KillChain Plan Directory

This directory contains KillChain project orchestration files.

## Contents

- `templates/` - Template files for new projects
- `killchain_init.md` - Master plan (created during planning)
- `killchain_context.json` - Project state and progress
- `killchain_manifest.json` - Project metadata
- `kc*.md` - Component specification files

## Usage

Use the slash commands in Claude Code:

- `/killchain-plan` - Start planning a new project
- `/killchain-execute` - Begin implementation
- `/killchain-resume` - Resume from checkpoint
- `/killchain-status` - View progress
- `/killchain-approve` - Approve milestone
- `/killchain-revise` - Request revisions
- `/killchain-rollback` - Rollback component

## File Naming Convention

Component files follow this pattern:
```
kc<NNN>_<description>.md
```

Where:
- `NNN` = Zero-padded sequence number (001, 002, etc.)
- `description` = Snake_case component name

Status is tracked in `killchain_context.json`, not in filenames.

## State Files

- **killchain_context.json**: Tracks current progress, decisions, blockers
- **killchain_manifest.json**: Project metadata, dependencies, structure

## Gitignore

This directory is typically added to `.gitignore` as plans are user-specific.

---

For more information, see the main KillChain README.
EOF
        print_success "Created KillChain README"
    fi
}

verify_installation() {
    print_step "Verifying installation..."

    local errors=0

    # Check commands
    local cmd_count=$(find "$COMMANDS_DIR" -name "killchain-*.md" 2>/dev/null | wc -l)
    if [ "$cmd_count" -ge 7 ]; then
        print_success "Found $cmd_count slash commands"
    else
        print_error "Expected 7 commands, found $cmd_count"
        ((errors++))
    fi

    # Check agents
    local agent_count=$(find "$AGENTS_DIR" -name "killchain_*.md" 2>/dev/null | wc -l)
    if [ "$agent_count" -ge 6 ]; then
        print_success "Found $agent_count agent prompts"
    else
        print_error "Expected 6 agents, found $agent_count"
        ((errors++))
    fi

    # Check templates
    local template_count=$(find "$TEMPLATES_DIR" -name "*template*" 2>/dev/null | wc -l)
    if [ "$template_count" -ge 4 ]; then
        print_success "Found $template_count templates"
    else
        print_error "Expected 4 templates, found $template_count"
        ((errors++))
    fi

    if [ "$errors" -eq 0 ]; then
        print_success "Installation verified successfully"
        return 0
    else
        print_error "Installation verification found $errors issue(s)"
        return 1
    fi
}

print_next_steps() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║            Installation Complete!                      ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo
    echo "Next steps:"
    echo
    echo "1. Open Claude Code in this directory"
    echo
    echo "2. Start a new project with:"
    echo "   /killchain-plan"
    echo
    echo "3. View available commands:"
    echo "   - /killchain-plan      - Start planning phase"
    echo "   - /killchain-execute   - Begin implementation"
    echo "   - /killchain-resume    - Resume from checkpoint"
    echo "   - /killchain-status    - View progress"
    echo "   - /killchain-approve   - Approve milestone"
    echo "   - /killchain-revise    - Request revisions"
    echo "   - /killchain-rollback  - Rollback component"
    echo
    echo "For more information, see:"
    echo "   - README.md (main documentation)"
    echo "   - .kcplan/README.md (usage guide)"
    echo
}

cleanup_on_error() {
    print_error "Installation failed, cleaning up..."
    # Could add cleanup logic here if needed
    exit 1
}

# Main installation flow
main() {
    trap cleanup_on_error ERR

    print_header

    check_prerequisites
    create_directories
    install_commands
    install_agents
    install_templates
    create_readme

    echo

    if verify_installation; then
        print_next_steps
    else
        print_error "Installation completed with warnings"
        echo "Some files may not have been installed correctly."
        echo "Please check the warnings above."
        exit 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_INSTALL="true"
            shift
            ;;
        --dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        --help)
            echo "KillChain Installation Script"
            echo
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  --force          Force installation even if .claude dir doesn't exist"
            echo "  --dir DIR        Install to specific directory (default: current)"
            echo "  --help           Show this help message"
            echo
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Run main installation
main
