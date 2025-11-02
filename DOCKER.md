# KillChain Docker Integration

Run KillChain in Docker containers for isolated, autonomous execution with dangerous mode.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Commands](#commands)
- [Dangerous Mode](#dangerous-mode)
- [Parallel Mode](#parallel-mode)
- [Troubleshooting](#troubleshooting)

## Overview

KillChain's Docker integration provides:

- **Isolated Execution**: Run Claude Code in a sandboxed container
- **Dangerous Mode**: Bypass permissions for fully autonomous operation
- **Terminal Access**: Run KillChain commands directly from your shell
- **Volume Mounting**: Changes persist in your project directory
- **Clean Environment**: Fresh Node.js + Claude Code environment each run

## Prerequisites

### Required

- **Docker**: Install Docker Desktop (macOS/Windows) or Docker Engine (Linux)
  - macOS: https://docs.docker.com/desktop/install/mac-install/
  - Linux: https://docs.docker.com/engine/install/
- **Python 3**: Required for the CLI wrapper script

### Optional (Recommended)

- **Anthropic API Key**: Set `ANTHROPIC_API_KEY` environment variable
  - If not set, Claude Code will prompt for authentication
- **KillChain Installation**: Run `./install.sh` to set up project structure

## Installation

### 1. Install KillChain with CLI

Run the installation script:

```bash
cd /path/to/KillChain
./install.sh
```

When prompted, choose **Yes** to install the CLI command.

### 2. Verify CLI Installation

Check that the command is available:

```bash
killchain --help
```

You should see the KillChain CLI help message.

### 3. Set API Key (Optional but Recommended)

Add your Anthropic API key to your environment, if needed:

```bash
# Bash/Zsh
echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.bashrc
source ~/.bashrc

# Or for Zsh
echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.zshrc
source ~/.zshrc
```

**Note**: If you don't set the API key, Claude Code will prompt for authentication when needed.

### 4. Verify Docker

Ensure Docker is running:

```bash
docker --version
docker ps
```

## Usage

### Basic Workflow

1. **Navigate to your project**:
   ```bash
   cd /path/to/your/project
   ```

2. **Run a KillChain command**:
   ```bash
   killchain plan
   ```

3. **Follow interactive prompts** to select dangerous mode and parallel mode

4. **Claude Code launches** in a Docker container and executes the command

### Quick Examples

```bash
# Interactive mode (prompts for options)
killchain plan

# Dangerous mode with prompts
killchain execute --dangerous

# Full autonomous mode (no prompts)
killchain resume --dangerous --parallel

# View status (no Docker needed)
killchain status
```

## Commands

All slash commands are available via the CLI:

| Command | Description | Docker Required |
|---------|-------------|-----------------|
| `killchain plan` | Initialize planning phase, create master plan | Yes |
| `killchain execute` | Begin implementation with multi-agent pipeline | Yes |
| `killchain resume` | Resume from saved checkpoint | Yes |
| `killchain status` | Display progress, metrics, blockers | No |
| `killchain toolcheck` | Validate tool availability | Yes |
| `killchain approve` | Approve milestone checkpoint | Yes |
| `killchain revise` | Request changes at milestone | Yes |
| `killchain rollback` | Revert specific component via git | Yes |

### Command Flags

- `--dangerous`: Enable dangerous mode (bypass all permissions)
- `--parallel`: Enable parallel agent execution
- `--help`: Show help message

## Dangerous Mode

### What is Dangerous Mode?

Dangerous mode uses Docker to empower Claude to run fully autonomously by bypassing all permissions. Claude will be able to:

- Execute any shell commands
- Modify any files in the mounted directory
- Install packages (npm, pip, cargo, etc.)
- Make git commits and push to remotes
- Run tests and build commands

### When to Use

✅ **Use dangerous mode when**:
- Working on isolated test projects
- Prototyping new features
- Running in CI/CD pipelines
- You trust the task completely

❌ **Do NOT use dangerous mode when**:
- Working with sensitive codebases
- Production environments
- Shared repositories without backups
- You're unsure of what Claude will do

### How to Enable

#### Option 1: Command-line flag
```bash
killchain execute --dangerous
```

#### Option 2: Interactive prompt
```bash
killchain execute
# Answer 'y' when prompted about dangerous mode
```

### Safety Tips

1. **Always use version control**: Commit your work before running dangerous mode
2. **Use Docker**: The container provides isolation from your host system
3. **Review changes**: Check git diff after execution
4. **Start small**: Test with simple tasks before complex projects
5. **Have backups**: Keep backups of important projects

## Parallel Mode

Parallel mode allows multiple agents to run simultaneously, speeding up execution but using more tokens.

### How to Enable

#### Option 1: Command-line flag
```bash
killchain execute --parallel
```

#### Option 2: Interactive prompt
```bash
killchain execute
# Answer 'y' when prompted about parallel mode
```

### Trade-offs

**Pros**:
- ⚡ Faster execution (multiple agents work concurrently)
- 🎯 Better for large projects with many components

**Cons**:
- 💰 Higher token usage (multiple agents running)
- 🔍 More complex to debug if issues arise

## Troubleshooting

### Docker Image Not Found

**Error**: `Cannot find killchain:latest image`

**Solution**: The CLI will automatically build the image on first run. If it fails:

```bash
# Manually build the image
cd /path/to/KillChain
docker build -t killchain:latest docker/
```

### API Key Not Set

**Note**: `ANTHROPIC_API_KEY environment variable is not set`

**This is optional**. Claude Code will prompt for authentication if needed.

```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

### Permission Denied

**Error**: `Permission denied when copying to /usr/local/bin`

**Solution**: Use sudo or install to user directory:

```bash
# Option 1: Use sudo
sudo cp bin/killchain /usr/local/bin/killchain
sudo chmod +x /usr/local/bin/killchain

# Option 2: Install to user directory
mkdir -p ~/.local/bin
cp bin/killchain ~/.local/bin/killchain
chmod +x ~/.local/bin/killchain
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Docker Not Running

**Error**: `Cannot connect to the Docker daemon`

**Solution**: Start Docker Desktop or Docker Engine:

```bash
# macOS: Open Docker Desktop application

# Linux: Start Docker service
sudo systemctl start docker
```

### Volume Mount Issues

**Error**: Files not persisting or not visible in container

**Solution**: Ensure you're running from the project directory:

```bash
cd /path/to/your/project
killchain plan  # Mounts $PWD to /app
```

### .claude Directory Not Found

**Error**: `Warning: No .claude directory found in /app`

**Solution**: Install KillChain to your project first:

```bash
cd /path/to/your/project
/path/to/KillChain/install.sh
```

### Python Not Found

**Error**: `/usr/bin/env: 'python3': No such file or directory`

**Solution**: Install Python 3:

```bash
# macOS
brew install python3

# Ubuntu/Debian
sudo apt-get install python3

# Fedora/RHEL
sudo dnf install python3
```

### Claude Code CLI Not Installing

**Error**: Image builds but Claude not found

**Solution**: The Dockerfile installs Claude Code automatically. If it fails:

```bash
# Check npm registry
npm search @anthropic-ai/claude-code

# Manually test installation
docker run --rm -it node:18 npm install -g @anthropic-ai/claude-code
```

## Advanced Usage

### Custom Docker Image

Build with a custom tag:

```bash
cd docker
docker build -t my-killchain:custom .
```

Then modify `bin/killchain` to use your custom image name.

### Running Without CLI

You can run Docker commands manually:

```bash
docker run --rm -it \
  -v $(pwd):/app \
  -e ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY" \
  -w /app \
  killchain:latest \
  claude --dangerously-skip-permissions /killchain-plan
```

### Debugging the Container

Start an interactive shell in the container:

```bash
docker run --rm -it \
  -v $(pwd):/app \
  -e ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY" \
  -w /app \
  --entrypoint /bin/bash \
  killchain:latest
```

### Using docker-compose (Future)

A `docker-compose.yml` file may be added in future releases for easier orchestration.

## Security Considerations

### Container Isolation

- The container runs as a non-root user (`myuser`)
- Limited to the mounted project directory
- Network access is available (for API calls)

### Host System Access

- Container can only access the mounted directory (`$PWD`)
- Cannot access parent directories or other projects
- Docker socket is NOT mounted (cannot control Docker from container)

### API Key Security

- API key is passed as environment variable
- Not stored in the container
- Remove key from environment when not needed:
  ```bash
  unset ANTHROPIC_API_KEY
  ```

## Best Practices

1. **Start without dangerous mode**: Run a command first without `--dangerous` to see what Claude wants to do
2. **Use git branches**: Work on feature branches, not main
3. **Review before committing**: Check `git diff` after execution
4. **Keep .kcplan in version control**: Track your KillChain plans
5. **Use status command**: Check progress with `killchain status` (no Docker needed)
6. **Test in throwaway projects**: Practice with test projects first

## Getting Help

- **KillChain Issues**: https://github.com/anthropics/claude-code/issues
- **Docker Issues**: https://docs.docker.com/get-started/
- **Claude Code Docs**: https://docs.claude.com/

## Related Documentation

- [README.md](README.md) - Main KillChain documentation
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide
- [DANGEROUS_MODE.md](DANGEROUS_MODE.md) - Dangerous mode details

---

**Happy orchestrating! 🚀**
