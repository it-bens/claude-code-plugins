@README.md

# Development Guide

## Required: Use Plugin-Dev Tools

For ALL plugin and skill development, use the plugin-dev tools instead of manual creation:

| Task | Tool |
|------|------|
| Create new plugin | `/create-plugin` command |
| Plugin structure guidance | `plugin-dev:plugin-structure` skill |
| Create/edit skills | `plugin-dev:skill-development` skill |
| Create agents | `plugin-dev:agent-development` skill |
| Create commands | `plugin-dev:command-development` skill |
| Create hooks | `plugin-dev:hook-development` skill |
| MCP integration | `plugin-dev:mcp-integration` skill |
| Validate plugin | `plugin-dev:plugin-validator` agent |
| Review skill quality | `plugin-dev:skill-reviewer` agent |

**Do not manually create plugin structures without consulting these tools first.**

## Project-Specific Context

### Plugin Registration

Each plugin has its own `.claude-plugin/plugin.json` for metadata. Plugins are also registered in the marketplace at `.claude-plugin/marketplace.json`:

```json
{
  "name": "plugin-name",
  "source": "plugin-name",
  "category": "development"
}
```

### Claude Web Compatibility

Skills use `allowed-tools` in frontmatter to restrict tool access in Claude Code. This field does NOT work in Claude Web.

To create Claude Web-compatible ZIPs that strip `allowed-tools`:

```bash
./build-skill-for-web.sh ./plugins/<plugin>/skills/<skill>
```

### Directory Purposes

| Path | Purpose |
|------|---------|
| `plugins/` | Plugin implementations (skills, agents, commands) |
| `docs/` | Source documentation used to create skills (not distributed) |
| `.claude-plugin/marketplace.json` | Marketplace registry |
| `build-skill-for-web.sh` | Creates Claude Web ZIPs |
