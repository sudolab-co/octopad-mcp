# Changing a skill in this repository

Read this before editing any `SKILL.md`. It exists because the step people forget is the version, and a skill whose version never moves gives users no way to tell what they are running.

## Every change ships with a version bump

Three files move together. Change one without the others and the repo lies about itself:

1. **The skill's `Version:` line**, at the top of its `SKILL.md`.
2. **The plugin's `version`**, in `plugins/<plugin>/.claude-plugin/plugin.json` for Claude or `plugins/<plugin>/.codex-plugin/plugin.json` for Codex. Same number.
3. **`CHANGELOG.md`**, a new entry under that skill, dated, saying what changed in plain language.

Then tag the release so it is visible on GitHub:

```bash
git tag -a <skill>-vX.Y.Z -m "<skill> X.Y.Z — <one line>"
git push origin <skill>-vX.Y.Z
gh release create <skill>-vX.Y.Z --title "<skill> X.Y.Z" --notes "..."
```

Tags carry the distribution name because each distribution is versioned on its own. Use `octoplan-vX.Y.Z` for Claude and `octoplan-codex-vX.Y.Z` for Codex.

The first public Codex distribution intentionally starts at `1.3.1`, matching the public Claude protocol available when it was introduced. The older private Codex numbering is not part of this repository's public version history.

## Which number moves

- **Major** (`2.0.0`) — a breaking change to anything an executor session reads literally out of an Octopad task: the `#N - ` title prefix, the continuation prompt shape, the template's section names, the relay/terminal wording, the flesh-out marker. Plans written under the old version may need a checkpoint pass, so say that in the changelog entry.
- **Minor** (`1.1.0`) — new guidance, a new section, a rubric row. Existing plans stay valid.
- **Patch** (`1.0.1`) — wording, typos, clarifications that change no behavior.

When in doubt between minor and major, ask: would a session executing an existing plan behave differently? If yes, it is major.

## The Octopad contract is not yours to change

Octoplan writes tasks through Octopad's MCP server, which rejects a create that breaks its rules. These come from the server, not from this repo, so never "improve" them:

- Descriptions need literal **Why** and **What** sections; top-level tasks also need **Done when**. Accepted header forms: `**Why**`, `## Why`, or `Why:` at line start. Synonyms are rejected.
- `impact` (1–5) and `impact_rationale` are required creation parameters on every task, subtasks included.
- Subtasks are created with `parent_task_id` and need only Why + What.
- Dependency edges require a rationale when added.

If Octopad's own contract changes, that is a major bump here.

## Before you push

- The skill's YAML header still has `name:` matching its folder name, and a `description:` carrying the phrases that trigger it. A renamed folder or a reworded description can silently stop the skill from ever firing.
- Nothing identifying a person, a company, its internal tooling, or its private infrastructure went in. This repo is public. Team-specific rules belong in that team's own instruction files, not here.
- Any claim about a third-party product is either sourced or cut.
- A Codex release still asks before execution, creates no executor during planning, and applies saved model/effort values without silent substitution.
