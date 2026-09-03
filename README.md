# Octopad MCP

Connect supported AI clients to [Octopad](https://octopad.app). Octopad is the company brain where your AIs manage work and knowledge under the same structure and rules.

This public repository contains:

- setup guides for Octopad's hosted MCP connection
- optional skills for product documentation and planning

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

This starts guided onboarding inside your AI. Connecting the MCP does not install optional skills.

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

Both routes connect to Octopad. The marketplaces in this repository distribute optional skills. Those plugins add the skills described below; they are not the official Octopad app for ChatGPT.

## Optional skills

These plugins are optional and separate from the MCP connection:

| Distribution | Runtime | Version | What it does |
|---|---|---|---|
| [`manage-product-documentation`](plugins/manage-product-documentation-codex/skills/manage-product-documentation/SKILL.md) | Claude Code and Codex | 1.4.0 shared | Organizes and maintains product documentation as product work evolves. |
| [`octoplan-claude`](plugins/octoplan-claude/skills/octoplan/SKILL.md) | Claude Code | 2.0.0 | Plans the work, shows the plan with every protected effect disclosed, asks one delivery-mode question, then supervises delivery on that go. |
| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 2.0.0 | Confirms a Brief, reviews the Plan, then supervises authorized Delivery at the chosen interruption level. |
| [`meeting-to-octopad`](plugins/meeting-to-octopad/skills/meeting-to-octopad/SKILL.md) | Claude Code | 0.1.0 | Turns a meeting transcript into Octopad changes, proposed in one table you approve before anything is written. |

Install only the plugin you want. See [INSTALL.md](INSTALL.md#optional-skills) for commands and migration steps.

## Privacy, access and removal

- A connected AI can use only the Octopad access granted to your account.
- Octopad encrypts data in transit and at rest.
- Neither Octopad nor its subprocessors use workspace content to train AI models. See the [Octopad Privacy Policy](https://www.octopad.ai/privacy).
- When content is sent to an external AI provider, that provider's terms and privacy policy apply.
- To revoke a connection, open **Octopad > Settings > AI clients** and sign out one client or all clients. Then remove Octopad from the client's connector or app settings if you no longer want it listed.

For a sensitive security report, follow [SECURITY.md](SECURITY.md).

## Help

- For a problem with these guides or an optional skill, [open a GitHub issue](https://github.com/sudolab-co/octopad-mcp/issues/new).
- For an account or product problem, email [support@octopad.ai](mailto:support@octopad.ai).

## Repository layout

```text
INSTALL.md                                   AI-readable install guide
docs/clients/                                Client-specific direct MCP guides
.claude-plugin/marketplace.json              Claude marketplace manifest
.agents/plugins/marketplace.json             Codex marketplace manifest
plugins/manage-product-documentation-claude/ Claude Code product-documentation distribution
plugins/manage-product-documentation-codex/  Codex product-documentation distribution
plugins/octoplan-claude/                     Claude Code Octoplan distribution
plugins/octoplan-codex/                      Codex Octoplan distribution
plugins/meeting-to-octopad/                  Optional Claude meeting-transcript distribution
scripts/validate-repository.sh               Repository contract validation
```

## Releases

One skill, one name. A distribution's folder, its plugin name, and its release tag prefix are the same string, and a skill that ships to more than one AI runtime carries that runtime in the name. Release titles read `<Display Name> <version>`.

Octoplan restarted at `1.0.0` on both runtimes when they adopted one shared contract. Releases published before that reset keep their original numbers and tags, because those are what the published release pages record; `CHANGELOG.md` lists them under each distribution's pre-reset heading. See [CHANGELOG.md](CHANGELOG.md) and [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
