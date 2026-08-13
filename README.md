# Octopad MCP

Connect supported AI clients to [Octopad](https://octopad.app). Octopad is the company brain where your AIs manage work and knowledge under the same structure and rules.

This public repository contains:

- setup guides for Octopad's hosted MCP connection
- optional Octoplan skills for Claude Code and Codex

It does not contain the Octopad service source code. MCP is the open standard that lets an AI client use tools from another service.

## Connect Octopad

Give your AI this repository URL and say:

> Connect Octopad using this repository.

The AI should read [INSTALL.md](INSTALL.md), detect its current client and add the direct MCP connection.

When the client asks you to authorize the connection in your browser:

1. Sign in or create an Octopad account.
2. Complete any required organization or membership setup.
3. Authorize the AI client where you started.

Then return to that client and confirm that it can use Octopad.

After the connection works:

1. Return to the AI client where you started.
2. Start a new conversation or task.
3. Send: **"Use Octopad. Start my onboarding."**

This starts guided onboarding inside your AI. Connecting the MCP does not install Octoplan.

Direct setup guides are available for:

- [Codex in the ChatGPT desktop app and Codex CLI](docs/clients/codex.md)
- [Claude and Claude Desktop](docs/clients/claude.md)
- [Claude Code](docs/clients/claude-code.md)
- [Cursor](docs/clients/cursor.md)
- [Gemini CLI](docs/clients/gemini-cli.md)

The MCP endpoint is:

```text
https://mcp.octopad.app/mcp
```

## ChatGPT app or direct MCP?

For regular ChatGPT conversations, install the official Octopad app. This is the supported customer-facing ChatGPT plugin. Open the current [ChatGPT directory](https://chatgpt.com/plugins) and search for `Octopad`. It needs no manual MCP setup. You do not need this repository to install it.

Use the direct MCP guides in this repository for Codex, Claude, Cursor, Gemini CLI and other compatible MCP clients.

Both routes connect to Octopad. The marketplaces in this repository distribute optional Octoplan plugins. Those plugins add the skills described below; they are not the official Octopad app for ChatGPT.

## Optional Octoplan skills

Octoplan turns an idea or work stream into a detailed, ordered plan in Octopad. It is optional and has a different contract in each runtime:

| Distribution | Runtime | Version | What it does |
|---|---|---|---|
| [`octoplan-claude`](plugins/octoplan-claude/skills/octoplan/SKILL.md) | Claude Code | 1.4.0 | Plans the work. It never carries out the plan. |
| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 15.0.0 | Plans the work and can supervise delivery after the user authorizes that scope. |

Install a skill only when you want Octoplan. See [INSTALL.md](INSTALL.md#optional-octoplan-skills) for commands and migration steps.

## Privacy, access and removal

- A connected AI can use only the Octopad access granted to your account.
- Octopad encrypts data in transit and at rest.
- Neither Octopad nor its subprocessors use workspace content to train AI models. See the [Octopad Privacy Policy](https://www.octopad.ai/privacy).
- When content is sent to an external AI provider, that provider's terms and privacy policy apply.
- To revoke a connection, open **Octopad > Settings > AI clients** and sign out one client or all clients. Then remove Octopad from the client's connector or app settings if you no longer want it listed.

For a sensitive security report, follow [SECURITY.md](SECURITY.md).

## Help

- For a problem with these guides or an Octoplan skill, [open a GitHub issue](https://github.com/sudolab-co/octopad-mcp/issues/new).
- For an account or product problem, email [support@octopad.ai](mailto:support@octopad.ai).

## Repository layout

```text
INSTALL.md                               AI-readable install guide
docs/clients/                            Client-specific direct MCP guides
.claude-plugin/marketplace.json          Claude marketplace manifest
.agents/plugins/marketplace.json         Codex marketplace manifest
plugins/octoplan-claude/                 Optional Claude distribution
plugins/octoplan-codex/                  Optional Codex distribution
scripts/validate-repository.sh           Repository contract validation
```

## Releases

Each optional skill has its own version. Existing Claude releases use `octoplan-vX.Y.Z`. Future Claude releases use `octoplan-claude-vX.Y.Z`. Codex releases use `octoplan-codex-vX.Y.Z`. See [CHANGELOG.md](CHANGELOG.md) and [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
