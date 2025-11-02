# KillChain Docker Image
# Provides Claude Code CLI with KillChain integration in a containerized environment

# Use an official Node.js image as the base
FROM node:18

# Install the Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code

# Create a non-root user for security
RUN groupadd mygroup && useradd -ms /bin/bash -g mygroup myuser

# Switch to non-root user
USER myuser

# Set the working directory inside the container
# This will be mounted to the user's project directory
WORKDIR /app

# Set the default command to start an interactive Claude session
# The CLI wrapper will override this with specific slash commands
CMD ["claude", "--dangerously-skip-permissions"]
