# Contributing

This public repository contains direct MCP setup guides and optional skill distributions. Keep each pull request narrow and state which surface it changes.

## Choose the scope

- **Connection docs:** `README.md`, `INSTALL.md` and `docs/clients/`.
- **Shared Octoplan source:** `skills/octoplan/`; edit the protocol and both runtime profiles here, then copy them into the packages.
- **Claude Octoplan packaging:** `.claude-plugin/` and `plugins/octoplan-claude/`.
- **Codex Octoplan packaging:** `.agents/` and `plugins/octoplan-codex/`.
- **Product documentation for Claude Code:** `.claude-plugin/` and `plugins/manage-product-documentation-claude/`.
- **Product documentation for Codex:** `.agents/` and `plugins/manage-product-documentation-codex/`.
- **Meeting to Octopad:** `.claude-plugin/` and `plugins/meeting-to-octopad/`.
- **Shared release records:** `CHANGELOG.md` and repository-level validation.

The two Octoplan plugins distribute one shared contract to two runtimes, as do the two product-documentation plugins. Do not change several unrelated contracts unless the pull request clearly covers them.

## Distribution names

A distribution's folder name, its plugin `name`, and its release tag prefix are the same string. A plugin may aggregate related skills: `octopad` is the Codex-first bundle, with nine satellite skills and one technical bootstrap. The plugin identity does not rename its skills. A skill that ships to more than one AI runtime carries that runtime in the name; a skill that ships to one runtime does not. Release titles read `<Display Name> <version>`, nothing else.

| Folder | Plugin name | Tag prefix | Release title |
|---|---|---|---|
| `plugins/octopad/` | `octopad` | `octopad-v` | `Octopad X.Y.Z` |
| `plugins/octoplan-claude/` | `octoplan-claude` | `octoplan-claude-v` | `Octoplan for Claude Code X.Y.Z` |
| `plugins/octoplan-codex/` | `octoplan-codex` | `octoplan-codex-v` | `Octoplan for Codex X.Y.Z` |
| `plugins/manage-product-documentation-claude/` | `manage-product-documentation` | `manage-product-documentation-claude-v` | `Manage Product Documentation X.Y.Z (Claude Code)` |
| `plugins/manage-product-documentation-codex/` | `manage-product-documentation` | `manage-product-documentation-codex-v` | `Manage Product Documentation X.Y.Z (Codex)` |
| `plugins/meeting-to-octopad/` | `meeting-to-octopad` | `meeting-to-octopad-v` | `Meeting to Octopad X.Y.Z` |

The product-documentation plugin name carries no runtime suffix because each marketplace manifest already selects one runtime and the two entries never appear in the same list. Its folder and tag still carry the suffix, because both live in one repository where the names must not collide. `scripts/validate-repository.sh` enforces the folder-to-plugin-name half of this rule; tags and release titles are the publisher's to get right.

## Skill contract changes ship with a version bump

For Octoplan, the canonical source and both generated copies move together; both native manifests carry the canonical version. Three release surfaces move together. The paired product-documentation distributions follow the synchronized rule below. Change a required surface without the others and the repo lies about itself:

1. **That distribution's skill `Version:` line**, at the top of its `SKILL.md`.
2. **That distribution's plugin `version`**, in `plugins/<plugin>/.claude-plugin/plugin.json` for Claude or `plugins/<plugin>/.codex-plugin/plugin.json` for Codex. Same number.
3. **`CHANGELOG.md`**, a new entry under that skill, dated, saying what changed in plain language.

An identity migration that changes no skill behavior keeps the existing skill versions. Document it in the connection guides. Do not invent a skill release.

Repository maintainers publish tags and releases after review, using the prefixes in the table above. Tags published before a distribution's version reset keep their original prefix and number: they are the record of what those release pages already serve, and renaming them would break the link between a release and what it shipped. Retired prefixes, kept for history only: `octoplan-vX.Y.Z` and `octoplan-autopilot-vX.Y.Z`.

## Which number moves

Octoplan uses **P.I.F**:

- **P — shared protocol:** a change to the contract shared by both runtimes advances P and resets I and F, even when existing plans remain compatible.
- **I — environment capability:** a change confined to one runtime's capability advances I and resets F.
- **F — local fix:** a correction or clarification with no behavior change.

Octoplan has one canonical source version, so both generated skills and native manifests carry the same number even for an environment-only change. State which runtime behavior changed in each release entry. The level test is the changed contract or capability, never line count. Check the final diff again after review.

Other skills retain their existing version rules: MAJOR breaks saved state, MINOR adds compatible behavior, and PATCH clarifies or fixes without a behavior change. The paired product-documentation distributions still move together as described below.

Octoplan restarted at `1.0.0` on both runtimes when they adopted one shared contract, so the numbers mean the same thing on both sides. Changelog entries from before that reset keep their original numbers under each distribution's pre-reset heading.

