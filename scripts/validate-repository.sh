#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

[ -f "$root/INSTALL.md" ] || fail 'AI connection guide is missing'
[ -f "$root/.github/workflows/validate.yml" ] || fail 'repository validation workflow is missing'
[ -d "$root/plugins/octoplan-claude" ] || fail 'Claude distribution was not renamed to octoplan-claude'
[ ! -e "$root/plugins/octoplan" ] || fail 'unsupported Claude distribution path remains'

grep -Fq '# Octopad MCP' "$root/README.md" || fail 'README does not lead with Octopad MCP'
grep -Fq 'Give your AI this repository URL' "$root/README.md" || fail 'AI-first install handoff is missing'
grep -Fq 'Connect Octopad using this repository.' "$root/README.md" || fail 'README connection prompt is missing'
grep -Fq '**"Use Octopad. Start my onboarding."**' "$root/README.md" || fail 'README onboarding handoff is missing'
grep -Fq 'https://chatgpt.com/plugins' "$root/README.md" || fail 'README ChatGPT directory link is missing'
grep -Fq 'official Octopad app' "$root/README.md" || fail 'README ChatGPT app route is missing'
grep -Fq 'supported customer-facing ChatGPT plugin' "$root/README.md" || fail 'README ChatGPT terminology bridge is missing'
grep -Fq '| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 15.0.0 | Plans the work and can supervise delivery after the user authorizes that scope. |' "$root/README.md" || fail 'README Codex version or behavior is stale'
grep -Fq 'Octopad > Settings > AI clients' "$root/README.md" || fail 'README connection-revocation path is missing'
[ -f "$root/SECURITY.md" ] || fail 'security reporting guide is missing'
grep -Fq 'https://mcp.octopad.app/mcp' "$root/INSTALL.md" || fail 'canonical MCP endpoint is missing'
grep -Fq 'Add the MCP connection only by default' "$root/INSTALL.md" || fail 'MCP-only default is not explicit'
grep -Fq '**"Use Octopad. Start my onboarding."**' "$root/INSTALL.md" || fail 'install onboarding handoff is missing'
grep -Fq '/reload-plugins' "$root/INSTALL.md" || fail 'Claude plugin reload step is missing'
grep -Fq 'codex plugin marketplace upgrade octopad-mcp' "$root/INSTALL.md" || fail 'Codex marketplace refresh step is missing'
grep -Fq 'codex plugin add octoplan-codex@octopad-mcp' "$root/INSTALL.md" || fail 'Codex plugin install step is missing'
grep -Fq 'codex mcp add octopad --url https://mcp.octopad.app/mcp' "$root/docs/clients/codex.md" || fail 'Codex MCP command is missing'
grep -Fq 'claude mcp add --transport http --scope user octopad https://mcp.octopad.app/mcp' "$root/docs/clients/claude-code.md" || fail 'Claude Code user-scoped MCP command is missing'
grep -Fq 'gemini mcp add --transport http octopad https://mcp.octopad.app/mcp' "$root/docs/clients/gemini-cli.md" || fail 'Gemini CLI MCP command is missing'
grep -Fq '"url": "https://mcp.octopad.app/mcp"' "$root/docs/clients/cursor.md" || fail 'Cursor MCP configuration is missing'
grep -Fq 'Customize > Connectors' "$root/docs/clients/claude.md" || fail 'Claude connector path is missing'

for guide in "$root"/docs/clients/*.md; do
  grep -Fq '**"Use Octopad. Start my onboarding."**' "$guide" || fail "onboarding handoff is missing from ${guide##*/}"
  grep -Fq 'organization or membership setup' "$guide" || fail "account setup handoff is missing from ${guide##*/}"
done

[ "$(grep -Fc '**"Use Octopad. Start my onboarding."**' "$root/docs/clients/codex.md")" -eq 2 ] || fail 'Codex desktop and CLI onboarding handoffs must both be explicit'

