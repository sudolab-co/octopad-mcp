# Octopad Skills

Agent skills for [Octopad](https://octopad.app), a shared workspace where humans and AI assistants collaborate with persistent memory, structured tasks, and living knowledge.

A *skill* is a set of instructions an AI assistant loads when a matching request comes in. The skills in this repository teach an assistant how to use Octopad well for a specific kind of work. More skills will land here over time.

## Skills

| Skill | What it does | Assistants |
|---|---|---|
| [`octoplan`](claude/skills/octoplan/SKILL.md) | Turns an Octopad work stream into an execution-ready plan: detailed, ordered, self-contained tasks that fresh AI sessions execute one at a time, chained by a minimal continuation prompt. Works for engineering and non-technical streams alike. | Claude Code (a ChatGPT variant is planned) |

## What Octoplan is

Octoplan is a planning protocol built on Octopad's task graph.

- **A planning session** reads the work stream, locks open decisions with the user, and writes every task as a complete, self-contained spec: verified against the real codebase or reference documents, sized to one session each, ordered by real dependency edges.
- **Execution sessions** need nothing installed. Each task's description carries its own hand-off instruction, so any fresh session briefs itself from Octopad, does its one task, and hands the user a one-line continuation prompt for the next session. Octopad holds the state; the prompt is only a pointer, so it never goes stale.
- **Multi-stream efforts**: when a request spans several work streams, Octoplan plans them as one effort. One goal, several streams, one light Blueprint page explaining the global logic, and cross-stream dependencies enforcing it.

## Requirements

- An [Octopad](https://octopad.app) account and workspace.
- The Octopad MCP server connected to your assistant (see Octopad's docs for setup). The skill orients itself with Octopad's own tools; no other integration is needed.
- The install below targets **Claude Code** (the terminal/desktop agent, which reads `~/.claude/skills/`). Other Claude surfaces don't load file-based skills today.

## Install (Claude Code)

Copy the skill folder into your skills directory:

```bash
git clone https://github.com/sudolab-co/octopad-skills.git
mkdir -p ~/.claude/skills
cp -R octopad-skills/claude/skills/octoplan ~/.claude/skills/
```

Or, to scope it to a single project, copy it into `<project>/.claude/skills/` instead. Restart Claude Code; the skill then triggers on "Octoplan <work stream name>".

## Staying up to date

The repository is the source of truth. To update, pull and re-copy (the `/.` form overwrites the contents in place instead of nesting a copy):

```bash
git -C octopad-skills pull
cp -R octopad-skills/claude/skills/octoplan/. ~/.claude/skills/octoplan/
```

## Versioning

Each skill carries a `Version:` line at the top of its file, right under the YAML header. Breaking changes to the conventions written into task descriptions (title prefixes, the continuation prompt shape, template section names) bump the major version and are called out in the commit message.

## License

[MIT](LICENSE)
