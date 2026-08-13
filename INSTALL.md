# Connect Octopad

This is the connection guide for AI assistants.

## Connection contract

1. Detect the current client from the runtime. Do not ask the user when the runtime already identifies itself.
2. Add the MCP connection only by default. Do not install Octoplan or another optional skill unless the user asks for it.
3. Use the matching client guide below. Do not invent a command or edit another client's configuration.
4. Use only this endpoint: `https://mcp.octopad.app/mcp`.
5. In the browser, have the user sign in or create an Octopad account.
6. Have the user complete any required organization or membership setup.
7. Have the user authorize the AI client where they started.
8. Return to that client and verify that it can list the Octopad server or tools. A saved configuration or completed browser screen is not enough.
9. Tell the user to start a new conversation or task in that client and send exactly: **"Use Octopad. Start my onboarding."**

Do not replace the last step with a generic instruction to "start a session." Authorization, connection and guided onboarding are separate steps.

## Choose the current client

| Current client | Follow |
|---|---|
| ChatGPT desktop app in Codex mode, or Codex CLI | [Codex](docs/clients/codex.md) |
| Claude or Claude Desktop | [Claude](docs/clients/claude.md) |
| Claude Code | [Claude Code](docs/clients/claude-code.md) |
| Cursor | [Cursor](docs/clients/cursor.md) |
| Gemini CLI | [Gemini CLI](docs/clients/gemini-cli.md) |
| Another MCP client | Add `https://mcp.octopad.app/mcp` as a remote Streamable HTTP server, then follow steps 5 to 9 above. |

If the client cannot add a remote Streamable HTTP MCP server with OAuth, explain that limit and stop. Do not substitute another method without the user's approval.

For regular ChatGPT conversations, install the official Octopad app. This is the supported customer-facing ChatGPT plugin. Open the current [ChatGPT directory](https://chatgpt.com/plugins) and search for `Octopad`. That route is separate from the direct MCP setup in this file.

## Optional Octoplan skills

Octoplan is separate from the MCP connection. Install it only when the user explicitly asks for Octoplan.

### Claude Code

```text
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install octoplan-claude@octopad-mcp
/reload-plugins
```

Third-party Claude marketplaces do not update automatically by default. To enable updates, open `/plugin`, select **Marketplaces**, then select `octopad-mcp`.

To refresh the skill manually, run `/plugin marketplace update octopad-mcp`, `/plugin update octoplan-claude@octopad-mcp`, then `/reload-plugins`.

### Codex

```bash
codex plugin marketplace add sudolab-co/octopad-mcp --ref main
codex plugin add octoplan-codex@octopad-mcp
```

Refresh later releases with:

```bash
codex plugin marketplace upgrade octopad-mcp
```

This command refreshes the marketplace and reinstalls its configured plugins. Start a new Codex task after installing or refreshing the skill.

### Migrate an existing Octoplan install

The repository and marketplace rename is intentionally breaking. Remove the old identity before adding the new one.

Claude Code:

```text
/plugin uninstall octoplan@octopad-skills
/plugin marketplace remove octopad-skills
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install octoplan-claude@octopad-mcp
/reload-plugins
```

Codex:

```bash
codex plugin remove octoplan-codex@octopad-skills
codex plugin marketplace remove octopad-skills
codex plugin marketplace add sudolab-co/octopad-mcp --ref main
codex plugin add octoplan-codex@octopad-mcp
```

Start a new task after either migration.
