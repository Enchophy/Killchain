# KillChain Dangerous Mode

**⚠️ WARNING: Use only in trusted development environments!**

## What is Dangerous Mode?

Dangerous Mode is an optional configuration that grants Claude broad permissions upfront, reducing interruptions during KillChain execution. This mode is designed for experienced users who:

- Understand the security implications
- Work in isolated development environments
- Trust the codebase they're working on
- Want maximum automation with minimal prompts

## What Permissions Are Granted?

When Dangerous Mode is enabled, Claude automatically has permission to:

### File Operations
- Read any file in the project
- Write/modify any file in the project
- Create new files and directories
- Delete operations still require confirmation

### Git Operations
- View status, diffs, and logs
- Stage changes (git add)
- Create commits
- Push to remotes (except force push to main/master)
- All standard git operations

### Package Management
- Install packages via npm, pip, cargo, go, etc.
- Run package manager scripts
- Update dependencies

### Testing & Quality
- Run test suites (pytest, jest, cargo test, etc.)
- Execute linters and formatters
- Run type checkers (mypy, TypeScript, etc.)
- Generate coverage reports

### Build Commands
- Run build systems (make, cmake, webpack, etc.)
- Execute compilation commands
- Bundle and package applications

## What is Still Protected?

Even in Dangerous Mode, certain operations are **blocked** or **require confirmation**:

### Blocked (Never Allowed)
- `rm -rf /` and similar destructive commands
- Force pushing to main/master branches
- Running arbitrary downloaded scripts (`curl | sh`)
- Filesystem formatting commands
- Fork bombs and similar attacks

### Requires Confirmation
- Deleting files
- Running commands with sudo
- Changing file permissions (chmod)
- Changing file ownership (chown)
- Killing processes

## Installation

### During Initial Setup

When running `./install.sh`, you'll be prompted:

```
Install dangerous mode settings? (y/N):
```

- Press `y` to enable Dangerous Mode immediately
- Press `n` to skip (recommended for first-time users)

### After Installation

To enable Dangerous Mode later:

```bash
cp settings.local.json.dangerous settings.local.json
```

To disable Dangerous Mode:

```bash
rm settings.local.json
# or
mv settings.local.json settings.local.json.backup
```

## Configuration File

The configuration is stored in `settings.local.json` (copied from `settings.local.json.dangerous`).

### Customizing Permissions

You can edit `settings.local.json` to customize which operations are allowed:

```json
{
  "xrayRules": [
    {
      "patterns": ["**/*"],
      "permissions": {
        "read": "always",    // Change to "ask" for confirmation
        "write": "always",   // Change to "ask" for confirmation
        "delete": "ask"
      }
    }
  ],
  "bashRules": [
    {
      "patterns": ["git*"],
      "permission": "always"  // Change to "ask" or "block"
    }
  ]
}
```

### Permission Levels

- `always` - Execute without asking
- `ask` - Prompt for confirmation
- `block` - Never allow

## Best Practices

### ✅ Safe Use Cases

- Personal hobby projects
- Throwaway prototypes
- Sandboxed development environments
- Docker containers
- Virtual machines
- Projects with good version control

### ❌ Avoid Using In

- Production environments
- Shared development machines
- Projects with sensitive data
- Unfamiliar codebases
- Public/shared repositories
- CI/CD pipelines

## Security Considerations

### Risks

1. **Unintended File Modifications**: Claude could modify important files
2. **Accidental Commits**: Changes might be committed without review
3. **Package Installation**: Dependencies could be installed without verification
4. **Resource Usage**: Tests and builds could consume significant resources

### Mitigations

1. **Use Version Control**: Always work in a git repository
2. **Review Changes**: Check `git status` and `git diff` frequently
3. **Backup Important Work**: Commit or stash before major operations
4. **Monitor Resource Usage**: Watch for unexpected CPU/memory usage
5. **Use Branches**: Never work directly on main/master
6. **Sandbox Environment**: Use containers or VMs when possible

## Troubleshooting

### Dangerous Mode Not Working

1. Check that `settings.local.json` exists in the project root
2. Verify file contents match `settings.local.json.dangerous`
3. Restart Claude Code to reload settings

### Too Many Permissions Granted

Edit `settings.local.json` and change specific permissions from `always` to `ask`:

```bash
# Edit the settings file
nano settings.local.json

# Or disable entirely
rm settings.local.json
```

### Permissions Still Being Asked

Some operations always require confirmation for safety:
- File deletion
- Sudo operations
- Force operations on protected branches

These cannot be bypassed even in Dangerous Mode.

## Comparison with Standard Mode

| Feature | Standard Mode | Dangerous Mode |
|---------|--------------|----------------|
| File reading | Asks permission | Automatic |
| File writing | Asks permission | Automatic |
| Git operations | Asks each time | Automatic |
| Package install | Asks permission | Automatic |
| Running tests | Asks permission | Automatic |
| Dangerous commands | Blocked | Blocked |
| File deletion | Asks permission | Asks permission |

## FAQ

**Q: Is Dangerous Mode actually dangerous?**
A: It increases automation but has safeguards. The main risk is unintended changes, not system damage.

**Q: Can I use this in production?**
A: No, never use Dangerous Mode in production environments.

**Q: Will this delete my files?**
A: No, file deletion always requires confirmation even in Dangerous Mode.

**Q: Can I customize which permissions are granted?**
A: Yes, edit `settings.local.json` to adjust individual permissions.

**Q: How do I know if Dangerous Mode is active?**
A: Check if `settings.local.json` exists in your project root.

**Q: Can this be used with KillChain's --dangerous-vibe-mode?**
A: Yes! They complement each other:
  - Dangerous Mode = fewer permission prompts
  - Dangerous Vibe Mode = auto-selects recommended options
  - Together = maximum automation

---

**Remember**: With great automation comes great responsibility. Always review changes before committing!
