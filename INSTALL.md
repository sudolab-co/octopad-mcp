# Connect Octopad

This is the connection guide for AI assistants.

## Connection contract

1. Detect the current client from the runtime. Do not ask the user when the runtime already identifies itself.
2. Add the MCP connection only by default. Do not install an optional skill unless the user asks for it.
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

## Optional skills

Skills are separate from the MCP connection. Install one only when the user explicitly asks for it.

### Manage product documentation

This skill helps an AI assistant organize and maintain product documentation in Octopad during normal product work. It can activate while the assistant is running, but it is not a background service.

Claude Code:

```text
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install manage-product-documentation@octopad-mcp
/reload-plugins
```

Codex:

```bash
codex plugin marketplace add sudolab-co/octopad-mcp --ref main
codex plugin add manage-product-documentation@octopad-mcp
```

For Claude Code, refresh with `/plugin marketplace update octopad-mcp`, `/plugin update manage-product-documentation@octopad-mcp`, then `/reload-plugins`. For Codex, run `codex plugin marketplace upgrade octopad-mcp`. Start a new session or task after refreshing.

### Octoplan for Claude Code

```text
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install octoplan-claude@octopad-mcp
/reload-plugins
```

Third-party Claude marketplaces do not update automatically by default. To enable updates, open `/plugin`, select **Marketplaces**, then select `octopad-mcp`.

To refresh the skill manually, run `/plugin marketplace update octopad-mcp`, `/plugin update octoplan-claude@octopad-mcp`, then `/reload-plugins`.

### Octoplan Autopilot for Claude Code

This is an experimental variant published for a live trial. It plans a work stream like Octoplan, agrees a delivery contract with you, and then supervises the delivery of that plan once you give an explicit go.

Install it **in place of** `octoplan-claude`, not alongside it: both skills trigger on the same request, a plain "Octoplan" followed by a work-stream name, so with both installed the assistant has no reliable way to tell which one you meant. Remove the planning-only one first:

```text
/plugin uninstall octoplan-claude@octopad-mcp
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install octoplan-autopilot@octopad-mcp
/reload-plugins
```

To refresh the skill manually, run `/plugin marketplace update octopad-mcp`, `/plugin update octoplan-autopilot@octopad-mcp`, then `/reload-plugins`.

To go back to planning-only Octoplan, uninstall this one and reinstall the other:

```text
/plugin uninstall octoplan-autopilot@octopad-mcp
/plugin install octoplan-claude@octopad-mcp
/reload-plugins
```

### Meeting to Octopad for Claude Code

This skill turns a meeting transcript into Octopad changes: it extracts decisions, action items, updates, open questions, and goal signals, matches them against what Octopad already holds, and proposes every change in one table that you approve before anything is written.

```text
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install meeting-to-octopad@octopad-mcp
/reload-plugins
```

To refresh the skill manually, run `/plugin marketplace update octopad-mcp`, `/plugin update meeting-to-octopad@octopad-mcp`, then `/reload-plugins`.

### Octoplan for Codex

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
