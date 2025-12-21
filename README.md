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

## Structure

```
claude-code-plugins/
├── .claude-plugin/
│   └── marketplace.json     # Marketplace manifest (references plugins)
├── plugins/
│   └── prompt-engineering/  # Prompt engineering plugin
│       ├── .claude-plugin/
│       │   └── plugin.json  # Plugin manifest (authoritative metadata)
│       ├── skills/          # Claude Code skills
│       │   └── prompt-engineering/
│       │       ├── SKILL.md
│       │       ├── references/
│       │       └── examples/
│       ├── docs/            # Prompting documentation
│       └── project/         # Claude Web project files
├── build-skill-for-web.sh   # Build script for Claude Web
└── README.md
```

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
