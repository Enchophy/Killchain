# KillChain Docker Files

This directory contains Docker configuration for running KillChain in containers.

## Files

- **Dockerfile** - Image definition with Node.js and Claude Code CLI
- **entrypoint.sh** - Container initialization script
- **.dockerignore** - Excludes unnecessary files from build context

## Usage

### Via CLI (Recommended)

Use the `killchain` command from your terminal:

```bash
killchain plan
killchain execute --dangerous
killchain resume --dangerous --parallel
```

The CLI automatically builds and manages the Docker image.

### Manual Build

Build the image manually:

```bash
cd /path/to/KillChain/docker
docker build -t killchain:latest .
```

### Manual Run

Run commands manually:

```bash
docker run --rm -it \
  -v $(pwd):/app \
  -e ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY" \
  -w /app \
  killchain:latest \
  claude --dangerously-skip-permissions /killchain-plan
```

## Image Details

- **Base**: node:18
- **Includes**: @anthropic-ai/claude-code CLI
- **User**: Non-root (myuser:mygroup)
- **Working Directory**: /app (mounted from host)

## Security

- Runs as non-root user for security
- Only has access to mounted directory
- Docker socket is not mounted (no Docker-in-Docker)

## Troubleshooting

See [DOCKER.md](../DOCKER.md) for troubleshooting guide.
