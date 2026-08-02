# Octopad Skills

Agent skills for [Octopad](https://octopad.app), a shared workspace where humans and AI assistants collaborate with persistent memory, structured tasks, and living knowledge.

A *skill* is a set of instructions an AI assistant loads when a matching request comes in. The skills here teach an assistant how to use Octopad well for a specific kind of work. More will land over time.

## Skills

| Skill | What it does | Assistants |
|---|---|---|
| [`octoplan`](plugins/octoplan/skills/octoplan/SKILL.md) | Turns an Octopad work stream into an execution-ready plan whose fresh sessions are chained by minimal continuation prompts. | Claude Code |
| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Builds the same verified plan, then conditionally supervises approved execution through model-routed Codex sessions. | Codex |

## What Octoplan is

Octoplan is a planning protocol built on Octopad's task graph.

- **A planning session** reads the work stream, locks open decisions with the user, and writes every task as a complete, self-contained spec: verified against the real codebase or reference documents, sized to one session each, ordered by real dependency edges.
- **Claude execution sessions** need nothing installed. Each task carries its own hand-off instruction, so the user can open each fresh session from a minimal pointer.
- **Codex execution** never starts during planning. After a clear yes, a fenced inline or dedicated supervisor coordinates the approved graph, native sessions, revision-bound reviews, bounded recovery, and saved model fallbacks. Reviewers complete tasks; only the supervisor launches successors.
- **Multi-stream efforts**: when a request spans several work streams, Octoplan plans them as one effort. One goal, several streams, one light Blueprint page explaining the global logic, and cross-stream dependencies enforcing it.

## Requirements

- An [Octopad](https://octopad.app) account and workspace.
- The Octopad MCP server connected to your assistant (see Octopad's docs for setup). The skill orients itself with Octopad's own tools; no other integration is needed.

## Install (Claude Code)

This repository is a Claude Code plugin marketplace, so Claude Code fetches the skill for you instead of you copying files. In Claude Code, run:

```
/plugin marketplace add sudolab-co/octopad-skills
```

```
/plugin install octoplan@octopad-skills
```

The skill then triggers on "Octoplan <work stream name>" in any project.

## Install (Codex)

Add this Git marketplace, install the Codex distribution, then start a new Codex task:

```bash
codex plugin marketplace add sudolab-co/octopad-skills --ref main
codex plugin add octoplan-codex@octopad-skills
```

Authenticate Octopad when prompted. Then invoke the skill with `$octoplan` or say `Octoplan <work stream name>`.

To pull later releases:

```bash
codex plugin marketplace upgrade octopad-skills
```

## Staying up to date

Updates are not automatic until you say so. Claude Code enables background auto-update only for Anthropic's own marketplaces; every third-party one, including this one, ships with it off. Turn it on once, right after installing:

1. Run `/plugin` and open the **Marketplaces** tab.
2. Select `octopad-skills`.
3. Choose **Enable auto-update**.

Claude Code then refreshes this marketplace and updates the plugin in the background shortly after each session starts, and tells you to run `/reload-plugins` when a new version has landed.

To keep it manual instead, run `/plugin marketplace update octopad-skills` followed by `/plugin update octoplan@octopad-skills` whenever a release is announced.

A team can set this for everyone by declaring the marketplace in a shared `.claude/settings.json`, so nobody has to remember the toggle:

```json
{
  "extraKnownMarketplaces": {
    "octopad-skills": {
      "source": { "source": "github", "repo": "sudolab-co/octopad-skills" },
      "autoUpdate": true
    }
  },
  "enabledPlugins": { "octoplan@octopad-skills": true }
}
```

### Manual install (no plugin support)

If your setup doesn't support plugins, copy the skill folder into your skills directory instead:

```bash
git clone https://github.com/sudolab-co/octopad-skills.git
mkdir -p ~/.claude/skills
cp -R octopad-skills/plugins/octoplan/skills/octoplan ~/.claude/skills/
```

To update a manual install, pull and re-copy (the `/.` form overwrites in place instead of nesting a copy):

```bash
git -C octopad-skills pull
cp -R octopad-skills/plugins/octoplan/skills/octoplan/. ~/.claude/skills/octoplan/
```

## Repository layout

```
.claude-plugin/marketplace.json       Claude marketplace manifest
.agents/plugins/marketplace.json      Codex marketplace manifest
plugins/octoplan/                     Claude distribution
  .claude-plugin/plugin.json          Claude manifest and version
plugins/octoplan-codex/               Codex distribution
  .codex-plugin/plugin.json           Codex manifest and version
  skills/octoplan/SKILL.md            Codex skill entrypoint
```

## Versioning

Each distribution carries a `Version:` line and a matching plugin-manifest version. The first public Codex release starts at `1.3.1`, level with the Claude distribution. Tags include the distribution name (`octoplan-vX.Y.Z` or `octoplan-codex-vX.Y.Z`). See [CHANGELOG.md](CHANGELOG.md) and [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
