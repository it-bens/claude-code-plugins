@README.md

## Directory & File Structure

```
plugins/native-tools-enforcer/
├── README.md
├── CLAUDE.md
├── CHANGELOG.md
├── .claude-plugin/
│   └── plugin.json
└── hooks/
    ├── hooks.json                    # PreToolUse hook configuration
    └── scripts/
        └── check-native-tools.sh     # Pattern matching & blocking logic
```

## Component Overview

This plugin provides:
- **PreToolUse Hook** (`hooks/hooks.json`) - Intercepts Bash tool calls
- **Validation Script** (`hooks/scripts/check-native-tools.sh`) - Blocks/warns commands with native tool suggestions

**No commands, agents, skills, or MCP servers** - hooks-only plugin.

## Key Functions

### `check_and_block(pattern, tool, description)`
Blocks command execution (exit 2) if pattern matches. Used for commands where native tools fully replace bash equivalents.

### `warn_about_native(pattern, tool, tip)`
Shows warning but allows execution (exit 0). Used for commands where native tools can help but aren't full replacements (e.g., `ls` - Glob can list files but can't show permissions/sizes).

## Key Navigation Points

| Task | Primary File | Key Concepts |
|------|--------------|--------------|
| Add blocked command | `check-native-tools.sh` | Add `check_and_block` call in category section |
| Add warned command | `check-native-tools.sh` | Add `warn_about_native` call |
| Change block message | `check-native-tools.sh` | Edit `check_and_block()` function output |
| Adjust hook timeout | `hooks.json` | `timeout` field (default: 5s) |
| Update pattern regex | `check-native-tools.sh` | First argument to `check_and_block` |

## When to Modify What

**Adding new blocked command** → Add `check_and_block` call in appropriate category section of `check-native-tools.sh`

**Adding warned command** → Add `warn_about_native` call (for commands where native tools help but aren't full replacements)

**Changing message format** → Edit function body in `check-native-tools.sh`

**Adjusting pattern sensitivity** → Modify regex (first arg); use `(^|;|&&)` to avoid false positives

## Integration Points

- **jq** dependency for JSON parsing
- Affects all Bash invocations (main conversation + agents)
- Requires Claude Code restart after installation

## Testing

BATS tests are located in `plugin-tests/native-tools-enforcer/`:

```bash
# Setup (first time only)
./.github/scripts/setup-bats.sh

# Run tests
.bats/bats-core/bin/bats plugin-tests/native-tools-enforcer/*.bats

# Filter by tag
.bats/bats-core/bin/bats --filter-tags blocking plugin-tests/native-tools-enforcer/
.bats/bats-core/bin/bats --filter-tags warning plugin-tests/native-tools-enforcer/
```

### Manual Testing

```bash
# Should block (exit 2)
echo '{"tool_input": {"command": "grep foo"}}' | ./hooks/scripts/check-native-tools.sh

# Should warn (exit 0, with output)
echo '{"tool_input": {"command": "ls"}}' | ./hooks/scripts/check-native-tools.sh

# Should allow (exit 0, no output)
echo '{"tool_input": {"command": "git status"}}' | ./hooks/scripts/check-native-tools.sh
```

## Related Documentation

- [Official hook example](https://github.com/anthropics/claude-code/blob/main/examples/hooks/bash_command_validator_example.py)
- Related issues: [#1386](https://github.com/anthropics/claude-code/issues/1386), [#10056](https://github.com/anthropics/claude-code/issues/10056), [#5892](https://github.com/anthropics/claude-code/issues/5892)