! grep -R -Fq 'ask Octopad to start a session' "$root/INSTALL.md" "$root/docs/clients" || fail 'obsolete generic session handoff remains'
! grep -Fq 'Tools & MCPs > New MCP Server' "$root/docs/clients/cursor.md" || fail 'obsolete Cursor settings path remains'
! grep -Fq "After Alex's explicit go" "$root/CONTRIBUTING.md" || fail 'private maintainer approval remains in public contribution guide'
grep -Fq 'sh scripts/validate-repository.sh' "$root/CONTRIBUTING.md" || fail 'public contribution validation command is missing'

grep -q '"name": "octopad-mcp"' "$root/.claude-plugin/marketplace.json" || fail 'Claude marketplace ID is not octopad-mcp'
grep -q '"name": "octopad-mcp"' "$root/.agents/plugins/marketplace.json" || fail 'Codex marketplace ID is not octopad-mcp'
grep -q '"name": "octoplan-claude"' "$root/plugins/octoplan-claude/.claude-plugin/plugin.json" || fail 'Claude plugin ID is not octoplan-claude'
grep -q '"version": "1\.4\.0"' "$root/plugins/octoplan-claude/.claude-plugin/plugin.json" || fail 'Claude plugin did not preserve 1.4.0'
grep -q '^Version: 1\.4\.0$' "$root/plugins/octoplan-claude/skills/octoplan/SKILL.md" || fail 'Claude skill did not preserve 1.4.0'
grep -q '"version": "15\.0\.0"' "$root/plugins/octoplan-codex/.codex-plugin/plugin.json" || fail 'Codex plugin is not 15.0.0'
grep -q '^Version: 15\.0\.0$' "$root/plugins/octoplan-codex/skills/octoplan/SKILL.md" || fail 'Codex skill is not 15.0.0'
grep -q '^### 1\.4\.0 — 2026-07-30$' "$root/CHANGELOG.md" || fail 'Claude 1.4.0 history is missing'
grep -q '^### 10\.0\.0 — 2026-08-08$' "$root/CHANGELOG.md" || fail 'Codex 10.0.0 entry is missing'
grep -q '^### 10\.1\.0 — 2026-08-09$' "$root/CHANGELOG.md" || fail 'Codex 10.1.0 entry is missing'
grep -q '^### 10\.2\.0 — 2026-08-09$' "$root/CHANGELOG.md" || fail 'Codex 10.2.0 entry is missing'
grep -q '^### 10\.2\.1 — 2026-08-09$' "$root/CHANGELOG.md" || fail 'Codex 10.2.1 entry is missing'
grep -q '^### 11\.0\.0 — 2026-08-09$' "$root/CHANGELOG.md" || fail 'Codex 11.0.0 entry is missing'
grep -q '^### 12\.1\.0 — 2026-08-11$' "$root/CHANGELOG.md" || fail 'Codex 12.1.0 entry is missing'
grep -q '^### 13\.0\.0 — 2026-08-11$' "$root/CHANGELOG.md" || fail 'Codex 13.0.0 entry is missing'
grep -q '^### 13\.1\.0 — 2026-08-11$' "$root/CHANGELOG.md" || fail 'Codex 13.1.0 entry is missing'
grep -q '^### 14\.0\.0 — 2026-08-12$' "$root/CHANGELOG.md" || fail 'Codex 14.0.0 entry is missing'
grep -q '^### 15\.0\.0 — 2026-08-12$' "$root/CHANGELOG.md" || fail 'Codex 15.0.0 entry is missing'
! grep -q '^### 2\.0\.0 — 2026-08-03$' "$root/CHANGELOG.md" || fail 'false Claude 2.0.0 release remains'

find "$root" -type f -name '*.json' -not -path '*/.git/*' -exec sh -c '
  for file do
    node -e "JSON.parse(require(\"fs\").readFileSync(process.argv[1], \"utf8\"))" "$file" || exit 1
  done
' sh {} + || fail 'invalid JSON'

git -C "$root" diff --check || fail 'whitespace errors in diff'

sh "$root/scripts/validate-octoplan-codex.sh"

printf 'PASS: octopad-mcp repository contract\n'
