# IT Martin Bens - Claude Code Marketplace

A personal collection of skills, agents, MCP servers, hooks, and LSPs to enhance Claude Code with capabilities across software development and beyond.

## Installation

Add this marketplace to Claude Code:

```bash
/plugin marketplace add it-bens/claude-code-plugins
```

Then browse and install plugins:

```bash
/plugin
```

## Available Plugins

| Plugin | Description | Category |
|--------|-------------|----------|
| [prompt-engineering](./plugins/prompt-engineering/) | Expert prompt engineering for Claude 4 models with production-ready templates | Productivity |
| [python-plan-optimizer](./plugins/python-plan-optimizer/) | Analyze Python code in planning documents for design principles and improvement opportunities | Development |
| [native-tools-enforcer](./plugins/native-tools-enforcer/) | Enforces use of Claude Code native tools instead of bash equivalents via PreToolUse hook | Guardrails |

## Structure

```
claude-code-plugins/
├── .claude-plugin/
│   └── marketplace.json        # Marketplace manifest (references plugins)
├── .github/
│   └── scripts/
│       └── setup-bats.sh       # BATS test framework setup
├── plugins/
│   ├── prompt-engineering/     # Prompt engineering plugin
│   ├── python-plan-optimizer/  # Python plan optimizer plugin
│   └── native-tools-enforcer/  # Native tools enforcement hook
│       ├── .claude-plugin/
│       │   └── plugin.json
│       └── hooks/
│           └── scripts/
│               └── check-native-tools.sh
├── plugin-tests/               # BATS tests for hook scripts
│   ├── test_helper/
│   └── native-tools-enforcer/
├── build-skill-for-web.sh      # Build script for Claude Web
└── README.md
```

## Path Resolution

### Marketplace Paths (`marketplace.json`)

The `source` field in each plugin entry is resolved **relative to the marketplace.json file location** (not the `pluginRoot`):

```json
{
  "metadata": {
    "pluginRoot": "./plugins"  // Informational only, not used for resolution
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",  // Relative to marketplace.json
      "category": "development"
    }
  ]
}
```

**Key rule:** `source` must start with `./` and include the full path from `.claude-plugin/` to the plugin directory.

### Plugin Paths (`plugin.json`)

Each plugin's `plugin.json` uses paths relative to its own location. Component discovery (skills, agents, hooks) is automatic from the plugin root.

## Building Skills for Claude Web

Skills in this marketplace use the `allowed-tools` frontmatter field to restrict tool access in Claude Code. However, this field is **only supported in Claude Code** and must be removed for Claude Web compatibility.

The `build-skill-for-web.sh` script creates Claude Web-compatible ZIP archives by stripping Claude Code-specific fields:

```bash
./build-skill-for-web.sh ./plugins/<plugin>/skills/<skill>
# Output: <skill-name>.zip
```

### Why is this necessary?

According to [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills):

> `allowed-tools` is only supported for Skills in Claude Code.

Skills uploaded to Claude Web will ignore this field. The build script ensures clean ZIPs without unsupported fields.

## Contributing

This is a personal marketplace, but suggestions and feedback are welcome via GitHub issues.

## License

MIT
