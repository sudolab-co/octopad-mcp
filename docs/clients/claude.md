# Claude and Claude Desktop

Remote custom connectors are configured in Claude's connector settings. Claude Desktop does not load a remote connector from `claude_desktop_config.json`.

1. Open **Customize > Connectors** in Claude or Claude Desktop.
2. On a Team or Enterprise workspace, an Owner or Primary Owner must first use **Organization settings > Connectors**.
3. Select **+ > Add custom connector**.
4. Name it `Octopad` and enter `https://mcp.octopad.app/mcp`.
5. Select **Connect**, then sign in or create an Octopad account in the browser.
6. Enable the Octopad tools for the conversation and ask Octopad to start a session.

Anthropic makes remote custom connectors available on Free, Pro, Max, Team, and Enterprise plans. Free accounts can add one custom connector. Workspace policy can restrict who may add one.

Source: [Anthropic remote custom connector guide](https://support.claude.com/en/articles/11175166-get-started-with-custom-connectors-using-remote-mcp)
