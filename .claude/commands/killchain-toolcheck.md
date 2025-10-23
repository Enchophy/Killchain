# KillChain: Tool Availability Check

Verify that all necessary development tools are installed before beginning project execution. This prevents mid-execution failures due to missing dependencies.

## Tool Check Process

### 1. Detect Project Type

First, identify what kind of project this is by examining files:

```bash
# Check for Python project
[ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ] && echo "Python project detected"

# Check for Node.js project
[ -f "package.json" ] && echo "Node.js project detected"

# Check for Rust project
[ -f "Cargo.toml" ] && echo "Rust project detected"

# Check for Go project
[ -f "go.mod" ] && echo "Go project detected"
```

### 2. Check Core Tools

These tools are needed for all KillChain projects:

#### Git (Required)
```bash
if which git > /dev/null 2>&1; then
  git_version=$(git --version)
  echo "✓ git: $git_version"
else
  echo "✗ git: NOT FOUND (REQUIRED)"
  echo "  Install: https://git-scm.com/downloads"
fi
```

#### jq (Recommended for JSON manipulation)
```bash
if which jq > /dev/null 2>&1; then
  jq_version=$(jq --version)
  echo "✓ jq: $jq_version"
else
  echo "✗ jq: NOT FOUND (recommended for context file manipulation)"
  echo "  Install: brew install jq  # macOS"
  echo "  Install: sudo apt install jq  # Ubuntu/Debian"
fi
```

### 3. Check Language-Specific Tools

Based on detected project type, check relevant tools:

#### Python Tools

```bash
# Python interpreter
if which conda > /dev/null 2>&1; then
  python_version=$(python --version 2>&1)
  echo "✓ python: $python_version (via conda)"
  PYTHON_CMD="python"
elif which python3 > /dev/null 2>&1; then
  python_version=$(python3 --version 2>&1)
  echo "✓ python3: $python_version"
  PYTHON_CMD="python3"
else
  echo "✗ python: NOT FOUND (REQUIRED for Python projects)"
  echo "  Install: https://www.python.org/downloads/"
fi

# pip
if which pip > /dev/null 2>&1 || which pip3 > /dev/null 2>&1; then
  pip_version=$(${PYTHON_CMD} -m pip --version 2>&1)
  echo "✓ pip: $pip_version"
else
  echo "✗ pip: NOT FOUND (REQUIRED for Python projects)"
  echo "  Install: ${PYTHON_CMD} -m ensurepip --upgrade"
fi

# pytest
if ${PYTHON_CMD} -m pytest --version > /dev/null 2>&1; then
  pytest_version=$(${PYTHON_CMD} -m pytest --version 2>&1)
  echo "✓ pytest: $pytest_version"
else
  echo "✗ pytest: NOT FOUND (recommended for testing)"
  echo "  Install: ${PYTHON_CMD} -m pip install pytest"
fi

# mypy
if ${PYTHON_CMD} -m mypy --version > /dev/null 2>&1; then
  mypy_version=$(${PYTHON_CMD} -m mypy --version 2>&1)
  echo "✓ mypy: $mypy_version"
else
  echo "✗ mypy: NOT FOUND (recommended for type checking)"
  echo "  Install: ${PYTHON_CMD} -m pip install mypy"
fi

# black
if ${PYTHON_CMD} -m black --version > /dev/null 2>&1; then
  black_version=$(${PYTHON_CMD} -m black --version 2>&1)
  echo "✓ black: $black_version"
else
  echo "✗ black: NOT FOUND (recommended for code formatting)"
  echo "  Install: ${PYTHON_CMD} -m pip install black"
fi

# pylint
if ${PYTHON_CMD} -m pylint --version > /dev/null 2>&1; then
  pylint_version=$(${PYTHON_CMD} -m pylint --version 2>&1 | head -1)
  echo "✓ pylint: $pylint_version"
else
  echo "✗ pylint: NOT FOUND (recommended for linting)"
  echo "  Install: ${PYTHON_CMD} -m pip install pylint"
fi

# coverage/pytest-cov
if ${PYTHON_CMD} -m pytest --cov --version > /dev/null 2>&1; then
  cov_version=$(${PYTHON_CMD} -m pip show pytest-cov 2>&1 | grep Version)
  echo "✓ pytest-cov: $cov_version"
else
  echo "✗ pytest-cov: NOT FOUND (recommended for coverage reports)"
  echo "  Install: ${PYTHON_CMD} -m pip install pytest-cov"
fi
```

#### Node.js Tools

