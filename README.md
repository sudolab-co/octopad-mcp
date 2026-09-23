# Octopad MCP

Connect supported AI clients to [Octopad](https://octopad.app). Octopad is the company brain where your AIs manage work and knowledge under the same structure and rules.

This public repository contains:

- setup guides for Octopad's hosted MCP connection
- the Octopad bundle for Claude Code and Codex: its MCP connection, nine skills and Octoplan
- an optional meeting-transcript skill for Claude Code

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

Both routes connect to Octopad. The marketplaces in this repository distribute the Octopad bundle, which includes its MCP connection, and an optional skill that does not. These packages are not the official Octopad app for ChatGPT.

## Octopad bundle

The `octopad` plugin, version **2.0.0**, installs the hosted Octopad connection with its skills in one step. It exists for Claude Code and for Codex, under the same name and version:

- nine skills for knowledge and evidence, planning and work design, the Notepad, activity context, market intelligence, product documentation, product marketing, positioning checks and technical writing
- Octoplan 4.0.1, which plans a work stream and supervises its delivery once you give an explicit go
- a technical `octopad-session` entry skill that starts Octopad before the first call

The server supplies the methodology; the bundle contains no methodology text and does not change which one the server sends. See the [integration, compatibility and rollback guide](docs/octopad/README.md) before you enable it beside an existing Octopad connection or older skills. Keep one active Octopad connection per client.

Install it by following [INSTALL.md](INSTALL.md#optional-skills).

## Optional skills

These plugins are optional and separate from a direct MCP connection:

| Distribution | Runtime | Version | What it does |
|---|---|---|---|
| [`octopad`](plugins/octopad-claude/skills/octopad-session/SKILL.md) | Claude Code | 2.0.0 | Connects Octopad and loads its nine skills and Octoplan. |
| [`octopad`](plugins/octopad-codex/skills/octopad-session/SKILL.md) | Codex | 2.0.0 | Connects Octopad and loads its nine skills and Octoplan. |
| [`meeting-to-octopad`](plugins/meeting-to-octopad/skills/meeting-to-octopad/SKILL.md) | Claude Code | 0.1.0 | Turns a meeting transcript into Octopad changes, proposed in one table you approve before anything is written. |

The standalone `octoplan-claude`, `octoplan-codex` and `manage-product-documentation` plugins are retired: the bundle carries the same skills. They stay listed for a short transition, frozen and marked as replaced; do not install them. [INSTALL.md](INSTALL.md#move-from-the-retired-plugins) explains how to switch.

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
INSTALL.md                         AI-readable install guide
docs/clients/                      Client-specific direct MCP guides
docs/octopad/                      Bundle integration, provenance and validation record
.claude-plugin/marketplace.json    Claude marketplace manifest
.agents/plugins/marketplace.json   Codex marketplace manifest
config/shared-skills/              Canonical source of the nine skills
skills/octoplan/                   Canonical Octoplan skill and runtime profiles
plugins/octopad-claude/            Generated Claude Code bundle
plugins/octopad-codex/             Generated Codex bundle
plugins/meeting-to-octopad/        Optional Claude meeting-transcript distribution
scripts/                           Copy and validation scripts
```

## Releases

One distribution, one identity. A plugin can bundle related skills without renaming them. A distribution's folder and its release tag prefix are the same string; the plugin name drops any runtime suffix, so both `octopad-claude` and `octopad-codex` install as `octopad`. Release titles read `<Display Name> <version>`.

Octoplan restarted at `1.0.0` on both runtimes when they adopted one shared contract. Releases published before that reset keep their original numbers and tags, because those are what the published release pages record; `CHANGELOG.md` lists them under each distribution's pre-reset heading. See [CHANGELOG.md](CHANGELOG.md) and [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
