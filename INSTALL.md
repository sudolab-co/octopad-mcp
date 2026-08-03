# Install Octopad

This file is the installation entrypoint for AI assistants.

## Installation contract

1. Detect the current client from the runtime. Do not ask the user when the runtime already identifies itself.
2. Install the MCP connection only by default. Do not install Octoplan or another optional skill unless the user asks for it.
3. Use the client guide below. Do not invent a command or edit another client's configuration.
4. Use only this endpoint: `https://mcp.octopad.app/mcp`.
5. Complete OAuth in the browser. The user may sign in to an existing Octopad account or create one during that flow.
6. Verify the connection by listing the server or tools, then ask Octopad to start a session. Never claim success from a saved config alone.

## Choose the current client

| Current client | Follow |
|---|---|
| ChatGPT desktop app in Codex mode, or Codex CLI | [Codex](docs/clients/codex.md) |
| Claude or Claude Desktop | [Claude](docs/clients/claude.md) |
| Claude Code | [Claude Code](docs/clients/claude-code.md) |
| Cursor | [Cursor](docs/clients/cursor.md) |
| Gemini CLI | [Gemini CLI](docs/clients/gemini-cli.md) |
| Another MCP client | Add `https://mcp.octopad.app/mcp` as a remote Streamable HTTP server, complete OAuth, and verify the tools before use. |

If the current client cannot add remote Streamable HTTP MCP servers with OAuth, explain that limitation and stop. Do not substitute a proxy, token, package, or local server without the user's approval.

## Optional Octoplan skills

Octoplan is separate from the MCP connection. Install it only when the user explicitly asks for Octoplan.

### Claude Code

```text
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install octoplan-claude@octopad-mcp
```

Third-party Claude marketplaces do not auto-update by default. In `/plugin`, open **Marketplaces**, select `octopad-mcp`, and enable auto-update if the user wants automatic skill updates.

### Codex

```bash
codex plugin marketplace add sudolab-co/octopad-mcp --ref main
codex plugin add octoplan-codex@octopad-mcp
```

Refresh later releases with:

```bash
codex plugin marketplace upgrade octopad-mcp
```

### Migrate an existing Octoplan install

The repository and marketplace rename is intentionally breaking. Remove the old identity before adding the new one.

Claude Code:

```text
/plugin uninstall octoplan@octopad-skills
/plugin marketplace remove octopad-skills
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install octoplan-claude@octopad-mcp
```

Codex:

```bash
codex plugin remove octoplan-codex@octopad-skills
codex plugin marketplace remove octopad-skills
codex plugin marketplace add sudolab-co/octopad-mcp --ref main
codex plugin add octoplan-codex@octopad-mcp
```