```bash
# Node.js
if which node > /dev/null 2>&1; then
  node_version=$(node --version)
  echo "✓ node: $node_version"
else
  echo "✗ node: NOT FOUND (REQUIRED for Node.js projects)"
  echo "  Install: https://nodejs.org/"
fi

# npm
if which npm > /dev/null 2>&1; then
  npm_version=$(npm --version)
  echo "✓ npm: $npm_version"
else
  echo "✗ npm: NOT FOUND (REQUIRED for Node.js projects)"
  echo "  Install: Comes with Node.js"
fi

# yarn (optional alternative to npm)
if which yarn > /dev/null 2>&1; then
  yarn_version=$(yarn --version)
  echo "✓ yarn: $yarn_version"
else
  echo "⚠ yarn: NOT FOUND (optional alternative to npm)"
  echo "  Install: npm install -g yarn"
fi

# npx
if which npx > /dev/null 2>&1; then
  npx_version=$(npx --version)
  echo "✓ npx: $npx_version"
else
  echo "✗ npx: NOT FOUND (recommended for running packages)"
  echo "  Install: Comes with npm 5.2+"
fi
```

#### Rust Tools

```bash
# cargo
if which cargo > /dev/null 2>&1; then
  cargo_version=$(cargo --version)
  echo "✓ cargo: $cargo_version"
else
  echo "✗ cargo: NOT FOUND (REQUIRED for Rust projects)"
  echo "  Install: https://rustup.rs/"
fi

# rustc
if which rustc > /dev/null 2>&1; then
  rustc_version=$(rustc --version)
  echo "✓ rustc: $rustc_version"
else
  echo "✗ rustc: NOT FOUND (REQUIRED for Rust projects)"
  echo "  Install: https://rustup.rs/"
fi
```

#### Go Tools

```bash
# go
if which go > /dev/null 2>&1; then
  go_version=$(go version)
  echo "✓ go: $go_version"
else
  echo "✗ go: NOT FOUND (REQUIRED for Go projects)"
  echo "  Install: https://golang.org/dl/"
fi
```

### 4. Check Optional Tools

```bash
# Docker
if which docker > /dev/null 2>&1; then
  docker_version=$(docker --version)
  echo "✓ docker: $docker_version"
else
  echo "⚠ docker: NOT FOUND (optional, for containerization)"
  echo "  Install: https://docs.docker.com/get-docker/"
fi

# Make
if which make > /dev/null 2>&1; then
  make_version=$(make --version | head -1)
  echo "✓ make: $make_version"
else
  echo "⚠ make: NOT FOUND (optional, for build automation)"
  echo "  Install: xcode-select --install  # macOS"
  echo "  Install: sudo apt install build-essential  # Ubuntu/Debian"
fi
```

### 5. Generate Report

Present consolidated report to user:

```markdown
# KillChain Tool Availability Report

**Project Type:** <detected types>
**Checked:** <timestamp>

## ✓ Available Tools (N)

<list of available tools with versions>

## ✗ Missing Required Tools (N)

<list of missing required tools with install instructions>

## ⚠ Missing Recommended Tools (N)

<list of missing recommended tools with install instructions>

---

### Summary

**Status:** <Ready/Not Ready/Partially Ready>

<If missing required tools:>
**Action Required:** Install missing required tools before execution.

<If missing recommended tools:>
**Recommendation:** Install recommended tools for best experience.

### Bulk Install Commands

<If Python project with missing tools:>
```bash
# Install all missing Python tools
${PYTHON_CMD} -m pip install pytest mypy black pylint pytest-cov
```

<If Node.js project with missing tools:>
```bash
# Install development dependencies
npm install --save-dev jest eslint prettier @types/node
```
```

### 6. Offer Automated Installation

After presenting report:

```markdown
Would you like me to install the missing tools automatically?

Options:
1. Install all missing tools
2. Install only required tools
3. Install only recommended tools
4. Let me install manually (skip)

Your choice (1-4):
```

**If user chooses 1, 2, or 3:**
- Generate appropriate install commands
- Execute installations with user's permission
- Re-run tool check to verify installations

**If user chooses 4:**
- Skip installation
- Proceed with execution (warn if required tools missing)

### 7. Save Results to Context

Store tool availability in `killchain_context.json`:

```json
{
  "tool_availability": {
    "checked_at": "<timestamp>",
    "project_types": ["python"],
    "python_command": "python",
    "available_tools": {
      "git": "2.39.0",
      "python": "3.11.5",
      "pytest": "7.4.0",
      "mypy": "1.5.1",
      "black": "23.7.0"
    },
    "missing_tools": {
      "pylint": "recommended",
      "jq": "recommended"
    },
    "status": "ready"
  }
}
```

This information can be used:
- To avoid re-checking tools in same session
- To inform agent which tools are available
- To adjust execution strategy based on available tools

## Important Notes

- Run this check before `/killchain-execute` for best results
- Can be run standalone anytime to verify environment
- Automatically runs as part of `/killchain-execute` if not already done
- Results cached in context to avoid redundant checks
- Re-run if environment changes (new virtual environment, etc.)

---

Begin tool availability check now.
