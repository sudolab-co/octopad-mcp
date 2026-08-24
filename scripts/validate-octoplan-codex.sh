#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill="$root/plugins/octoplan-codex/skills/octoplan"
main="$skill/SKILL.md"
planning="$skill/references/planning.md"
runtime="$skill/references/codex-runtime.md"
supervision="$skill/references/codex-supervision.md"
multi_stream="$skill/references/multi-stream.md"
recovery="$skill/references/recovery.md"
conformance="$root/plugins/octoplan-codex/CONFORMANCE.md"
manifest="$root/plugins/octoplan-codex/.codex-plugin/plugin.json"
agent_manifest="$skill/agents/openai.yaml"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_file() {
  [ -f "$1" ] || fail "missing file: $1"
}

require_contract() {
  grep -Fq -- "$2" "$1" || fail "missing contract in $(basename "$1"): $2"
}

active_files="$main $planning $runtime $supervision $multi_stream $recovery"
for file in $active_files "$conformance" "$manifest" "$agent_manifest"; do
  require_file "$file"
done

[ ! -d "$skill/roles" ] || fail 'retired role-pack directory remains'
expected_refs='codex-runtime.md
codex-supervision.md
multi-stream.md
planning.md
recovery.md'
actual_refs=$(find "$skill/references" -maxdepth 1 -type f -name '*.md' -exec basename '{}' \; | sort)
[ "$actual_refs" = "$expected_refs" ] || fail 'unexpected Codex reference set'

skill_version=$(sed -n 's/^Version: //p' "$main")
[ "$skill_version" = '18.0.0' ] || fail 'Codex SKILL.md is not 18.0.0'
manifest_version=$(node -e 'process.stdout.write(JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).version)' "$manifest")
[ "$manifest_version" = "$skill_version" ] || fail 'Codex skill and manifest versions differ'
readme_row=$(printf '| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | %s | Confirms a Brief, reviews the Plan, then supervises authorized Delivery at the chosen interruption level. |' "$skill_version")
[ "$(grep -Fxc "$readme_row" "$root/README.md")" -eq 1 ] || fail 'README Codex version or behavior is stale'
latest_changelog=$(awk '/^## octoplan-codex$/ { found=1; next } found && /^### / { sub(/^### /, ""); sub(/ — .*/, ""); print; exit }' "$root/CHANGELOG.md")
[ "$latest_changelog" = "$skill_version" ] || fail 'latest Codex changelog version differs from the skill'
require_contract "$conformance" '# Octoplan Codex 18.0.0 conformance'
require_contract "$conformance" 'Autopilot sources are outside this release.'

skill_lines=$(wc -l < "$main" | tr -d ' ')
planning_lines=$(wc -l < "$planning" | tr -d ' ')
runtime_lines=$(wc -l < "$runtime" | tr -d ' ')
supervision_lines=$(wc -l < "$supervision" | tr -d ' ')
multi_stream_lines=$(wc -l < "$multi_stream" | tr -d ' ')
recovery_lines=$(wc -l < "$recovery" | tr -d ' ')
[ "$skill_lines" -le 70 ] || fail "SKILL.md exceeds 70 lines: $skill_lines"
[ "$planning_lines" -le 170 ] || fail "planning.md exceeds 170 lines: $planning_lines"
[ "$runtime_lines" -le 45 ] || fail "codex-runtime.md exceeds 45 lines: $runtime_lines"
[ "$supervision_lines" -le 105 ] || fail "codex-supervision.md exceeds 105 lines: $supervision_lines"
[ "$multi_stream_lines" -le 35 ] || fail "multi-stream.md exceeds 35 lines: $multi_stream_lines"
[ "$recovery_lines" -le 45 ] || fail "recovery.md exceeds 45 lines: $recovery_lines"
active_lines=$((skill_lines + planning_lines + runtime_lines + supervision_lines + multi_stream_lines + recovery_lines))
active_words=$(wc -w $active_files | awk 'END {print $1}')
[ "$active_lines" -le 440 ] || fail "active skill documents exceed 440 lines: $active_lines"
[ "$active_words" -le 5900 ] || fail "active skill documents exceed 5900 words: $active_words"
validator_lines=$(wc -l < "$0" | tr -d ' ')
[ "$validator_lines" -ge 150 ] && [ "$validator_lines" -le 250 ] ||
  fail "validator must stay between 150 and 250 lines: $validator_lines"

brief_banner='**Octoplan · Step 1 of 3 — Brief**'
plan_banner='**Octoplan · Step 2 of 3 — Plan**'
delivery_banner='**Octoplan · Step 3 of 3 — Delivery**'
require_contract "$main" "$brief_banner"
require_contract "$main" "$plan_banner"
require_contract "$main" "$delivery_banner"
require_contract "$planning" "$brief_banner"
require_contract "$planning" "$plan_banner"
require_contract "$supervision" "$delivery_banner"
actual_banners=$(grep -h -o '\*\*Octoplan · Step [^*]*\*\*' $active_files | sort -u)
expected_banners=$(printf '%s\n%s\n%s\n' "$brief_banner" "$plan_banner" "$delivery_banner" | sort)
[ "$actual_banners" = "$expected_banners" ] || fail 'a non-canonical stage banner remains'
if grep -Fq '## Octoplan ·' $active_files || grep -Fq 'Marked checkpoints' $active_files; then
  fail 'non-canonical banner or interruption mode remains'
fi