Do not confuse the release version with a plan-contract generation. Codex Octoplan stamps saved plans with a contract generation (`Octoplan 18 plan contract`) that says which plans a supervisor may still execute. That identifier is runtime state and is not renumbered by a release. Changing it is a `P` bump with a migration, never a side effect of versioning.

## One Octoplan source, two native packages

Author Octoplan only in `skills/octoplan/SKILL.md` and `skills/octoplan/references/**/*.md`. Common behavior belongs in the shared phase references; model routing, native dispatch and continuation mechanics belong in the named runtime profiles. The entrypoint selects the actual host profile, and never guesses or combines runtimes.

Run `python3 scripts/sync-octoplan.py` after a source edit. It copies the canonical Markdown bytes into both native packages and preserves native metadata, including Codex's `agents/openai.yaml`. The script does not remove obsolete files: remove a retired generated reference explicitly in the same reviewed change. Never author fixes in a generated copy, use symlinks, or refer outside the installed skill tree.

Run `python3 scripts/sync-octoplan.py --check` for read-only parity, local-link and public-hygiene checks, then `sh scripts/validate-repository.sh` for metadata, versions, other plugins and packaging mutation tests. Commit the canonical source and generated copies together. These checks prove package structure and parity; behavioral guarantees still need a fresh review of the actual shared protocol and each affected runtime profile.

Native plugin names, marketplaces and installation commands stay separate. The packages contain both profiles so they install offline without a second source checkout; loading the wrong host profile remains forbidden.

The two `manage-product-documentation` distributions have one synchronized release version and one shared AI-neutral contract. Their skill `Version:` lines, both plugin manifest versions, `SKILL.md`, `documentation-model.md`, `artifact-shapes.md`, and `lifecycle-playbooks.md` must move together and remain byte-identical where shared. Any behavior or runtime-packaging change bumps the synchronized version in both distributions and creates one shared changelog entry. Publish the Claude and Codex tags with that same version.

## Octopad aggregate source and version

Author the nine satellites in `config/shared-skills/`. This is their common, runtime-neutral source for the aggregate; `plugins/octopad/skills/` contains generated copies plus the native `octopad-session` bootstrap. Do not edit generated copies. Existing standalone product-documentation 1.4.0 packages remain a separate compatibility line; neither they nor Octoplan are regenerated by this workflow. A future Claude aggregate must reuse this canon and supply its own reviewed native bootstrap.

Run `python3 scripts/sync-octopad.py`, then `python3 scripts/sync-octopad.py --check`. The provenance manifest pins the qualified sources and the packaged files. An intentional source change requires a reviewed provenance update, an impact assessment and an appropriate skill version bump; never update a hash just to make a failing check pass. Preserve the qualification hashes as historical evidence.

The aggregate has its own P.I.F version: shared integration-contract changes bump P; compatible Codex packaging capability changes bump I; corrections without behavior change bump F. The initial version is 1.0.0. Keep the plugin manifest, bootstrap Version, provenance plugin_version and changelog synchronized. Satellite versions identify their own contracts, not the aggregate. The first assembly preserves candidate versions; Notepad's terminology correction advances its patch, and the previously unversioned planning skill receives its first declared version without a behavior change. Candidate labels do not assert installation or release.

The server owns the kernel. This repository records only its qualification fingerprint and integration contract. The kernel text stays in Octopad, outside this public repository; no server code is changed. See [the integration and transition guide](docs/octopad/README.md). Local packaging checks do not establish installation, early skill loading, authentication or server activation.

## The Octopad contract is not yours to change

Skills that write Tasks through Octopad's MCP server must follow the server contract. The server rejects Tasks that break these rules. Do not change them here:

- Descriptions need literal **Why** and **What** sections. Top-level tasks also need **Done when**. Valid headers are `**Why**`, `## Why`, or `Why:` at line start.
- `impact` (1 to 5) and `impact_rationale` are required creation parameters on every task, subtasks included.
- Subtasks are created with `parent_task_id` and need only Why + What.
- Dependency edges require a rationale when added.

For Octoplan, a changed shared server contract is a P change. Other skills follow the compatibility test above.

## Write for a first-time reader

- Use short, familiar words and active voice.
- Put actions in the order the reader must take them.
- Explain a technical term the first time it appears.
- Prefer one concrete instruction to a broad summary.
- Cut internal approvals, private paths and team-only rules from public guidance.
- Cut every word that does not help the reader act.

## Before opening a pull request

- The skill's YAML `name:` still matches its folder name. Its `description:` still carries the phrases that trigger it.
- No secret, private path, private infrastructure detail or internal conversation went in.
- Any claim about a third-party product is either sourced or cut.
- A Codex release requires explicit authority before execution. It creates no executor during planning and applies saved model and effort values without substitution.
- Run `sh scripts/validate-repository.sh` from the repository root.
- Explain the user-visible change and any migration in the pull request.
