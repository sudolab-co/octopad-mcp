# Octopad MCP

Connect any supported AI client to [Octopad](https://octopad.app), the company brain where your AIs manage work and knowledge under the same structure and rules.

## Install Octopad

Give your AI this repository URL and say:

> Install Octopad from this repository.

The AI should read [INSTALL.md](INSTALL.md), detect the client it is running in, and install the direct MCP connection. You will then sign in to Octopad, or create an account, in your browser.

Direct setup guides are also available for:

- [ChatGPT desktop app and Codex CLI](docs/clients/codex.md)
- [Claude and Claude Desktop](docs/clients/claude.md)
- [Claude Code](docs/clients/claude-code.md)
- [Cursor](docs/clients/cursor.md)
- [Gemini CLI](docs/clients/gemini-cli.md)

The MCP endpoint is:

```text
https://mcp.octopad.app/mcp
```

## Direct MCP or the official ChatGPT plugin?

The official Octopad plugin is the easiest setup inside ChatGPT when you prefer a [reviewed directory release](https://developers.openai.com/plugins/deploy/submission). This repository still installs direct MCP by default. Direct MCP is useful when you work in Codex or another MCP client, or when you want tool and contract updates that require a new plugin package before the next directory review is complete.

Compatible server-only fixes reach both paths as soon as Octopad deploys them. The difference matters only when an update changes the reviewed plugin package or listing.

## Optional skills

The direct MCP connection is the Octopad installation. Skills are optional workflows installed separately.

This repository currently includes Octoplan, a planning protocol that turns an Octopad work stream into detailed, ordered tasks:

| Distribution | Runtime | Version |
|---|---|---|
| [`octoplan-claude`](plugins/octoplan-claude/skills/octoplan/SKILL.md) | Claude Code | 1.4.0 |
| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 10.2.0 |

Install a skill only when the user asks for Octoplan or another optional workflow. See [INSTALL.md](INSTALL.md#optional-octoplan-skills) for commands and migration steps.

## Repository layout

```text
INSTALL.md                               AI-readable install router
docs/clients/                            Client-specific direct MCP guides
.claude-plugin/marketplace.json          Claude marketplace manifest
.agents/plugins/marketplace.json         Codex marketplace manifest
plugins/octoplan-claude/                 Optional Claude distribution
plugins/octoplan-codex/                  Optional Codex distribution
scripts/validate-repository.sh           Repository contract validation
```

## Releases

Each optional skill has its own version line. Claude tags use `octoplan-claude-vX.Y.Z`; Codex tags use `octoplan-codex-vX.Y.Z`. See [CHANGELOG.md](CHANGELOG.md) and [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
