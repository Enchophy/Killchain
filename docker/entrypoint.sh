#!/bin/bash
# KillChain Docker Entrypoint
# Initializes the container and executes Claude Code with the specified command

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if ANTHROPIC_API_KEY is set (optional - Claude Code will prompt if needed)
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Note: ANTHROPIC_API_KEY environment variable is not set${NC}"
    echo -e "${YELLOW}Claude Code will prompt for authentication if needed${NC}"
    echo
fi

# Check if .claude directory exists in mounted volume
if [ ! -d "/app/.claude" ]; then
    echo -e "${YELLOW}Warning: No .claude directory found in /app${NC}"
    echo -e "${YELLOW}Make sure you've run 'killchain init' or installed KillChain first${NC}"
fi

# Execute the command passed to the container
# This will be something like: claude --dangerously-skip-permissions /killchain-plan
exec "$@"
