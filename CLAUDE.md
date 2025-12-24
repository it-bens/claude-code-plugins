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
  "source": "./plugins/plugin-name",
  "category": "development"
}
```

### Adding a New Plugin

When adding a new plugin:

1. Create the plugin in `plugins/<plugin-name>/` using `/create-plugin`
2. Add entry to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "<plugin-name>",
     "source": "./plugins/<plugin-name>",
     "category": "<category>"
   }
   ```
3. Update the "Available Plugins" table in `README.md`

### Claude Web Compatibility

Skills use `allowed-tools` in frontmatter to restrict tool access in Claude Code. This field does NOT work in Claude Web.

To create Claude Web-compatible ZIPs that strip `allowed-tools`:

```bash
./build-skill-for-web.sh ./plugins/<plugin>/skills/<skill>
```

### Directory Purposes

| Path | Purpose |
|------|---------|
| `plugins/` | Plugin implementations (skills, agents, commands, hooks) |
| `plugin-tests/` | BATS tests for hook scripts |
| `docs/` | Source documentation used to create skills (not distributed) |
| `.claude-plugin/marketplace.json` | Marketplace registry |
| `.github/scripts/setup-bats.sh` | BATS test framework setup |
| `build-skill-for-web.sh` | Creates Claude Web ZIPs |
