# Octopad validation

## 2.0.0

Scope: Claude Code and Codex bundles, 2026-09-23. Both packages leave `methodology` unset. No server code, `start_session` implementation, authentication, active installation or production configuration is changed.

### Obtained evidence

- Both packages carry byte-identical copies of the 17 qualified satellite files, whose source hashes still match the provenance pins, and of the canonical Octoplan 4.0.1 tree. Only the Codex copy adds Octoplan's `agents/openai.yaml`.
- The two `octopad-session` bootstraps route to the nine satellites and Octoplan. They differ only in how the client loads them and in naming other Octopad connections.
- Repository validation passes, including the Octoplan packaging tests and the bundle corruption tests. New tests cover a wrong Claude endpoint, a Claude version drift, a missing Octoplan file, a bootstrap that stops routing to Octoplan, bootstraps that diverge beyond their two runtime lines, a hook or other unexpected key in a manifest, and an Octoplan release shipped without a bundle release note naming it.
- `claude plugin validate` accepts the Claude plugin manifest and the Claude marketplace manifest.
- A throwaway Claude Code session started with `--plugin-dir` on the Claude package listed all eleven skills under the `octopad:` prefix. `claude mcp list` in that mode showed the bundled `plugin:octopad:octopad` connection to `https://mcp.octopad.app/mcp`, waiting for authentication. No plugin was installed by these checks.

### Not obtained

No marketplace installation, OAuth sign-in, call through the bundled connection, Codex install or load witness, or production kernel delivery. The load check above also showed the duplicate-connection case this guide warns about: a client that already has a Claude connector to Octopad lists both routes.

## 1.0.0

Scope: Codex MCP-and-skills distribution, 2026-09-23. The package leaves `methodology` unset. No server code, `start_session` implementation, authentication, active installation or production configuration is changed.

### Obtained evidence

- All 18 R2 input files match their original SHA-256 and sizes. All three qualification evidence-file hashes match the supplied freeze. The provenance manifest records those hashes without private source paths.
- Seventeen satellite Markdown files are packaged. Fifteen are byte-identical to the qualified source. Notepad changes two uses of “module” to “skill” and advances its patch version; planning gains its first declared version. No qualified behavior is rewritten.
- The qualified kernel fingerprint is retained in provenance. Its text is maintained in Octopad and excluded from this public repository.
- Repository validation passes, including the existing eight Octoplan packaging tests and ten aggregate corruption tests. The latter cover pinned-source drift, missing references, extra skills, symlinks, wrong endpoint, an experimental marker, a second runtime kernel, a forbidden public kernel copy, duplicate marketplace entries and escaping links.
- The bundled plugin-creator manifest validator and skill-creator validators pass for all ten skill entrypoints. The default Python lacked PyYAML; validation ran successfully in an isolated `uv run --with PyYAML` environment. No plugin was installed by these checks.
- `git diff --check` passes. New distributed material was scanned for private paths, identifiers and credential material. Existing Claude distributions, standalone product-documentation and Octoplan content remain unchanged.

### Original review budget

One independent reviewer, one bounded initial pass: exact R2 fidelity, packaging, bootstrap, precedence, coexistence and rollback. Result: PASS within the local scope, no blocking finding. A targeted follow-up covers the user-requested removal of experimental marker selection, the frozen kernel handoff outside the plugin, and the explicit aggregate exception to the repository's single-skill rule. Follow-up result: PASS, no blocking finding; the reviewer also ran the complete repository checks (10 aggregate and 8 Octoplan tests). No broad behavioral campaign was repeated.

### Not obtained

No real installation, OAuth flow, bundled-connector connection, fresh CLI/desktop skill-loading witness, implicit catalogue collision check, production kernel delivery or Claude aggregate test. The existing direct MCP connection used to read the tracking task proves none of these. Distribution closeout on controlled clients remains a separate authorized operation, with full-tree and fresh-load witnesses required before claiming adoption.

The R2 behavioral qualification retains its original limits and failures. Static checks and an independent review do not turn those limits into an end-to-end client PASS.