require_contract "$main" '**Full autonomy.**'
require_contract "$main" '**Checkpoints.**'
require_contract "$main" '**Step-by-step.**'
require_contract "$planning" 'Full autonomy · Checkpoints · Step-by-step'
require_contract "$main" 'The go authorizes every disclosed effect and Delivery runs uninterrupted.'
require_contract "$main" 'only an undisclosed effect, outcome change, or authority need asks for new consent'
require_contract "$main" 'House rules are not a level.'
require_contract "$planning" 'Octoplan 18 delivery authorization'
require_contract "$planning" 'post-strike selected checkpoints'

for foundation in F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 F13; do
  require_contract "$main" "**$foundation,"
  require_contract "$conformance" "| $foundation,"
done

require_contract "$main" 'eight or more tasks'
require_contract "$main" 'at least two independent judgments with distinct primary lenses'
require_contract "$main" 'Every material executable change gets at least one fresh independent review'
require_contract "$main" 'a second focused independent lens for a one-way-door surface'
require_contract "$main" 'cannot be undone'
require_contract "$main" 'bills money to any party'
require_contract "$planning" 'OCTOPLAN_PLAN_REVIEW'
require_contract "$planning" 'exact task IDs and `updated_at` revisions reviewed'
require_contract "$planning" 'confirm that every reviewed task still has the timestamp'
require_contract "$runtime" 'route is declared, not provable here'
require_contract "$runtime" 'Positive evidence of either a wrong model or wrong effort pauses that actor without substitution.'
require_contract "$recovery" 'OCTOPLAN_ACTION <stable-key>'
require_contract "$recovery" 'external non-idempotent effect'
require_contract "$recovery" 'Retry only when authoritative evidence proves it absent'
require_contract "$main" 'one supervisor at a time'
require_contract "$main" 'record it as a stream Decision'
require_contract "$main" 'A successor confirms that its predecessor stopped before acting.'
require_contract "$main" 'expected_updated_at'

for retired in OCTOPLAN_DISPATCH 'supervisor lease' 'lease generation' \
  'quiescence receipt' 'canonical fingerprint' '**Plan ref**' 'one-to-one ref-to-ID' \
  'under 64 characters'; do
  if grep -Fiq "$retired" $active_files; then
    fail "retired machinery remains: $retired"
  fi
done

for label in '**State**' '**Done**' '**Blocked**' '**Decision expected**' '**To unblock**' '**Next step**'; do
  require_contract "$supervision" "$label"
done
require_contract "$supervision" 'six-field recap'
require_contract "$supervision" 'current integrated outcome is proved'
require_contract "$main" 'Silence, timeout, irrelevant green checks, and unrun checks are not PASS.'
for state in built reviewed merged applied verified released accepted; do
  state_token=$(printf '`%s`' "$state")
  require_contract "$main" "$state_token"
done
require_contract "$main" 'a domain equivalent where a shared state has no meaning'

require_contract "$agent_manifest" 'allow_implicit_invocation: false'
plugin_prompt=$(node -p 'require(process.argv[1]).interface.defaultPrompt[0]' "$manifest")
agent_prompt=$(sed -n 's/^  default_prompt: "\(.*\)"$/\1/p' "$agent_manifest")
plugin_prompt_length=$(printf '%s' "$plugin_prompt" | awk '{ print length }')
[ -n "$plugin_prompt" ] && [ "$plugin_prompt_length" -le 128 ] || fail 'plugin default prompt exceeds 128 characters'
[ "$plugin_prompt" = "$agent_prompt" ] || fail 'plugin and agent default prompts differ'

private_material_pattern="/""Users/|[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY"
for file in $active_files "$conformance" "$manifest" "$agent_manifest"; do
  if sed 's/support@octopad\.ai//g' "$file" | grep -E "$private_material_pattern" >/dev/null 2>&1; then
    fail "private or identifying material appears in public file: $file"
  fi
done

node <<'NODE'
const assert = require('assert');

function planReviewFloor({taskCount, schema = false, permissions = false, money = false,
  privacy = false, destructive = false}) {
  if (!Number.isInteger(taskCount) || taskCount < 0) return 2;
  return taskCount >= 8 || schema || permissions || money || privacy || destructive ? 2 : 1;
}

assert.strictEqual(planReviewFloor({taskCount: 7}), 1);
assert.strictEqual(planReviewFloor({taskCount: 8}), 2);
for (const trigger of ['schema', 'permissions', 'money', 'privacy', 'destructive']) {
  assert.strictEqual(planReviewFloor({taskCount: 1, [trigger]: true}), 2);
}
assert.strictEqual(planReviewFloor({taskCount: '8'}), 2);

function deliveryReviewFloor({assessed = false, material, oneWayDoor}) {
  if (assessed !== true || typeof material !== 'boolean' || typeof oneWayDoor !== 'boolean') return 2;
  if (oneWayDoor) return 2;
  return material ? 1 : 0;
}

assert.strictEqual(deliveryReviewFloor({}), 2);
assert.strictEqual(deliveryReviewFloor({assessed: true, material: false, oneWayDoor: false}), 0);
assert.strictEqual(deliveryReviewFloor({assessed: true, material: true, oneWayDoor: false}), 1);
assert.strictEqual(deliveryReviewFloor({assessed: true, material: false, oneWayDoor: true}), 2);
assert.strictEqual(deliveryReviewFloor({assessed: true, material: true, oneWayDoor: true}), 2);

const closureVocabulary = new Set(['built', 'reviewed', 'merged', 'applied', 'verified', 'released', 'accepted']);
assert.strictEqual(closureVocabulary.has('verified'), true);
assert.strictEqual(closureVocabulary.has('done'), false);
assert.strictEqual(closureVocabulary.has('green'), false);
NODE

printf 'PASS: Octoplan Codex 18.0.0 contract (%s words, %s validator lines)\n' "$active_words" "$validator_lines"
