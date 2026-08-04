#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

[ -f "$root/INSTALL.md" ] || fail 'AI installation entrypoint is missing'
[ -f "$root/.github/workflows/validate.yml" ] || fail 'repository validation workflow is missing'
[ -d "$root/plugins/octoplan-claude" ] || fail 'Claude distribution was not renamed to octoplan-claude'
[ ! -e "$root/plugins/octoplan" ] || fail 'unsupported Claude distribution path remains'
[ "$(git -C "$root" branch --show-current)" = 'codex/octoplan-codex-7.0.0' ] || fail 'Codex release branch is not codex/octoplan-codex-7.0.0'
if ! git -C "$root" diff --quiet origin/main -- README.md; then
  fail 'root README differs from origin/main'
fi

grep -Fq '# Octopad MCP' "$root/README.md" || fail 'README does not lead with Octopad MCP'
grep -Fq 'Give your AI this repository URL' "$root/README.md" || fail 'AI-first install handoff is missing'
grep -Fq 'https://mcp.octopad.app/mcp' "$root/INSTALL.md" || fail 'canonical MCP endpoint is missing'
grep -Fq 'Install the MCP connection only by default' "$root/INSTALL.md" || fail 'MCP-only default is not explicit'
grep -Fq 'codex mcp add octopad --url https://mcp.octopad.app/mcp' "$root/docs/clients/codex.md" || fail 'Codex MCP command is missing'
grep -Fq 'claude mcp add --transport http octopad https://mcp.octopad.app/mcp' "$root/docs/clients/claude-code.md" || fail 'Claude Code MCP command is missing'
grep -Fq 'gemini mcp add --transport http octopad https://mcp.octopad.app/mcp' "$root/docs/clients/gemini-cli.md" || fail 'Gemini CLI MCP command is missing'
grep -Fq '"url": "https://mcp.octopad.app/mcp"' "$root/docs/clients/cursor.md" || fail 'Cursor MCP configuration is missing'
grep -Fq 'Customize > Connectors' "$root/docs/clients/claude.md" || fail 'Claude connector path is missing'

grep -q '"name": "octopad-mcp"' "$root/.claude-plugin/marketplace.json" || fail 'Claude marketplace ID is not octopad-mcp'
grep -q '"name": "octopad-mcp"' "$root/.agents/plugins/marketplace.json" || fail 'Codex marketplace ID is not octopad-mcp'
grep -q '"name": "octoplan-claude"' "$root/plugins/octoplan-claude/.claude-plugin/plugin.json" || fail 'Claude plugin ID is not octoplan-claude'
grep -q '"version": "1\.4\.0"' "$root/plugins/octoplan-claude/.claude-plugin/plugin.json" || fail 'Claude plugin did not preserve 1.4.0'
grep -q '^Version: 1\.4\.0$' "$root/plugins/octoplan-claude/skills/octoplan/SKILL.md" || fail 'Claude skill did not preserve 1.4.0'
grep -q '"version": "7\.0\.0"' "$root/plugins/octoplan-codex/.codex-plugin/plugin.json" || fail 'Codex plugin is not 7.0.0'
grep -q '^Version: 7\.0\.0$' "$root/plugins/octoplan-codex/skills/octoplan/SKILL.md" || fail 'Codex skill is not 7.0.0'
grep -q '^### 1\.4\.0 — 2026-07-30$' "$root/CHANGELOG.md" || fail 'Claude 1.4.0 history is missing'
grep -q '^### 7\.0\.0 — 2026-08-04$' "$root/CHANGELOG.md" || fail 'Codex 7.0.0 entry is missing'
! grep -q '^### 2\.0\.0 — 2026-08-03$' "$root/CHANGELOG.md" || fail 'false Claude 2.0.0 release remains'

find "$root" -type f -name '*.json' -not -path '*/.git/*' -exec sh -c '
  for file do
    node -e "JSON.parse(require(\"fs\").readFileSync(process.argv[1], \"utf8\"))" "$file" || exit 1
  done
' sh {} + || fail 'invalid JSON'

git -C "$root" diff --check || fail 'whitespace errors in diff'

sh "$root/scripts/validate-octoplan-codex.sh"

printf 'PASS: octopad-mcp repository contract\n'
