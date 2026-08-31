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

### Keep skills up to date

**Claude Code.** A third-party marketplace does not refresh itself by default. After installing any skill from `octopad-mcp`, offer to turn automatic updates on and walk the user through it, because a skill that never refreshes silently stays on an old contract:

1. Run `/plugin`.
2. Select **Marketplaces**.
3. Select `octopad-mcp` and enable automatic updates.

Do not claim this is done until the user confirms the setting. To refresh once, by hand, run `/plugin marketplace update octopad-mcp`, `/plugin update <plugin>@octopad-mcp`, then `/reload-plugins`.

**Codex.** There is no automatic update. Refresh with `codex plugin marketplace upgrade octopad-mcp`, which refreshes the marketplace and reinstalls its configured plugins. Start a new task afterwards. Tell the user this is manual rather than implying it is automatic.

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

Then follow **Keep skills up to date** above.

### Octoplan for Claude Code

Octoplan plans a work stream into detailed, ordered, self-contained tasks, shows the finished plan with every protected effect named in plain words, asks one delivery-mode question, and supervises the delivery of that plan once the user gives an explicit go. It never delivers without that go.

```text
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install octoplan-claude@octopad-mcp
/reload-plugins
```

Then follow **Keep skills up to date** above.

Codex has its own Octoplan distribution. Do not install the Claude one in Codex or the reverse.

### Meeting to Octopad for Claude Code

This skill turns a meeting transcript into Octopad changes: it extracts decisions, action items, updates, open questions, and goal signals, matches them against what Octopad already holds, and proposes every change in one table that you approve before anything is written.

```text
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install meeting-to-octopad@octopad-mcp
/reload-plugins
```

Then follow **Keep skills up to date** above.

### Octoplan for Codex

```bash
codex plugin marketplace add sudolab-co/octopad-mcp --ref main
codex plugin add octoplan-codex@octopad-mcp
```

Then follow **Keep skills up to date** above.

### Migrate an existing Octoplan install

Octoplan for Claude Code now ships as one distribution, `octoplan-claude`, at version `1.0.0`. Two earlier Claude identities are retired: the planning-only skill that carried the `octoplan-claude` name, and the experimental `octoplan-autopilot`. Remove whichever is installed before adding the current one.

Claude Code, from `octoplan-autopilot`:

```text
/plugin uninstall octoplan-autopilot@octopad-mcp
/plugin install octoplan-claude@octopad-mcp
/reload-plugins
```

Claude Code, from the retired `octopad-skills` marketplace:

```text
/plugin uninstall octoplan@octopad-skills
/plugin marketplace remove octopad-skills
/plugin marketplace add sudolab-co/octopad-mcp
/plugin install octoplan-claude@octopad-mcp
/reload-plugins
```

Codex, from the retired `octopad-skills` marketplace:

```bash
codex plugin remove octoplan-codex@octopad-skills
codex plugin marketplace remove octopad-skills
codex plugin marketplace add sudolab-co/octopad-mcp --ref main
codex plugin add octoplan-codex@octopad-mcp
```

Codex Octoplan also restarted its version numbering at `1.0.0`. A Codex install still holding an `18.x` version may not offer `1.0.0` as an upgrade. When `codex plugin marketplace upgrade octopad-mcp` leaves the old version in place, remove and re-add the plugin:

```bash
codex plugin remove octoplan-codex@octopad-mcp
codex plugin add octoplan-codex@octopad-mcp
```

Start a new conversation or task after any migration.
