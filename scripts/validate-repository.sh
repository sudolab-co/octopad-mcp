#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

[ -f "$root/INSTALL.md" ] || fail 'AI connection guide is missing'
[ -f "$root/.github/workflows/validate.yml" ] || fail 'repository validation workflow is missing'
[ -d "$root/plugins/octopad-claude" ] || fail 'Claude Octopad bundle is missing'
[ -d "$root/plugins/octopad-codex" ] || fail 'Codex Octopad bundle is missing'
[ ! -e "$root/plugins/octopad" ] || fail 'the Codex bundle moved to plugins/octopad-codex'
# Retired standalone plugins stay listed, frozen and marked, only until Octopad's public install pages stop naming them.
for retired in octoplan-claude octoplan-codex manage-product-documentation-claude manage-product-documentation-codex; do
  [ ! -e "$root/plugins/$retired" ] || grep -Rq "Retired: now part of the octopad plugin" "$root/.claude-plugin/marketplace.json" || fail "plugins/$retired is listed without its retirement notice"
done
[ ! -e "$root/plugins/octoplan" ] || fail 'unsupported Claude distribution path remains'
[ ! -e "$root/plugins/octoplan-autopilot" ] || fail 'retired octoplan-autopilot distribution remains'

grep -Fq '# Octopad MCP' "$root/README.md" || fail 'README does not lead with Octopad MCP'
grep -Fq 'Give your AI this repository URL' "$root/README.md" || fail 'AI-first install handoff is missing'
grep -Fq 'Connect Octopad using this repository.' "$root/README.md" || fail 'README connection prompt is missing'
grep -Fq '**"Use Octopad. Start my onboarding."**' "$root/README.md" || fail 'README onboarding handoff is missing'
grep -Fq 'https://chatgpt.com/plugins' "$root/README.md" || fail 'README ChatGPT directory link is missing'
grep -Fq 'official Octopad app' "$root/README.md" || fail 'README ChatGPT app route is missing'
grep -Fq 'supported customer-facing ChatGPT plugin' "$root/README.md" || fail 'README ChatGPT terminology bridge is missing'
grep -Fq 'Octopad > Settings > AI clients' "$root/README.md" || fail 'README connection-revocation path is missing'
[ -f "$root/SECURITY.md" ] || fail 'security reporting guide is missing'
grep -Fq 'https://mcp.octopad.app/mcp' "$root/INSTALL.md" || fail 'canonical MCP endpoint is missing'
grep -Fq 'Add the MCP connection only by default' "$root/INSTALL.md" || fail 'MCP-only default is not explicit'
grep -Fq '**"Use Octopad. Start my onboarding."**' "$root/INSTALL.md" || fail 'install onboarding handoff is missing'
grep -Fq '/reload-plugins' "$root/INSTALL.md" || fail 'Claude plugin reload step is missing'
grep -Fq 'codex plugin marketplace upgrade octopad-mcp' "$root/INSTALL.md" || fail 'Codex marketplace refresh step is missing'
grep -Fq 'codex plugin add octopad@octopad-mcp' "$root/INSTALL.md" || fail 'Codex bundle install step is missing'
grep -Fq '/plugin install octopad@octopad-mcp' "$root/INSTALL.md" || fail 'Claude bundle install step is missing'
grep -Fq '/plugin uninstall octoplan-claude@octopad-mcp' "$root/INSTALL.md" || fail 'Claude migration from retired plugins is missing'
grep -Fq 'codex plugin remove octoplan-codex@octopad-mcp' "$root/INSTALL.md" || fail 'Codex migration from retired plugins is missing'
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
grep -q '"name": "octopad"' "$root/plugins/octopad-claude/.claude-plugin/plugin.json" || fail 'Claude bundle ID is not octopad'
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
grep -q '^## manage-product-documentation$' "$root/CHANGELOG.md" || fail 'product-documentation changelog section is missing'
grep -q '^### 1\.0\.0 — 2026-08-13$' "$root/CHANGELOG.md" || fail 'product-documentation 1.0.0 history is missing'
grep -q '^### 1\.1\.0 — 2026-08-13$' "$root/CHANGELOG.md" || fail 'product-documentation 1.1.0 entry is missing'
grep -q '^### 1\.2\.0 — 2026-08-13$' "$root/CHANGELOG.md" || fail 'product-documentation 1.2.0 entry is missing'
grep -q '^### 1\.3\.0 — 2026-08-22$' "$root/CHANGELOG.md" || fail 'product-documentation 1.3.0 entry is missing'
grep -q '^### 1\.4\.0 — 2026-08-24$' "$root/CHANGELOG.md" || fail 'product-documentation 1.4.0 entry is missing'
grep -q '^#### 1\.4\.0 — 2026-07-30$' "$root/CHANGELOG.md" || fail 'Claude 1.4.0 history is missing'
grep -q '^#### 10\.0\.0 — 2026-08-08$' "$root/CHANGELOG.md" || fail 'Codex 10.0.0 entry is missing'
grep -q '^#### 10\.1\.0 — 2026-08-09$' "$root/CHANGELOG.md" || fail 'Codex 10.1.0 entry is missing'
grep -q '^#### 10\.2\.0 — 2026-08-09$' "$root/CHANGELOG.md" || fail 'Codex 10.2.0 entry is missing'
grep -q '^#### 10\.2\.1 — 2026-08-09$' "$root/CHANGELOG.md" || fail 'Codex 10.2.1 entry is missing'
grep -q '^#### 11\.0\.0 — 2026-08-09$' "$root/CHANGELOG.md" || fail 'Codex 11.0.0 entry is missing'
grep -q '^#### 12\.1\.0 — 2026-08-11$' "$root/CHANGELOG.md" || fail 'Codex 12.1.0 entry is missing'
grep -q '^#### 13\.0\.0 — 2026-08-11$' "$root/CHANGELOG.md" || fail 'Codex 13.0.0 entry is missing'
grep -q '^#### 13\.1\.0 — 2026-08-11$' "$root/CHANGELOG.md" || fail 'Codex 13.1.0 entry is missing'
grep -q '^#### 14\.0\.0 — 2026-08-12$' "$root/CHANGELOG.md" || fail 'Codex 14.0.0 entry is missing'
grep -q '^#### 15\.0\.0 — 2026-08-12$' "$root/CHANGELOG.md" || fail 'Codex 15.0.0 entry is missing'
grep -q '^#### 16\.0\.0 — 2026-08-13$' "$root/CHANGELOG.md" || fail 'Codex 16.0.0 entry is missing'
grep -q '^#### 17\.0\.0 — 2026-08-14$' "$root/CHANGELOG.md" || fail 'Codex 17.0.0 entry is missing'
grep -q '^#### 17\.2\.0 — 2026-08-17$' "$root/CHANGELOG.md" || fail 'Codex 17.2.0 entry is missing'
grep -q '^#### 18\.0\.0 — 2026-08-24$' "$root/CHANGELOG.md" || fail 'Codex 18.0.0 entry is missing'
grep -q '^#### 18\.0\.1 — 2026-08-24$' "$root/CHANGELOG.md" || fail 'Codex 18.0.1 entry is missing'
! grep -Eq '^#{3,4} 2\.0\.0 — 2026-08-03$' "$root/CHANGELOG.md" || fail 'false Claude 2.0.0 release remains'

