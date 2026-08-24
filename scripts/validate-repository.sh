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
grep -Fq '| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 18.0.0 | Confirms a Brief, reviews the Plan, then supervises authorized Delivery at the chosen interruption level. |' "$root/README.md" || fail 'README Codex version or behavior is stale'
grep -Fq 'Octopad > Settings > AI clients' "$root/README.md" || fail 'README connection-revocation path is missing'
[ -f "$root/SECURITY.md" ] || fail 'security reporting guide is missing'
grep -Fq 'https://mcp.octopad.app/mcp' "$root/INSTALL.md" || fail 'canonical MCP endpoint is missing'
grep -Fq 'Add the MCP connection only by default' "$root/INSTALL.md" || fail 'MCP-only default is not explicit'
grep -Fq '**"Use Octopad. Start my onboarding."**' "$root/INSTALL.md" || fail 'install onboarding handoff is missing'
grep -Fq '/reload-plugins' "$root/INSTALL.md" || fail 'Claude plugin reload step is missing'
grep -Fq 'codex plugin marketplace upgrade octopad-mcp' "$root/INSTALL.md" || fail 'Codex marketplace refresh step is missing'
grep -Fq 'codex plugin add octoplan-codex@octopad-mcp' "$root/INSTALL.md" || fail 'Codex plugin install step is missing'
grep -Fq 'codex plugin add manage-product-documentation@octopad-mcp' "$root/INSTALL.md" || fail 'product-documentation plugin install step is missing'
grep -Fq '/plugin install manage-product-documentation@octopad-mcp' "$root/INSTALL.md" || fail 'Claude product-documentation plugin install step is missing'
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
claude_skill="$root/plugins/octoplan-claude/skills/octoplan/SKILL.md"
claude_manifest="$root/plugins/octoplan-claude/.claude-plugin/plugin.json"
claude_skill_version=$(sed -n 's/^Version: //p' "$claude_skill")
printf '%s\n' "$claude_skill_version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || fail 'Claude skill version is not semantic versioning'
claude_manifest_version=$(node -e 'process.stdout.write(JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).version)' "$claude_manifest")
[ "$claude_manifest_version" = "$claude_skill_version" ] || fail 'Claude skill and manifest versions differ'
claude_readme_row=$(printf '| [`octoplan-claude`](plugins/octoplan-claude/skills/octoplan/SKILL.md) | Claude Code | %s | Plans the work. It never carries out the plan. |' "$claude_skill_version")
[ "$(grep -Fxc "$claude_readme_row" "$root/README.md")" -eq 1 ] || fail 'README Claude version or behavior is stale'
claude_latest_changelog=$(awk '/^## octoplan-claude$/ { found=1; next } found && /^### / { sub(/^### /, ""); sub(/ — .*/, ""); print; exit }' "$root/CHANGELOG.md")
[ "$claude_latest_changelog" = "$claude_skill_version" ] || fail 'latest Claude changelog version differs from the skill'
claude_heading_count=$(awk -v version="$claude_skill_version" '
  /^## octoplan-claude$/ { found=1; next }
  found {
    prefix = "### " version " — "
    if (index($0, prefix) == 1) {
      date = substr($0, length(prefix) + 1)
      if (date ~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/) count++
    }
  }
  END { print count + 0 }
' "$root/CHANGELOG.md")
[ "$claude_heading_count" -eq 1 ] || fail 'Claude release needs one exact dated changelog heading'
autopilot_skill="$root/plugins/octoplan-autopilot/skills/octoplan-autopilot/SKILL.md"
autopilot_manifest="$root/plugins/octoplan-autopilot/.claude-plugin/plugin.json"
autopilot_supervision="$root/plugins/octoplan-autopilot/skills/octoplan-autopilot/references/supervision.md"
[ -f "$autopilot_skill" ] || fail 'Autopilot skill is missing'
[ -f "$autopilot_manifest" ] || fail 'Autopilot plugin manifest is missing'
[ -f "$autopilot_supervision" ] || fail 'Autopilot supervision reference is missing'
grep -q '"name": "octoplan-autopilot"' "$autopilot_manifest" || fail 'Autopilot plugin ID is not octoplan-autopilot'
autopilot_skill_version=$(sed -n 's/^Version: //p' "$autopilot_skill")
printf '%s\n' "$autopilot_skill_version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || fail 'Autopilot skill version is not semantic versioning'
autopilot_manifest_version=$(node -e 'process.stdout.write(JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).version)' "$autopilot_manifest")
[ "$autopilot_manifest_version" = "$autopilot_skill_version" ] || fail 'Autopilot skill and manifest versions differ'
autopilot_readme_row=$(printf '| [`octoplan-autopilot`](plugins/octoplan-autopilot/skills/octoplan-autopilot/SKILL.md) | Claude Code | %s | Plans the work, agrees a delivery contract, then supervises delivery after an explicit go. |' "$autopilot_skill_version")
[ "$(grep -Fxc "$autopilot_readme_row" "$root/README.md")" -eq 1 ] || fail 'README Autopilot version or behavior is stale'
autopilot_latest_changelog=$(awk '/^## octoplan-autopilot$/ { found=1; next } found && /^### / { sub(/^### /, ""); sub(/ — .*/, ""); print; exit }' "$root/CHANGELOG.md")
[ "$autopilot_latest_changelog" = "$autopilot_skill_version" ] || fail 'latest Autopilot changelog version differs from the skill'
autopilot_heading_count=$(awk -v version="$autopilot_skill_version" '
  /^## octoplan-autopilot$/ { found=1; next }
  found && /^## / { found=0 }
  found {
    prefix = "### " version " — "
    if (index($0, prefix) == 1) {
      date = substr($0, length(prefix) + 1)
      if (date ~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/) count++
    }
  }
  END { print count + 0 }
' "$root/CHANGELOG.md")
[ "$autopilot_heading_count" -eq 1 ] || fail 'Autopilot release needs one exact dated changelog heading'
node - "$root" "$autopilot_skill_version" <<'NODE' || fail 'Autopilot marketplace entry is invalid'
const fs = require('fs');
const path = require('path');
const root = process.argv[2];
const version = process.argv[3];
const marketplace = JSON.parse(fs.readFileSync(path.join(root, '.claude-plugin/marketplace.json'), 'utf8'));
const entries = marketplace.plugins.filter((plugin) => plugin.name === 'octoplan-autopilot');
if (entries.length !== 1) process.exit(1);
const entry = entries[0];
if (typeof entry.description !== 'string' || entry.description.length < 40) process.exit(1);
if (entry.author?.name !== 'Sudolab' || entry.category !== 'productivity' || entry.homepage !== 'https://octopad.app') process.exit(1);
if (typeof entry.source !== 'string' || !entry.source.startsWith('./plugins/')) process.exit(1);
const directory = path.resolve(root, entry.source);
if (directory !== path.join(root, 'plugins', path.basename(directory))) process.exit(1);
const manifestPath = path.join(directory, '.claude-plugin/plugin.json');
if (!fs.existsSync(manifestPath)) process.exit(1);
const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
if (manifest.name !== 'octoplan-autopilot' || manifest.version !== version) process.exit(1);
NODE
meeting_skill="$root/plugins/meeting-to-octopad/skills/meeting-to-octopad/SKILL.md"
meeting_manifest="$root/plugins/meeting-to-octopad/.claude-plugin/plugin.json"
[ -f "$meeting_skill" ] || fail 'Meeting to Octopad skill is missing'
[ -f "$meeting_manifest" ] || fail 'Meeting to Octopad plugin manifest is missing'
grep -q '"name": "meeting-to-octopad"' "$meeting_manifest" || fail 'Meeting to Octopad plugin ID is not meeting-to-octopad'
meeting_skill_version=$(sed -n 's/^Version: //p' "$meeting_skill")
printf '%s\n' "$meeting_skill_version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || fail 'Meeting to Octopad skill version is not semantic versioning'
meeting_manifest_version=$(node -e 'process.stdout.write(JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).version)' "$meeting_manifest")
[ "$meeting_manifest_version" = "$meeting_skill_version" ] || fail 'Meeting to Octopad skill and manifest versions differ'
meeting_readme_row=$(printf '| [`meeting-to-octopad`](plugins/meeting-to-octopad/skills/meeting-to-octopad/SKILL.md) | Claude Code | %s | Turns a meeting transcript into Octopad changes, proposed in one table you approve before anything is written. |' "$meeting_skill_version")
[ "$(grep -Fxc "$meeting_readme_row" "$root/README.md")" -eq 1 ] || fail 'README Meeting to Octopad version or behavior is stale'
meeting_latest_changelog=$(awk '/^## meeting-to-octopad$/ { found=1; next } found && /^### / { sub(/^### /, ""); sub(/ — .*/, ""); print; exit }' "$root/CHANGELOG.md")
[ "$meeting_latest_changelog" = "$meeting_skill_version" ] || fail 'latest Meeting to Octopad changelog version differs from the skill'
meeting_heading_count=$(awk -v version="$meeting_skill_version" '
  /^## meeting-to-octopad$/ { found=1; next }
  found && /^## / { found=0 }
  found {
    prefix = "### " version " — "
    if (index($0, prefix) == 1) {
      date = substr($0, length(prefix) + 1)
      if (date ~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/) count++
    }
  }
  END { print count + 0 }
' "$root/CHANGELOG.md")
[ "$meeting_heading_count" -eq 1 ] || fail 'Meeting to Octopad release needs one exact dated changelog heading'
node - "$root" "$meeting_skill_version" <<'NODE' || fail 'Meeting to Octopad marketplace entry is invalid'
const fs = require('fs');
const path = require('path');
const root = process.argv[2];
const version = process.argv[3];
const marketplace = JSON.parse(fs.readFileSync(path.join(root, '.claude-plugin/marketplace.json'), 'utf8'));
const entries = marketplace.plugins.filter((plugin) => plugin.name === 'meeting-to-octopad');
if (entries.length !== 1) process.exit(1);
const entry = entries[0];
if (typeof entry.description !== 'string' || entry.description.length < 40) process.exit(1);
if (entry.author?.name !== 'Sudolab' || entry.category !== 'productivity' || entry.homepage !== 'https://octopad.app') process.exit(1);
if (typeof entry.source !== 'string' || !entry.source.startsWith('./plugins/')) process.exit(1);
const directory = path.resolve(root, entry.source);
if (directory !== path.join(root, 'plugins', path.basename(directory))) process.exit(1);
const manifestPath = path.join(directory, '.claude-plugin/plugin.json');
if (!fs.existsSync(manifestPath)) process.exit(1);
const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
if (manifest.name !== 'meeting-to-octopad' || manifest.version !== version) process.exit(1);
NODE
[ -f "$root/plugins/manage-product-documentation-codex/.codex-plugin/plugin.json" ] || fail 'product-documentation plugin manifest is missing'
[ -f "$root/plugins/manage-product-documentation-claude/.claude-plugin/plugin.json" ] || fail 'Claude product-documentation plugin manifest is missing'
[ -f "$root/plugins/manage-product-documentation-codex/skills/manage-product-documentation/agents/openai.yaml" ] || fail 'product-documentation agent metadata is missing'
[ ! -e "$root/plugins/manage-product-documentation-claude/skills/manage-product-documentation/agents" ] || fail 'Claude product-documentation distribution contains Codex agent metadata'
[ -f "$root/plugins/manage-product-documentation-codex/skills/manage-product-documentation/references/documentation-model.md" ] || fail 'product-documentation model reference is missing'
[ -f "$root/plugins/manage-product-documentation-codex/skills/manage-product-documentation/references/artifact-shapes.md" ] || fail 'product-documentation artifact reference is missing'
[ -f "$root/plugins/manage-product-documentation-codex/skills/manage-product-documentation/references/lifecycle-playbooks.md" ] || fail 'product-documentation lifecycle reference is missing'
node - "$root" <<'NODE' || fail 'product-documentation distribution metadata is invalid'
const fs = require('fs');
const path = require('path');
const root = process.argv[2];
const codexManifest = JSON.parse(fs.readFileSync(path.join(root, 'plugins/manage-product-documentation-codex/.codex-plugin/plugin.json'), 'utf8'));
const claudeManifest = JSON.parse(fs.readFileSync(path.join(root, 'plugins/manage-product-documentation-claude/.claude-plugin/plugin.json'), 'utf8'));
const prompt = 'Use $manage-product-documentation to organize and maintain my product documentation while we work.';
if (codexManifest.name !== 'manage-product-documentation' || codexManifest.version !== '1.4.0' || codexManifest.skills !== './skills/' || codexManifest.license !== 'MIT') process.exit(1);
if (!Array.isArray(codexManifest.interface?.defaultPrompt) || codexManifest.interface.defaultPrompt.length !== 1 || codexManifest.interface.defaultPrompt[0] !== prompt) process.exit(1);
if (claudeManifest.name !== 'manage-product-documentation' || claudeManifest.version !== '1.4.0' || claudeManifest.license !== 'MIT') process.exit(1);
if (codexManifest.version !== claudeManifest.version) process.exit(1);
const codexMarketplace = JSON.parse(fs.readFileSync(path.join(root, '.agents/plugins/marketplace.json'), 'utf8'));
const codexEntries = codexMarketplace.plugins.filter((plugin) => plugin.name === 'manage-product-documentation');
if (codexEntries.length !== 1 || codexEntries[0].source?.source !== 'local' || codexEntries[0].source?.path !== './plugins/manage-product-documentation-codex') process.exit(1);
const claudeMarketplace = JSON.parse(fs.readFileSync(path.join(root, '.claude-plugin/marketplace.json'), 'utf8'));
const claudeEntries = claudeMarketplace.plugins.filter((plugin) => plugin.name === 'manage-product-documentation');
if (claudeEntries.length !== 1 || claudeEntries[0].source !== './plugins/manage-product-documentation-claude') process.exit(1);
const octoplanClaudeEntries = claudeMarketplace.plugins.filter((plugin) => plugin.name === 'octoplan-claude');
const expectedOctoplanClaudeEntry = {
  name: 'octoplan-claude',
  description: 'Turns an Octopad work stream into an execution-ready plan: detailed, ordered, self-contained tasks that fresh AI sessions execute one at a time, chained by a minimal continuation prompt. Works for engineering and non-technical work alike. Requires a connected Octopad MCP server.',
  author: { name: 'Sudolab' },
  category: 'productivity',
  homepage: 'https://octopad.app',
  source: './plugins/octoplan-claude'
};
if (octoplanClaudeEntries.length !== 1 || JSON.stringify(octoplanClaudeEntries[0]) !== JSON.stringify(expectedOctoplanClaudeEntry)) process.exit(1);
const agent = fs.readFileSync(path.join(root, 'plugins/manage-product-documentation-codex/skills/manage-product-documentation/agents/openai.yaml'), 'utf8');
const expectedAgent = `interface:
  display_name: "Manage Product Documentation"
  short_description: "Keep product knowledge aligned as work evolves"
  default_prompt: "${prompt}"

dependencies:
  tools:
    - type: "mcp"
      value: "octopad"
      description: "Read and update Octopad pages, work streams, tasks, decisions, and links"
      transport: "streamable_http"
      url: "https://mcp.octopad.app/mcp"

policy:
  allow_implicit_invocation: true
`;
if (agent !== expectedAgent) process.exit(1);
const skill = fs.readFileSync(path.join(root, 'plugins/manage-product-documentation-codex/skills/manage-product-documentation/SKILL.md'), 'utf8');
if (!/^---\nname: manage-product-documentation\ndescription: [^\n]+\n---\nVersion: 1\.4\.0\n/.test(skill) || skill.includes('[TODO:')) process.exit(1);
const claudeSkill = fs.readFileSync(path.join(root, 'plugins/manage-product-documentation-claude/skills/manage-product-documentation/SKILL.md'), 'utf8');
const versionOf = (text) => text.match(/^Version: (\d+\.\d+\.\d+)$/m)?.[1];
if (versionOf(skill) !== codexManifest.version || versionOf(claudeSkill) !== codexManifest.version) process.exit(1);
for (const required of ['literal `Why` and `What` sections', '`Done when` for every top-level Task', '`impact` from 1 to 5', '`impact_rationale`', '`parent_task_id`', 'rationale for every dependency edge']) {
  if (!skill.includes(required)) process.exit(1);
}
const artifactShapes = fs.readFileSync(path.join(root, 'plugins/manage-product-documentation-codex/skills/manage-product-documentation/references/artifact-shapes.md'), 'utf8');
for (const required of ['literal `Why`, `What`, and `Done when` sections', '`impact` from 1 to 5', '`impact_rationale`', '`parent_task_id`', 'dependency edge']) {
  if (!artifactShapes.includes(required)) process.exit(1);
}
NODE
grep -q '^Version: 1\.4\.0$' "$root/plugins/manage-product-documentation-codex/skills/manage-product-documentation/SKILL.md" || fail 'product-documentation skill is not 1.4.0'
grep -q '^Version: 1\.4\.0$' "$root/plugins/manage-product-documentation-claude/skills/manage-product-documentation/SKILL.md" || fail 'Claude product-documentation skill is not 1.4.0'

for relative in SKILL.md references/documentation-model.md references/artifact-shapes.md references/lifecycle-playbooks.md; do
  cmp -s \
    "$root/plugins/manage-product-documentation-codex/skills/manage-product-documentation/$relative" \
    "$root/plugins/manage-product-documentation-claude/skills/manage-product-documentation/$relative" \
    || fail "product-documentation shared contract drifted at $relative"
done

! grep -Eiq '\b(Codex|Claude)\b' \
  "$root/plugins/manage-product-documentation-codex/skills/manage-product-documentation/SKILL.md" \
  "$root/plugins/manage-product-documentation-codex/skills/manage-product-documentation/references/documentation-model.md" \
  "$root/plugins/manage-product-documentation-codex/skills/manage-product-documentation/references/artifact-shapes.md" \
  "$root/plugins/manage-product-documentation-codex/skills/manage-product-documentation/references/lifecycle-playbooks.md" \
  || fail 'product-documentation shared contract contains runtime-specific wording'

grep -q '^## manage-product-documentation$' "$root/CHANGELOG.md" || fail 'product-documentation changelog section is missing'
grep -q '^### 1\.0\.0 — 2026-08-13$' "$root/CHANGELOG.md" || fail 'product-documentation 1.0.0 history is missing'
grep -q '^### 1\.1\.0 — 2026-08-13$' "$root/CHANGELOG.md" || fail 'product-documentation 1.1.0 entry is missing'
grep -q '^### 1\.2\.0 — 2026-08-13$' "$root/CHANGELOG.md" || fail 'product-documentation 1.2.0 entry is missing'
grep -q '^### 1\.3\.0 — 2026-08-22$' "$root/CHANGELOG.md" || fail 'product-documentation 1.3.0 entry is missing'
grep -q '^### 1\.4\.0 — 2026-08-24$' "$root/CHANGELOG.md" || fail 'product-documentation 1.4.0 entry is missing'
grep -q '"version": "18\.0\.0"' "$root/plugins/octoplan-codex/.codex-plugin/plugin.json" || fail 'Codex plugin is not 18.0.0'
grep -q '^Version: 18\.0\.0$' "$root/plugins/octoplan-codex/skills/octoplan/SKILL.md" || fail 'Codex skill is not 18.0.0'
grep -Fq 'Missing route metadata never makes a review fail or become `INFEASIBLE`.' "$root/plugins/octoplan-codex/skills/octoplan/references/codex-runtime.md" || fail 'Codex route capability degradation is missing'
grep -Fq 'note once per run that the route is declared, not provable here' "$root/plugins/octoplan-codex/skills/octoplan/references/codex-runtime.md" || fail 'Codex route degradation note is missing'
grep -Fq 'known mismatch' "$root/plugins/octoplan-codex/CONFORMANCE.md" || fail 'Codex conformance does not preserve no-substitution on known mismatch'
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
grep -q '^### 16\.0\.0 — 2026-08-13$' "$root/CHANGELOG.md" || fail 'Codex 16.0.0 entry is missing'
grep -q '^### 17\.0\.0 — 2026-08-14$' "$root/CHANGELOG.md" || fail 'Codex 17.0.0 entry is missing'
grep -q '^### 17\.2\.0 — 2026-08-17$' "$root/CHANGELOG.md" || fail 'Codex 17.2.0 entry is missing'
grep -q '^### 18\.0\.0 — 2026-08-24$' "$root/CHANGELOG.md" || fail 'Codex 18.0.0 entry is missing'
! grep -q '^### 2\.0\.0 — 2026-08-03$' "$root/CHANGELOG.md" || fail 'false Claude 2.0.0 release remains'

node - "$claude_skill" <<'NODE'
const assert = require('assert');
const fs = require('fs');
const text = fs.readFileSync(process.argv[2], 'utf8');
const lines = text.split(/\r?\n/);

function tableRows(header) {
  const start = lines.indexOf(header);
  assert(start >= 0, `missing table: ${header}`);
  const rows = [];
  for (let i = start + 2; i < lines.length && lines[i].startsWith('|'); i++) rows.push(lines[i]);
  return rows;
}

const routes = tableRows('| Task profile | Recommend |');
const sonnetRoutes = routes.filter(line => line.includes('Sonnet 5'));
assert.strictEqual(sonnetRoutes.length, 1, 'routing table must contain one Sonnet 5 lane');
assert(sonnetRoutes[0].includes('**Sonnet 5 · xhigh**'), 'Sonnet 5 lane must use xhigh');
for (const forbidden of ['Sonnet 5 · low', 'Sonnet 5 · medium', 'Sonnet 5 · high']) {
  assert(!text.includes(forbidden), `forbidden Sonnet route: ${forbidden}`);
}

const effortRows = tableRows('| Setting | Octoplan policy |');
const effortLabels = effortRows.map(line => line.split('|')[1].trim().replaceAll('`', ''));
assert.deepStrictEqual(effortLabels, ['low', 'medium', 'high', 'extra high (xhigh)', 'max', 'ultra / ultracode']);
assert(text.includes('Every Fable 5 recommendation, at any effort, requires confirmed availability and acceptance of its mandatory 30-day data retention.'), 'global Fable retention gate is missing');
assert(text.includes('If either condition fails, use Opus 5 at the best compatible effort for the task.'), 'Fable fallback is missing');
assert(!text.includes('Opus 4.6 · xhigh'), 'Opus 4.6 cannot satisfy xhigh');
assert(text.includes('The `/effort ultracode` session setting combines `xhigh` with automatic workflow orchestration'), '/effort ultracode contract is missing');
assert(text.includes('the `ultracode` prompt keyword starts one workflow at the session\'s current effort'), 'one-prompt ultracode distinction is missing');
assert(text.includes('never write `effort: ultra`'), 'native ultra prohibition is missing');
NODE

find "$root" -type f -name '*.json' -not -path '*/.git/*' -exec sh -c '
  for file do
    node -e "JSON.parse(require(\"fs\").readFileSync(process.argv[1], \"utf8\"))" "$file" || exit 1
  done
' sh {} + || fail 'invalid JSON'

git -C "$root" diff --check || fail 'whitespace errors in diff'

sh "$root/scripts/validate-octoplan-codex.sh"

printf 'PASS: octopad-mcp repository contract\n'