node - "$root" <<'NODE' || fail 'one skill, one name: a folder, plugin name or manifest disagrees'
const fs = require('fs');
const path = require('path');
const root = process.argv[2];
const runtimes = ['claude', 'codex'];

// A distribution folder is either <plugin name> or <plugin name>-<runtime>.
// The manifest inside it must carry the plugin name the marketplace advertises.
function check(entryName, folder, manifestRelative) {
  const base = path.basename(folder);
  const ok = base === entryName || runtimes.some((r) => base === `${entryName}-${r}`);
  if (!ok) throw new Error(`folder ${base} does not match plugin name ${entryName}`);
  const manifest = JSON.parse(fs.readFileSync(path.join(root, folder, manifestRelative), 'utf8'));
  if (manifest.name !== entryName) throw new Error(`${folder} manifest name ${manifest.name} is not ${entryName}`);
  const skills = fs.readdirSync(path.join(root, folder, 'skills'));
  if (entryName === 'octopad') {
    const expected = ['octopad-session', 'octoplan', 'octopad-knowledge-evidence', 'octopad-planning-and-work-design', 'octopad-notepad', 'manage-activity-context', 'manage-market-intelligence', 'manage-product-documentation', 'manage-product-marketing', 'pmm-check', 'technical-writing', 'octopad-crm'];
    if (JSON.stringify(skills.sort()) !== JSON.stringify(expected.sort())) throw new Error('Octopad must ship ten satellites, Octoplan and one bootstrap');
    for (const skill of skills) {
      const name = fs.readFileSync(path.join(root, folder, 'skills', skill, 'SKILL.md'), 'utf8').match(/^name: (.+)$/m)?.[1];
      if (name !== skill) throw new Error(`Octopad skill name mismatch: ${skill}`);
    }
    return;
  }
  if (skills.length !== 1) throw new Error(`${folder} must ship exactly one skill directory`);
  const skillName = fs.readFileSync(path.join(root, folder, 'skills', skills[0], 'SKILL.md'), 'utf8')
    .match(/^name: (.+)$/m)?.[1];
  if (skillName !== skills[0]) throw new Error(`${folder} skill directory ${skills[0]} does not match its name: ${skillName}`);
  const stripped = runtimes.reduce((n, r) => (n.endsWith(`-${r}`) ? n.slice(0, -r.length - 1) : n), entryName);
  if (skillName !== stripped) throw new Error(`${folder} skill ${skillName} should be ${stripped}`);
}

const claude = JSON.parse(fs.readFileSync(path.join(root, '.claude-plugin/marketplace.json'), 'utf8'));
for (const entry of claude.plugins) check(entry.name, entry.source.replace(/^\.\//, ''), '.claude-plugin/plugin.json');
const codex = JSON.parse(fs.readFileSync(path.join(root, '.agents/plugins/marketplace.json'), 'utf8'));
for (const entry of codex.plugins) check(entry.name, entry.source.path.replace(/^\.\//, ''), '.codex-plugin/plugin.json');

// Every folder under plugins/ must be advertised by exactly one marketplace.
const advertised = new Set([
  ...claude.plugins.map((e) => e.source.replace(/^\.\//, '')),
  ...codex.plugins.map((e) => e.source.path.replace(/^\.\//, ''))
]);
for (const dir of fs.readdirSync(path.join(root, 'plugins'))) {
  if (!advertised.has(`plugins/${dir}`)) throw new Error(`plugins/${dir} is in no marketplace`);
}
NODE

find "$root" -type f -name '*.json' -not -path '*/.git/*' -exec sh -c '
  for file do
    node -e "JSON.parse(require(\"fs\").readFileSync(process.argv[1], \"utf8\"))" "$file" || exit 1
  done
' sh {} + || fail 'invalid JSON'

git -C "$root" diff --check || fail 'whitespace errors in diff'

python3 "$root/scripts/validate-octoplan.py"
python3 "$root/scripts/test-octoplan-packaging.py"

python3 "$root/scripts/sync-octopad.py" --check
python3 "$root/scripts/test-octopad-packaging.py"

printf 'PASS: octopad-mcp repository contract\n'
