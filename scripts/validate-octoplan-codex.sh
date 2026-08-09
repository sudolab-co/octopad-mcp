#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill="$root/plugins/octoplan-codex/skills/octoplan"
contract="$skill/references/octoplan-contract-v3.md"
planning="$skill/references/planning.md"
runtime="$skill/references/codex-runtime.md"
supervision="$skill/references/codex-supervision.md"
roles="$skill/roles"
manifest="$root/plugins/octoplan-codex/.codex-plugin/plugin.json"
changelog="$root/CHANGELOG.md"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_file() {
  [ -f "$1" ] || fail "missing file: $1"
}

require_text() {
  grep -Fq -- "$2" "$1" || fail "missing contract text in $(basename "$1"): $2"
}

require_file "$skill/SKILL.md"
require_file "$contract"
require_file "$planning"
require_file "$runtime"
require_file "$supervision"
for role in planner plan-reviewer supervisor executor reviewer specialist-reviewer recovery follow-up; do
  require_file "$roles/$role.md"
done

grep -q '^Version: 10\.2\.0$' "$skill/SKILL.md" || fail 'Codex SKILL.md is not 10.2.0'
grep -q '"version": "10\.2\.0"' "$manifest" || fail 'Codex plugin is not 10.2.0'
grep -q '^### 10\.2\.0 — 2026-08-09$' "$changelog" || fail 'Codex changelog lacks 10.2.0'
release_note_102=$(awk '/^### 10\.2\.0 — 2026-08-09$/ { capture=1; next } capture && /^### / { exit } capture { print }' "$changelog")
printf '%s\n' "$release_note_102" | grep -Fq 'plain idea without an existing stream or saved plan' || fail '10.2.0 release note lacks greenfield behavior'
printf '%s\n' "$release_note_102" | grep -Fq 'two-stage execution runway' || fail '10.2.0 release note lacks staged pre-write checks'
printf '%s\n' "$release_note_102" | grep -Fq 'journaled candidate' || fail '10.2.0 release note lacks resumable candidate behavior'
printf '%s\n' "$release_note_102" | grep -Fq 'read-only plan reviewer' || fail '10.2.0 release note lacks detached review behavior'
printf '%s\n' "$release_note_102" | grep -Fq 'outbox event together before publication' || fail '10.2.0 release note lacks atomic handoff behavior'
printf '%s\n' "$release_note_102" | grep -Fq 'Existing 10.1.0 plans remain valid without migration' || fail '10.2.0 release note lacks compatibility statement'
printf '%s\n' "$release_note_102" | grep -Fq 'The Claude distribution is unchanged' || fail '10.2.0 release note lacks Claude isolation'
for forbidden_public_term in 'explicit-no-loop' 'plan-bound' 'outcome-bound' 'delivery_mandate'; do
  if printf '%s\n' "$release_note_102" | grep -Fq "$forbidden_public_term"; then
    fail "10.2.0 release note exposes internal delivery term: $forbidden_public_term"
  fi
done
grep -q '^### 10\.1\.0 — 2026-08-09$' "$changelog" || fail 'Codex changelog lacks 10.1.0'
release_note_101=$(awk '/^### 10\.1\.0 — 2026-08-09$/ { capture=1; next } capture && /^### / { exit } capture { print }' "$changelog")
printf '%s\n' "$release_note_101" | grep -Fq 'execution runway before any Octopad planning write' || fail '10.1.0 release note lacks pre-write runway behavior'
printf '%s\n' "$release_note_101" | grep -Fq 'null-project relocation' || fail '10.1.0 release note lacks null-project fixture coverage'
printf '%s\n' "$release_note_101" | grep -Fq 'Existing 10.0.0 plans remain valid' || fail '10.1.0 release note lacks compatibility statement'
printf '%s\n' "$release_note_101" | grep -Fq 'The Claude distribution is unchanged' || fail '10.1.0 release note lacks Claude isolation'
release_note=$(awk '/^### 10\.0\.0 — 2026-08-08$/ { capture=1; next } capture && /^### / { exit } capture { print }' "$changelog")
printf '%s\n' "$release_note" | grep -Fq 'six-field handoff' || fail '10.0.0 release note lacks handoff behavior'
printf '%s\n' "$release_note" | grep -Fq 'Luna max' || fail '10.0.0 release note lacks capacity-floor behavior'
printf '%s\n' "$release_note" | grep -Fq 'native project identity' || fail '10.0.0 release note lacks native project identity behavior'
printf '%s\n' "$release_note" | grep -Fq 'Claude distribution is unchanged' || fail '10.0.0 release note lacks Claude isolation'
for forbidden_public_term in 'Delivery mandate' 'explicit-no-loop' 'plan-bound' 'outcome-bound'; do
  if printf '%s\n' "$release_note" | grep -Fq "$forbidden_public_term"; then
    fail "10.0.0 release note exposes internal delivery term: $forbidden_public_term"
  fi
done
grep -Fq 'requires explicit execution authority before execution' "$root/CONTRIBUTING.md" || fail 'Codex CONTRIBUTING sentence is stale'
grep -Fq 'Any other saved contract is unsupported and must be replanned before use.' "$skill/SKILL.md" || fail 'unsupported-contract entry boundary is missing'
[ "$(grep -Fc 'Any other saved contract is unsupported and must be replanned before use.' "$skill/SKILL.md")" -eq 1 ] || fail 'unsupported-contract boundary is not stated once'

expected_refs='codex-runtime.md
codex-supervision.md
octoplan-contract-v3.md
planning.md'
actual_refs=$(find "$skill/references" -maxdepth 1 -type f -name '*.md' -exec basename '{}' \; | sort)
[ "$actual_refs" = "$expected_refs" ] || fail 'active references are not exactly the four supported references'
if find "$skill/references" -maxdepth 1 -type f -iname '*legacy*' | grep -q .; then
  fail 'historical reference file remains'
fi

active_docs="$skill/SKILL.md $contract $planning $runtime $supervision"
if sed 's/octoplan-candidate-v1//g' $active_docs | grep -E -i -n '(^|[^[:alnum:]])v1([^[:alnum:]]|$)|(^|[^[:alnum:]])v4([^[:alnum:]]|$)|(^|[^[:alnum:]])v5([^[:alnum:]]|$)|legacy' >/dev/null 2>&1; then
  fail 'unsupported historical contract wording remains in active skill documents'
fi
for forbidden in confirmed_brief_digest message_time decision_status; do
  if grep -Fq "$forbidden" $active_docs; then
    fail "obsolete field remains: $forbidden"
  fi
done

skill_lines=$(wc -l < "$skill/SKILL.md" | tr -d ' ')
planning_lines=$(wc -l < "$planning" | tr -d ' ')
contract_lines=$(wc -l < "$contract" | tr -d ' ')
runtime_lines=$(wc -l < "$runtime" | tr -d ' ')
supervision_lines=$(wc -l < "$supervision" | tr -d ' ')
[ "$skill_lines" -le 40 ] || fail "SKILL.md exceeds 40 lines: $skill_lines"
[ "$planning_lines" -le 180 ] || fail "planning.md exceeds 180 lines: $planning_lines"
[ "$contract_lines" -le 290 ] || fail "octoplan-contract-v3.md exceeds 290 lines: $contract_lines"
[ "$runtime_lines" -le 95 ] || fail "codex-runtime.md exceeds 95 lines: $runtime_lines"
[ "$supervision_lines" -le 185 ] || fail "codex-supervision.md exceeds 185 lines: $supervision_lines"
active_lines=$((skill_lines + planning_lines + contract_lines + runtime_lines + supervision_lines))
active_words=$(wc -w $active_docs | awk 'END {print $1}')
common_lines=$((skill_lines + planning_lines + contract_lines))
common_words=$(wc -w "$skill/SKILL.md" "$planning" "$contract" | awk 'END {print $1}')
[ "$active_lines" -le 760 ] || fail "active skill documents exceed 760 lines: $active_lines"
[ "$active_words" -le 11400 ] || fail "active skill documents exceed 11400 words: $active_words"
[ "$common_lines" -le 500 ] || fail "common planning load exceeds 500 lines: $common_lines"
[ "$common_words" -le 7350 ] || fail "common planning load exceeds 7350 words: $common_words"

for toc_file in "$planning" "$contract" "$runtime" "$supervision"; do
  require_text "$toc_file" '## Contents'
done
require_text "$skill/SKILL.md" 'references/planning.md'
require_text "$skill/SKILL.md" 'references/octoplan-contract-v3.md'
require_text "$skill/SKILL.md" 'references/codex-runtime.md'
require_text "$skill/SKILL.md" 'references/codex-supervision.md'
require_text "$contract" '[Targets and parsing](#targets-and-parsing)'
require_text "$contract" '[Extraction and canonicalization](#extraction-and-canonicalization)'
require_text "$planning" '[Feasibility](#feasibility)'
require_text "$planning" '[Execution runway](#execution-runway)'
require_text "$planning" '[Consent binding](#consent-binding)'
require_text "$runtime" '[Shared capacity ladder](#shared-capacity-ladder)'
require_text "$runtime" '[Target and route binding](#target-and-route-binding)'
require_text "$supervision" '[Safe native-session creation](#safe-native-session-creation)'
for role in planner supervisor executor reviewer specialist-reviewer recovery follow-up; do
  require_text "$roles/$role.md" 'role packet'
  require_text "$roles/$role.md" 'Octopad context'
done

require_text "$contract" '"schema": "octoplan-delivery-mandate-v2"'
require_text "$contract" '"activation_kind": "confirmed-brief|explicit-no-loop"'
require_text "$contract" '**Review before delivery** maps to the internal wire value `plan-bound`'
require_text "$contract" '**Autonomous delivery** maps to `outcome-bound`'
require_text "$contract" 'The wire values and `delivery_mandate` field name are internal and never appear in user-visible prose'
require_text "$contract" 'Natural language activates `outcome-bound` only when'
require_text "$planning" 'Default to **Review before delivery**'
require_text "$planning" 'semantically equivalent end-to-end delegation in any language'
require_text "$runtime" 'A single natural-language instruction may grant autonomous delivery without enumerating internal permissions'
require_text "$contract" 'default and autonomous journeys through binding and launch'
require_text "$contract" '"authority_source": {'
require_text "$contract" '"record_id": "<durable source record ID>"'
require_text "$contract" '"message_digest": "<lowercase SHA-256>"'
require_text "$contract" '"protected_actions_authorized": false'
require_text "$contract" 'The only valid mode/activation combinations'
require_text "$contract" 'The four allowed delta classes are exactly'
require_text "$contract" '"activation_review": "<exact object above or null>"'
require_text "$contract" 'valid explicit-no-loop publishes it as a non-blocking checkpoint'
require_text "$contract" 'Once durable Decision IDs make the mandate available'
require_text "$contract" 'No execution actor precedes it'
require_text "$contract" 'feasibility_coverage'
require_text "$contract" 'Coverage and matrix collections are bijective'
require_text "$contract" 'The matrix is empty if and only if every `triggered_invariants` list is empty'
require_text "$contract" 'protected_occurrences'
require_text "$contract" '`false` value cannot satisfy or remove one'
require_text "$contract" 'Every occurrence points to a human task'
require_text "$contract" 'The four allowed delta classes are exactly'
require_text "$contract" 'task_role_target_overrides": [{"task_id":"<non-empty string>"'
require_text "$contract" 'role":"<planner|executor|lead-reviewer|specialist-reviewer|recovery>"'
require_text "$contract" 'octoplan-native-creation-v3'
require_text "$contract" 'native_creation_schema'
require_text "$contract" 'old native creation contract is unsupported'
require_text "$contract" 'role_packet_digest'
require_text "$contract" 'capability_profile'
require_text "$contract" 'capacity_source'
require_text "$contract" 'Default recovery` is the incident route'
require_text "$contract" 'supervisor|planner|executor|lead-reviewer|specialist-reviewer|recovery|follow-up'
require_text "$contract" 'non-empty exact organization'
require_text "$contract" 'non-empty exact workspace'
require_text "$contract" 'non-empty exact work stream ID'
require_text "$contract" 'non-empty exact task ID or null'
require_text "$contract" 'non-empty exact model'
require_text "$contract" 'non-empty exact effort'
require_text "$contract" 'non-empty rationale'
require_text "$contract" 'A planner uses its task-role target override when present'
require_text "$contract" 'role packet is immutable'
require_text "$contract" 'The first prompt line is exactly literal `OCTOPLAN_CREATION`'
require_text "$contract" 'creation_token'
require_text "$contract" 'creator_owner_epoch'
require_text "$contract" '"creator_owner_epoch":"<positive current supervisor epoch at intent>"'
require_text "$contract" 'At durable `intent`, `creator_owner_epoch` equals the then-current supervisor epoch and is immutable'
require_text "$contract" 'Activation and every ledger transition require actor epoch == current supervisor epoch'
require_text "$contract" 'creation_key` excludes token and creator epoch and is the uniqueness key'
require_text "$contract" 'brief_digest` must equal `delivery_mandate.scoping_brief_digest`'
require_text "$contract" 'mandate_digest` must equal the SHA-256 of the complete canonical mandate object'
require_text "$contract" 'evidence_digest` must equal the SHA-256 of the exact review-record text'
require_text "$contract" '"run_states": ["active", "replanning", "waiting-human", "paused", "revoked", "superseded", "failed", "completed"]'
require_text "$contract" '"review_verdicts": ["PASS", "REVISE", "INFEASIBLE", "HUMAN_DECISION"]'
require_text "$contract" '"plan_hash": "PENDING"'
require_text "$contract" 'label value `<project ID> · <local|worktree> · <observed evidence>`'
require_text "$contract" 'label value `projectless · <directory> · <rationale>`'
require_text "$contract" 'split only on the first two literal ` · ` separators'
require_text "$contract" 'Task-role target overrides: none'
require_text "$contract" '"reviewer_default": {"kind": "<project|projectless>"'
require_text "$contract" 'durable `status` directly'
require_text "$contract" 'Retain durable `Decision.status`, `Question.status`, and task `assignment`'
require_text "$contract" 'The `content` value is the exact direct value when exposed.'
require_text "$contract" 'The canonical Question is'
require_text "$contract" 'Every protected human occurrence is exactly'
require_text "$contract" 'The trigger classes are exactly'
require_text "$contract" 'Stable blocker identity uses'
require_text "$contract" 'Record authoritative actuals only'
require_text "$contract" 'Sort object keys by Unicode scalar order'
require_text "$contract" 'Sort streams, decisions, questions, and tasks by immutable ID'
require_text "$contract" 'each `triggered_invariants` list by invariant ID then trigger class'
require_text "$contract" 'Preserve every other sequence order exactly'
require_text "$contract" 'never escape solidus or non-ASCII scalars'
require_text "$contract" 'Owner epoch fencing rejects late writes'
if grep -Fq 'source time' "$contract"; then
  fail 'launch binding has an unbound source-time field'
fi

if grep -E -n 'build_context|start (an|a) Octopad session|generic Octopad (tutorial|action catalogue)|task-creation field|tasks\(action' $active_docs >/dev/null 2>&1; then
  fail 'generic Octopad usage is duplicated in the skill'
fi
for mandate_field in activation_kind scoping_brief_digest frozen_decision_ids allowed_delta_classes protected_actions_authorized; do
  if grep -Fq "$mandate_field" "$skill/SKILL.md" "$planning" "$runtime" "$supervision"; then
    fail "mandate field catalogue leaked outside the contract: $mandate_field"
  fi
done
[ "$(grep -Fc '| Observable detection profile |' "$runtime")" -eq 1 ] || fail 'capacity ladder is duplicated or missing'
[ "$(grep -Ec '^\| .*`gpt-5\.6-' "$runtime")" -eq 9 ] || fail 'capacity ladder does not have nine rungs'
if grep -E '\| `gpt-5\.6-luna · effort (high|xhigh)` \|' "$runtime" >/dev/null 2>&1; then
  fail 'capacity ladder contains a Luna route below max'
fi
require_text "$runtime" 'minimum automatic capacity is exactly `gpt-5.6-luna · effort max`'
require_text "$runtime" 'cheapest normalized candidate at or above the floor'
require_text "$runtime" 'Every delivery task receives an adversarial check'
require_text "$runtime" 'one fresh source-first reviewer'
require_text "$runtime" 'a second orthogonal material failure domain'
require_text "$runtime" 'missing skill or tool alone is not that proof'
require_text "$runtime" 'capacity_source` record is read and its digest is verified'
require_text "$runtime" 'including `multi_agent`'
require_text "$supervision" 'At durable `intent`, `creator_owner_epoch` equals the then-current supervisor epoch and is immutable'
require_text "$supervision" 'Only an actor with `actor epoch == current supervisor epoch` may activate'
require_text "$supervision" 'one fresh planner or recovery actor'
require_text "$supervision" 'delegate has no execution authority'
require_text "$supervision" 'Every child receives an immutable role packet'
require_text "$supervision" 'model, effort, and capability rationale'
require_text "$supervision" 'It contacts the user only after that evidence proves that no compliant path exists'
require_text "$supervision" 'checked routes, failed criteria'
require_text "$supervision" 'common-fence every child and prove quiescence'
require_text "$supervision" 'old run remains quiescent in `replanning`'
require_text "$supervision" 'Only then guardedly supersede the old run and bind/create the new `active` run'
require_text "$supervision" 'adoption/rejection map'
require_text "$supervision" 'old launch binding, PASS records, and consent never transfer'
require_text "$supervision" 'schema-agnostically'
require_text "$supervision" 'Supervisor - <short-plan>'
require_text "$supervision" 'Executor <human-ref> - <short-plan> - <short-task>'
require_text "$supervision" 'Specialist reviewer - <short-plan> - <purpose>'
require_text "$supervision" '64-character maximum'
require_text "$supervision" 'containing exactly `État`, `Fait`, `Bloqué`, `Décision attendue`, `Pour débloquer`, `Prochaine étape`, in that order'
require_text "$supervision" 'Publish only the current guarded event'
require_text "$supervision" "pause requiring the user's attention"
require_text "$supervision" 'actual project identity from native metadata or the registry'
require_text "$supervision" "prompt's project text is never proof"
require_text "$supervision" 'has a null `projectId`'
require_text "$contract" 'actual project identity from native metadata or the registry'
require_text "$contract" 'publish the required pause handoff'
require_text "$planning" 'A material replan invalidates the old launch binding in either mode'
require_text "$planning" 'Reflect or branch'
require_text "$planning" 'may continue under the exact initial grant'
require_text "$planning" 'Once durable Decision IDs make the complete canonical mandate available'
require_text "$planning" 'before Plan PASS, fingerprinting, consent, or launch'
require_text "$planning" 'empty `triggered_invariants`'
require_text "$planning" 'verification needed by a fresh executor'
require_text "$runtime" 'does not invalidate a byte-identical outcome-bound mandate'
require_text "$skill/SKILL.md" "planning session's saved Codex project"
require_text "$planning" 'Reconfirm the relocated planning target and capability topology'
require_text "$contract" 'Every other target must share that Codex project identity'
require_text "$runtime" "same Codex project identity as the planning target"
require_text "$supervision" "same Codex project identity as the planning target"
require_text "$skill/SKILL.md" 'Use a two-stage runway:'
require_text "$planning" '`greenfield` means no candidate, manifest, ledger, or native-creation marker exists'
require_text "$planning" 'as exactly `greenfield`, `candidate`, `supported`, or `unsupported`'
require_text "$planning" 'one guarded `octoplan-candidate-v1`'
require_text "$planning" 'Ask every currently material question in one numbered batch'
require_text "$planning" 'answers every numbered question and accepts the Delivery mode confirms unchanged brief fields'
require_text "$planning" 'The substrate gate comes first'
require_text "$planning" 'the persistence gate validates every live write shape'
require_text "$planning" 'fresh read-only Codex subagent'
require_text "$planning" 'A reviewer verdict alone is never Plan PASS'
require_text "$planning" 'excluding only its future attestation envelope'
require_text "$planning" 'guardedly replace the root with the complete final pair'
require_text "$contract" 'exactly one transient `octoplan-candidate-v1` root may exist'
require_text "$contract" 'The guarded root is the durable journal carrier'
require_text "$contract" '`reviewed_draft_digest` is the lowercase SHA-256 of a separate canonical review subject'
require_text "$contract" 'classify as `supported`'
require_text "$runtime" 'later exact-hash yes grants one launch of the current plan-bound hash'
require_text "$runtime" 'Interpret creation and relocation authority separately'
require_text "$runtime" 'The planner or supervisor alone persists accepted PASS'
require_text "$runtime" 'loads `plan-reviewer`'
require_text "$supervision" 'append a pending outbox event'
require_text "$supervision" 'reviewed serial fallback'
require_text "$supervision" 'source-stamped native evidence proves it terminal or unreachable'
require_text "$supervision" 'Absence of observation is never terminal or unreachable proof'
require_text "$supervision" 'zero partial creation plus an immutable PASS'
require_text "$roles/plan-reviewer.md" 'needs no run, work stream, task, or supervisor identity'
require_text "$roles/plan-reviewer.md" 'Do not enter Octopad, persist, claim, launch, complete, relay, or create a gate'
require_text "$planning" 'If the current task already has the exact intended project identity, continue.'
require_text "$planning" 'create exactly one pre-planning task there'
require_text "$planning" 'The original task performs no Octoplan write and does not remain supervisor.'
require_text "$planning" 'Unsupported history is never mutated'
require_text "$contract" 'A pre-planning relocation may select a saved project only before any Octopad planning write'
require_text "$runtime" 'relocate the untouched brief before any Octopad planning write'

# The shared README may carry the current Codex distribution version. Claude
# surfaces and the Claude changelog section remain protected.
grep -Fq '| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | 10.2.0 |' "$root/README.md" || fail 'README Codex version is stale'
for protected in .claude-plugin plugins/octoplan-claude docs/clients/claude.md docs/clients/claude-code.md; do
  if ! git -C "$root" diff --quiet origin/main -- "$protected"; then
    fail "protected Claude surface changed: $protected"
  fi
done
if ! git -C "$root" diff --quiet origin/main -- CONTRIBUTING.md; then
  require_text "$root/CONTRIBUTING.md" 'active repository `AGENTS.md`'
  require_text "$root/CONTRIBUTING.md" 'GitHub app/plugin'
  require_text "$root/CONTRIBUTING.md" "Alex's explicit go"
fi
origin_claude=$(git -C "$root" show origin/main:CHANGELOG.md | sed -n '/^## octoplan-claude$/,$p')
current_claude=$(sed -n '/^## octoplan-claude$/,$p' "$changelog")
[ "$origin_claude" = "$current_claude" ] || fail 'Claude changelog section changed'
codex_changelog=$(sed -n '/^## octoplan-codex$/,/^## octoplan-claude$/p' "$changelog")
[ -n "$codex_changelog" ] || fail 'Codex changelog section is missing'

# Deterministic contract fixtures use Node standard library only.
node <<'NODE'
const assert = require('assert');
const crypto = require('crypto');

const SUPERVISION = 'octoplan-supervision-v6';
const FINGERPRINT = 'octoplan-fingerprint-v3';
const MANDATE_SCHEMA = 'octoplan-delivery-mandate-v2';
const MODES = new Set(['plan-bound', 'outcome-bound']);
const ACTIVATIONS = new Set(['confirmed-brief', 'explicit-no-loop']);
const DELTAS = new Set(['artifact-lineage', 'implementation-approach', 'route', 'task-graph']);
const mandateKeys = ['activation_kind', 'allowed_delta_classes', 'authority_source', 'frozen_decision_ids', 'mode', 'policy_sources', 'protected_actions_authorized', 'schema', 'scoping_brief_digest'];
const occurrenceKeys = ['task_id', 'action_kind', 'target', 'parameters', 'environment', 'amount_currency', 'audience', 'occurrence_key', 'owner_approval_rule', 'evidence', 'wake_predicate'];
const actionKinds = new Set(['merge', 'migration-application', 'deployment', 'publication', 'access-grant', 'external-spend', 'destructive-effect', 'acceptance']);
const creationSubjectKinds = new Set(['supervisor', 'task', 'follow-up']);
const creationRoles = new Set(['supervisor', 'planner', 'executor', 'lead-reviewer', 'specialist-reviewer', 'recovery', 'follow-up']);
const overrideRoles = new Set(['planner', 'executor', 'lead-reviewer', 'specialist-reviewer', 'recovery']);
const triggerClasses = [
  'atomicity-concurrency', 'authorization-access', 'paid-resource', 'destructive-irreversible',
  'external-side-effect', 'cross-system-consistency', 'migration-schema', 'security-privacy',
  'production-publication'
];

function scalarCompare(a, b) {
  const left = Array.from(a);
  const right = Array.from(b);
  for (let i = 0; i < Math.min(left.length, right.length); i += 1) {
    const delta = left[i].codePointAt(0) - right[i].codePointAt(0);
    if (delta) return delta;
  }
  return left.length - right.length;
}

function escapeString(value) {
  let output = '';
  for (let i = 0; i < value.length; i += 1) {
    const unit = value.charCodeAt(i);
    let codePoint = unit;
    if (unit >= 0xD800 && unit <= 0xDBFF) {
      const next = value.charCodeAt(i + 1);
      assert(next >= 0xDC00 && next <= 0xDFFF);
      codePoint = ((unit - 0xD800) << 10) + next - 0xDC00 + 0x10000;
      i += 1;
    } else {
      assert(!(unit >= 0xDC00 && unit <= 0xDFFF));
    }
    if (codePoint === 0x22) output += '\\"';
    else if (codePoint === 0x5C) output += '\\\\';
    else if (codePoint <= 0x1F) output += `\\u${codePoint.toString(16).padStart(4, '0')}`;
    else output += String.fromCodePoint(codePoint);
  }
  return output;
}

function stable(value) {
  if (typeof value === 'string') return `"${escapeString(value)}"`;
  if (value === null) return 'null';
  if (Array.isArray(value)) return `[${value.map(stable).join(',')}]`;
  if (typeof value === 'boolean') return value ? 'true' : 'false';
  if (typeof value === 'number') {
    assert(Number.isFinite(value));
    return String(value);
  }
  assert(value && typeof value === 'object');
  return `{${Object.keys(value).sort(scalarCompare).map((key) => `${stable(key)}:${stable(value[key])}`).join(',')}}`;
}

function digest(value) {
  return crypto.createHash('sha256').update(stable(value), 'utf8').digest('hex');
}

function nonEmpty(value) {
  assert.strictEqual(typeof value, 'string');
  assert(value.trim().length > 0);
  return value;
}

function revisionCompare(a, b) {
  if (a === null && b !== null) return -1;
  if (a !== null && b === null) return 1;
  return scalarCompare(a || '', b || '');
}

function validMandate(mode = 'plan-bound', activation_kind = 'confirmed-brief') {
  return {
    schema: MANDATE_SCHEMA,
    mode,
    activation_kind,
    scoping_brief_digest: 'a'.repeat(64),
    frozen_decision_ids: ['decision-a'],
    allowed_delta_classes: mode === 'plan-bound' ? [] : ['route'],
    authority_source: {record_id: 'source-a', message_digest: 'b'.repeat(64)},
    policy_sources: [{kind: 'repository', locator: 'repo', revision: null}],
    protected_actions_authorized: false
  };
}

function validateMandate(value) {
  assert(value && typeof value === 'object' && !Array.isArray(value));
  assert.deepStrictEqual(Object.keys(value).sort(scalarCompare), mandateKeys.slice().sort(scalarCompare));
  assert.strictEqual(value.schema, MANDATE_SCHEMA);
  assert(MODES.has(value.mode) && ACTIVATIONS.has(value.activation_kind));
  assert(new Set(['plan-bound:confirmed-brief', 'outcome-bound:confirmed-brief', 'outcome-bound:explicit-no-loop']).has(`${value.mode}:${value.activation_kind}`));
  assert(/^[a-f0-9]{64}$/.test(value.scoping_brief_digest));
  assert(value.authority_source && typeof value.authority_source === 'object' && !Array.isArray(value.authority_source));
  assert(/^[a-f0-9]{64}$/.test(value.authority_source.message_digest));
  nonEmpty(value.authority_source.record_id);
  assert.deepStrictEqual(Object.keys(value.authority_source).sort(scalarCompare), ['message_digest', 'record_id']);
  assert(Array.isArray(value.frozen_decision_ids) && value.frozen_decision_ids.every(nonEmpty));
  assert(Array.isArray(value.allowed_delta_classes));
  assert(Array.isArray(value.policy_sources));
  assert(value.policy_sources.length > 0);
  for (const source of value.policy_sources) {
    assert.deepStrictEqual(Object.keys(source).sort(scalarCompare), ['kind', 'locator', 'revision']);
    assert(new Set(['host', 'organization', 'repository', 'service']).has(source.kind));
    nonEmpty(source.locator);
    assert(source.revision === null || (typeof source.revision === 'string' && source.revision.length > 0));
  }
  assert.strictEqual(new Set(value.policy_sources.map((source) => stable(source))).size, value.policy_sources.length);
  assert.strictEqual(value.protected_actions_authorized, false);
  for (const list of [value.frozen_decision_ids, value.allowed_delta_classes]) {
    assert.deepStrictEqual(list, [...new Set(list)].sort(scalarCompare));
  }
  assert(value.allowed_delta_classes.every((item) => DELTAS.has(item)));
  const orderedSources = value.policy_sources.slice().sort((a, b) => scalarCompare(a.kind, b.kind) || scalarCompare(a.locator, b.locator) || revisionCompare(a.revision, b.revision));
  assert.deepStrictEqual(value.policy_sources, orderedSources);
  if (value.mode === 'plan-bound') assert.deepStrictEqual(value.allowed_delta_classes, []);
  return true;
}

const baseMandate = validMandate();
assert.strictEqual(validateMandate(baseMandate), true);
for (const key of mandateKeys) {
  const mutation = JSON.parse(JSON.stringify(baseMandate));
  if (key === 'schema') mutation[key] = 'other';
  else if (key === 'mode') mutation[key] = 'other';
  else if (key === 'activation_kind') mutation[key] = 'explicit-no-loop';
  else if (key === 'scoping_brief_digest') mutation[key] = 'not-a-digest';
  else if (key === 'frozen_decision_ids') mutation[key] = ['decision-b', 'decision-a'];
  else if (key === 'allowed_delta_classes') mutation[key] = ['route', 'route'];
  else if (key === 'authority_source') mutation[key] = {record_id: ''};
  else if (key === 'policy_sources') mutation[key] = [{kind: 'repository', locator: '', revision: null}];
  else mutation[key] = true;
  assert.throws(() => validateMandate(mutation));
}
assert.throws(() => validateMandate({...baseMandate, extra: true}));
assert.throws(() => validateMandate({...baseMandate, protected_actions_authorized: true}));
assert.throws(() => validateMandate({...baseMandate, policy_sources: [{kind: 'repository', locator: 'repo', revision: null}, {kind: 'repository', locator: 'repo', revision: null}]}));
assert.throws(() => validateMandate({...baseMandate, policy_sources: [{kind: 'repository', locator: 'repo', revision: 'rev-a'}, {kind: 'repository', locator: 'repo', revision: null}]}));
assert.throws(() => validateMandate(validMandate('unknown', 'confirmed-brief')));
assert.throws(() => validateMandate(validMandate('outcome-bound', 'unknown')));
assert.throws(() => validateMandate(validMandate('plan-bound', 'explicit-no-loop')));
assert.strictEqual(validateMandate(validMandate('outcome-bound', 'explicit-no-loop')), true);

function dispatch(contract, fingerprint, mandate) {
  if (contract !== SUPERVISION || fingerprint !== FINGERPRINT) throw new Error('unsupported pair');
  validateMandate(mandate);
  return true;
}
assert(dispatch(SUPERVISION, FINGERPRINT, baseMandate));
assert.throws(() => dispatch('other-contract', FINGERPRINT, baseMandate));
assert.throws(() => dispatch(SUPERVISION, 'other-fingerprint', baseMandate));
assert.throws(() => dispatch(SUPERVISION, FINGERPRINT, {...baseMandate, protected_actions_authorized: true}));

function textDigest(value) {
  const normalized = value.replace(/\r\n?/g, '\n');
  escapeString(normalized); // validates Unicode scalar boundaries without changing the source bytes
  return crypto.createHash('sha256').update(normalized, 'utf8').digest('hex');
}

function validateActivationReview(review, mandate, reviewRecord) {
  assert.deepStrictEqual(Object.keys(review).sort(scalarCompare), ['brief_digest', 'evidence_digest', 'mandate_digest', 'record_id', 'verdict']);
  nonEmpty(review.record_id);
  assert(/^[a-f0-9]{64}$/.test(review.brief_digest));
  assert(/^[a-f0-9]{64}$/.test(review.mandate_digest));
  assert(/^[a-f0-9]{64}$/.test(review.evidence_digest));
  assert.strictEqual(review.verdict, 'PASS');
  assert.strictEqual(review.brief_digest, mandate.scoping_brief_digest);
  assert.strictEqual(review.mandate_digest, digest(mandate));
  assert.strictEqual(review.evidence_digest, textDigest(reviewRecord));
  return true;
}

const reviewRecord = 'Review record: review-a\r\nEvidence: exact bytes  \n';
const activationReview = {record_id: 'review-a', brief_digest: baseMandate.scoping_brief_digest, mandate_digest: digest(baseMandate), evidence_digest: textDigest(reviewRecord), verdict: 'PASS'};
assert.strictEqual(validateActivationReview(activationReview, baseMandate, reviewRecord), true);
assert.strictEqual(validMandate().activation_kind, 'confirmed-brief');
assert.strictEqual(validMandate('outcome-bound', 'confirmed-brief').activation_kind, 'confirmed-brief');
assert.strictEqual(validMandate('outcome-bound', 'explicit-no-loop').activation_kind, 'explicit-no-loop');
assert.strictEqual(null, null); // confirmed-brief stores activation_review as JSON null
assert.throws(() => validateActivationReview({...activationReview, brief_digest: 'c'.repeat(64)}, baseMandate, reviewRecord));
assert.throws(() => validateActivationReview({...activationReview, evidence_digest: 'c'.repeat(64)}, baseMandate, reviewRecord));
const noLoopMandate = validMandate('outcome-bound', 'explicit-no-loop');
const noLoopReview = {...activationReview, brief_digest: noLoopMandate.scoping_brief_digest, mandate_digest: digest(noLoopMandate)};
assert.strictEqual(validateActivationReview(noLoopReview, noLoopMandate, reviewRecord), true);
function validateStoredActivation(mandate, review) {
  if (mandate.activation_kind === 'confirmed-brief') assert.strictEqual(review, null);
  else validateActivationReview(review, mandate, reviewRecord);
  return true;
}
assert(validateStoredActivation(baseMandate, null));
assert(validateStoredActivation(noLoopMandate, noLoopReview));
assert.throws(() => validateStoredActivation(noLoopMandate, null));
assert.throws(() => validateStoredActivation(baseMandate, activationReview));
const launchReference = {activation_review_record_id: noLoopReview.record_id, activation_review_evidence_digest: noLoopReview.evidence_digest};
assert.strictEqual(launchReference.activation_review_record_id, 'review-a');
assert.strictEqual(launchReference.activation_review_evidence_digest, noLoopReview.evidence_digest);

const completeNoLoopGrant = {planning: true, launch: true, material_replan: true, complete_envelope: true, native_task_creation: true};
const naturalLanguageActivationCases = [
  {source: 'Create the Codex tasks needed, find the plan, deliver, and adapt it inside this scope.', language: 'en', grant: completeNoLoopGrant, bounded_outcome: true, expected: 'ACTIVATE'},
  {source: 'Crée les tâches Codex nécessaires, fais le plan, livre et adapte-le dans ce périmètre.', language: 'fr', grant: completeNoLoopGrant, bounded_outcome: true, expected: 'ACTIVATE'},
  {source: 'Find the plan, deliver, and adapt it inside this scope.', language: 'en', grant: {...completeNoLoopGrant, native_task_creation: false}, bounded_outcome: true, expected: 'WAIT_NATIVE_TASK_AUTHORITY'},
  {source: 'Do it.', language: 'en', grant: null, bounded_outcome: false, expected: 'WAIT_BRIEF'},
  {source: 'This is urgent; I trust you.', language: 'en', grant: null, bounded_outcome: false, expected: 'WAIT_BRIEF'}
];
function validateNaturalLanguageActivationCase(value) {
  assert(nonEmpty(value.source) && nonEmpty(value.language));
  if (!value.grant || !value.bounded_outcome) return 'WAIT_BRIEF';
  const deliveryGrant = ['planning', 'launch', 'material_replan', 'complete_envelope'].every((key) => value.grant[key] === true);
  if (!deliveryGrant) return 'WAIT_BRIEF';
  return value.grant.native_task_creation === true ? 'ACTIVATE' : 'WAIT_NATIVE_TASK_AUTHORITY';
}
assert.deepStrictEqual(naturalLanguageActivationCases.map(validateNaturalLanguageActivationCase), naturalLanguageActivationCases.map((value) => value.expected));

const candidateKeys = ['authority_message_digest', 'brief_digest', 'candidate_id', 'journal_cursor', 'phase', 'schema', 'stream_action', 'target', 'write_set_digest'];
function validCandidate(overrides = {}) {
  return {
    schema: 'octoplan-candidate-v1', candidate_id: 'candidate-a', brief_digest: 'a'.repeat(64), authority_message_digest: 'b'.repeat(64),
    target: {kind: 'project', project_id: 'project-a', environment: 'local', directory_name: null, rationale: null},
    stream_action: 'create', write_set_digest: 'c'.repeat(64), journal_cursor: 0, phase: 'assembling', ...overrides
  };
}
function validateCandidate(candidate) {
  assert.deepStrictEqual(Object.keys(candidate).sort(scalarCompare), candidateKeys.slice().sort(scalarCompare));
  assert.strictEqual(candidate.schema, 'octoplan-candidate-v1');
  assert(nonEmpty(candidate.candidate_id) && /^[a-f0-9]{64}$/.test(candidate.brief_digest) && /^[a-f0-9]{64}$/.test(candidate.authority_message_digest));
  assert(/^[a-f0-9]{64}$/.test(candidate.write_set_digest) && Number.isInteger(candidate.journal_cursor) && candidate.journal_cursor >= 0);
  assert(['reuse', 'create'].includes(candidate.stream_action) && ['assembling', 'ready-to-seal', 'abandoned'].includes(candidate.phase));
  return true;
}
function validateCandidateRecords(candidate, records) {
  assert(Array.isArray(records));
  const seen = new Set();
  for (const record of records) {
    assert.deepStrictEqual(Object.keys(record).sort(scalarCompare), ['candidate_id', 'index', 'operation_key', 'payload_digest']);
    assert.strictEqual(record.candidate_id, candidate.candidate_id);
    assert(Number.isInteger(record.index) && record.index >= 0 && record.index <= candidate.journal_cursor);
    assert.strictEqual(record.operation_key, `${candidate.candidate_id}:${record.index}`);
    assert(/^[a-f0-9]{64}$/.test(record.payload_digest));
    assert(!seen.has(record.index));
    seen.add(record.index);
  }
  for (let index = 0; index < candidate.journal_cursor; index += 1) assert(seen.has(index));
  return true;
}
function classifyEntry(markers) {
  const keys = ['candidateRecords', 'candidates', 'fingerprints', 'mandates', 'nativeSchemas', 'otherMarkers', 'supervisions'];
  assert.deepStrictEqual(Object.keys(markers).sort(scalarCompare), keys.slice().sort(scalarCompare));
  const markerKeys = keys.filter((key) => key !== 'candidateRecords');
  const count = markerKeys.reduce((total, key) => total + markers[key].length, 0);
  if (count === 0 && markers.candidateRecords.length === 0) return 'GREENFIELD';
  if (markers.candidates.length === 1 && count === 1) {
    validateCandidate(markers.candidates[0]);
    validateCandidateRecords(markers.candidates[0], markers.candidateRecords);
    return 'CANDIDATE';
  }
  if (markers.candidates.length === 0 && markers.otherMarkers.length === 0 && markers.supervisions.length === 1 && markers.supervisions[0] === SUPERVISION && markers.fingerprints.length === 1 && markers.fingerprints[0] === FINGERPRINT && markers.mandates.length === 1 && markers.nativeSchemas.length === 1 && markers.nativeSchemas[0] === 'octoplan-native-creation-v3') return 'SUPPORTED';
  return 'UNSUPPORTED';
}
const emptyEntry = {candidateRecords: [], candidates: [], fingerprints: [], mandates: [], nativeSchemas: [], otherMarkers: [], supervisions: []};
assert.strictEqual(classifyEntry(emptyEntry), 'GREENFIELD');
assert.strictEqual(classifyEntry({...emptyEntry, candidates: [validCandidate()]}), 'CANDIDATE');
function validateSupportedPair(entry) {
  assert.strictEqual(classifyEntry(entry), 'SUPPORTED');
  assert.strictEqual(entry.supervisions[0], SUPERVISION);
  assert.strictEqual(entry.fingerprints[0], FINGERPRINT);
  assert.strictEqual(entry.nativeSchemas[0], 'octoplan-native-creation-v3');
  assert(validateMandate(entry.mandates[0]));
  return true;
}
const saved101Pair = {...emptyEntry, supervisions: [SUPERVISION], fingerprints: [FINGERPRINT], mandates: [baseMandate], nativeSchemas: ['octoplan-native-creation-v3']};
assert(validateSupportedPair(saved101Pair)); // a complete valid 10.1.0 final pair needs no migration
assert.strictEqual(classifyEntry({...emptyEntry, supervisions: [SUPERVISION]}), 'UNSUPPORTED');
assert.strictEqual(classifyEntry({...emptyEntry, candidates: [validCandidate()], otherMarkers: ['partial-task']}), 'UNSUPPORTED');
assert.strictEqual(classifyEntry({...emptyEntry, candidateRecords: [{candidate_id: 'orphan', index: 0, operation_key: 'orphan:0', payload_digest: 'a'.repeat(64)}]}), 'UNSUPPORTED');

function candidateJournal(writeSet) {
  assert(Array.isArray(writeSet) && writeSet.length > 0);
  let root = validCandidate({write_set_digest: digest(writeSet)});
  const records = new Map();
  const observed = () => [...records.entries()].map(([index, payload]) => ({candidate_id: root.candidate_id, index, operation_key: `${root.candidate_id}:${index}`, payload_digest: digest(payload)}));
  const writeCurrent = () => {
    const index = root.journal_cursor;
    assert(index < writeSet.length);
    const existing = records.get(index);
    if (existing !== undefined) assert.strictEqual(stable(existing), stable(writeSet[index]));
    else records.set(index, writeSet[index]);
  };
  const advance = () => {
    const index = root.journal_cursor;
    assert.strictEqual(stable(records.get(index)), stable(writeSet[index]));
    root = {...root, journal_cursor: index + 1};
    validateCandidateRecords(root, observed());
  };
  const resume = (rebuiltWriteSet) => {
    assert.strictEqual(digest(rebuiltWriteSet), root.write_set_digest);
    assert.strictEqual(classifyEntry({...emptyEntry, candidates: [root], candidateRecords: observed()}), 'CANDIDATE');
  };
  return {advance, records: observed, resume, root: () => root, writeCurrent};
}
const journalFixture = candidateJournal([{kind: 'stream'}, {kind: 'decision'}, {kind: 'task'}]);
journalFixture.writeCurrent(); // crash after durable operation, before cursor advance
journalFixture.resume([{kind: 'stream'}, {kind: 'decision'}, {kind: 'task'}]);
journalFixture.writeCurrent(); // idempotent reconciliation, no duplicate
assert.strictEqual(journalFixture.records().length, 1);
journalFixture.advance();
journalFixture.resume([{kind: 'stream'}, {kind: 'decision'}, {kind: 'task'}]);
assert.throws(() => journalFixture.resume([{kind: 'different'}]));

function noLoopPhaseFixture({explicitNoLoop, grant}) {
  const validNoLoop = explicitNoLoop === true && grant && stable(grant) === stable(completeNoLoopGrant);
  let phase = 'start';
  let planningPersisted = false;
  let decisionsDurable = false;
  let mandateComplete = false;
  let assembledMandate = null;
  let activationReviewed = false;
  let independentReview = false;
  let savedEquality = false;
  const checkpoint = () => { assert.strictEqual(phase, 'start'); phase = 'checkpoint'; };
  const continueAfterCheckpoint = () => { assert.strictEqual(phase, 'checkpoint'); phase = validNoLoop ? 'planning' : 'waiting'; };
  const confirm = () => { assert.strictEqual(phase, 'waiting'); phase = 'planning'; };
  const persistPlanning = () => { assert.strictEqual(phase, 'planning'); planningPersisted = true; };
  const persistDecisions = () => { assert.strictEqual(phase, 'planning'); assert(planningPersisted); decisionsDurable = true; };
  const assembleMandate = (mandate) => {
    assert.strictEqual(phase, 'planning');
    assert(validNoLoop && decisionsDurable);
    validateMandate(mandate);
    assert.strictEqual(mandate.mode, 'outcome-bound');
    assert.strictEqual(mandate.activation_kind, 'explicit-no-loop');
    assembledMandate = mandate;
    mandateComplete = true;
  };
  const activationReview = (review, record) => {
    assert.strictEqual(phase, 'planning');
    assert(validNoLoop && decisionsDurable && mandateComplete);
    validateActivationReview(review, assembledMandate, record);
    activationReviewed = true;
    phase = 'activation-reviewed';
  };
  const planReview = () => { assert(planningPersisted); independentReview = true; };
  const readback = (equal) => { assert(planningPersisted); assert.strictEqual(equal, true); savedEquality = true; };
  const planPass = () => {
    assert(planningPersisted && independentReview && savedEquality);
    if (explicitNoLoop) {
      assert.strictEqual(phase, 'activation-reviewed');
      assert(decisionsDurable && mandateComplete && activationReviewed);
    } else assert.strictEqual(phase, 'planning');
    phase = 'plan-passed';
  };
  const fingerprint = () => { assert.strictEqual(phase, 'plan-passed'); phase = 'fingerprinted'; };
  const consent = () => { assert.strictEqual(phase, 'fingerprinted'); phase = 'consented'; };
  const launch = () => { assert.strictEqual(phase, 'consented'); phase = 'launched'; };
  return {phase: () => phase, checkpoint, continueAfterCheckpoint, confirm, persistPlanning, persistDecisions, assembleMandate, activationReview, planReview, readback, planPass, fingerprint, consent, launch};
}
const defaultPhase = noLoopPhaseFixture({explicitNoLoop: false, grant: null});
defaultPhase.checkpoint();
for (const action of [defaultPhase.persistPlanning, defaultPhase.planPass, defaultPhase.fingerprint, defaultPhase.consent, defaultPhase.launch]) assert.throws(action);
defaultPhase.continueAfterCheckpoint();
assert.strictEqual(defaultPhase.phase(), 'waiting');
for (const action of [defaultPhase.persistPlanning, defaultPhase.planPass, defaultPhase.fingerprint, defaultPhase.consent, defaultPhase.launch]) assert.throws(action);
defaultPhase.confirm();
assert.strictEqual(defaultPhase.phase(), 'planning');
defaultPhase.persistPlanning();
assert.throws(defaultPhase.planPass);
defaultPhase.planReview();
defaultPhase.readback(true);
defaultPhase.planPass();
assert.strictEqual(defaultPhase.phase(), 'plan-passed');
const explicitPhase = noLoopPhaseFixture({explicitNoLoop: true, grant: completeNoLoopGrant});
explicitPhase.checkpoint();
explicitPhase.continueAfterCheckpoint();
assert.strictEqual(explicitPhase.phase(), 'planning');
explicitPhase.persistPlanning();
const rejectBeforeActivation = () => {
  for (const action of [explicitPhase.planPass, explicitPhase.fingerprint, explicitPhase.consent, explicitPhase.launch]) assert.throws(action);
};
rejectBeforeActivation();
explicitPhase.persistDecisions();
rejectBeforeActivation();
explicitPhase.assembleMandate(noLoopMandate);
rejectBeforeActivation();
assert.throws(() => explicitPhase.activationReview({...noLoopReview, brief_digest: 'c'.repeat(64)}, reviewRecord));
assert.throws(() => explicitPhase.activationReview({...noLoopReview, mandate_digest: 'c'.repeat(64)}, reviewRecord));
assert.throws(() => explicitPhase.activationReview({...noLoopReview, evidence_digest: 'c'.repeat(64)}, reviewRecord));
explicitPhase.activationReview(noLoopReview, reviewRecord);
assert.strictEqual(explicitPhase.phase(), 'activation-reviewed');
assert.throws(() => explicitPhase.fingerprint());
assert.throws(() => explicitPhase.consent());
assert.throws(() => explicitPhase.launch());
explicitPhase.planReview();
assert.throws(() => explicitPhase.readback(false));
explicitPhase.readback(true);
explicitPhase.planPass();
assert.strictEqual(explicitPhase.phase(), 'plan-passed');
assert.throws(() => explicitPhase.consent());
assert.throws(() => explicitPhase.launch());
explicitPhase.fingerprint();
assert.strictEqual(explicitPhase.phase(), 'fingerprinted');
assert.throws(() => explicitPhase.launch());
explicitPhase.consent();
explicitPhase.launch();
assert.strictEqual(explicitPhase.phase(), 'launched');
const differentNoLoopMandate = {...noLoopMandate, allowed_delta_classes: ['artifact-lineage', 'route']};
validateMandate(differentNoLoopMandate);
const differentNoLoopReview = {...noLoopReview, brief_digest: differentNoLoopMandate.scoping_brief_digest, mandate_digest: digest(differentNoLoopMandate), evidence_digest: textDigest(reviewRecord)};
const differentPhase = noLoopPhaseFixture({explicitNoLoop: true, grant: completeNoLoopGrant});
differentPhase.checkpoint();
differentPhase.continueAfterCheckpoint();
differentPhase.persistPlanning();
differentPhase.persistDecisions();
differentPhase.assembleMandate(differentNoLoopMandate);
assert.throws(() => differentPhase.activationReview(noLoopReview, reviewRecord));
differentPhase.activationReview(differentNoLoopReview, reviewRecord);
assert.strictEqual(differentPhase.phase(), 'activation-reviewed');
const incompleteNoLoop = noLoopPhaseFixture({explicitNoLoop: true, grant: {planning: true, launch: true, material_replan: false, complete_envelope: true, native_task_creation: true}});
incompleteNoLoop.checkpoint();
incompleteNoLoop.continueAfterCheckpoint();
assert.strictEqual(incompleteNoLoop.phase(), 'waiting');
assert.throws(() => incompleteNoLoop.persistPlanning());

function runwayAuthority(recordId = 'authority-a', fill = 'a') {
  return {record_id: recordId, message_digest: fill.repeat(64)};
}
function validRunwayAuthority(source) {
  if (source === null) return false;
  assert(source && typeof source === 'object' && !Array.isArray(source));
  assert.deepStrictEqual(Object.keys(source).sort(scalarCompare), ['message_digest', 'record_id']);
  nonEmpty(source.record_id);
  assert(/^[a-f0-9]{64}$/.test(source.message_digest));
  return true;
}
function executionRunway({currentProjectId, intendedProjectIds, deliveryMode, briefConfirmed, checkpointPublished, nativeTaskCreationRequired, nativeTaskCreationAuthoritySource, relocationAuthoritySource, capabilities}) {
  assert(Array.isArray(intendedProjectIds));
  assert(['Review before delivery', 'Autonomous delivery'].includes(deliveryMode));
  if (deliveryMode === 'Review before delivery' && !briefConfirmed) return {state: 'WAIT_BRIEF', durablePlanningWrite: false};
  if (deliveryMode === 'Autonomous delivery' && !checkpointPublished) return {state: 'PUBLISH_CHECKPOINT', durablePlanningWrite: false};
  assert.strictEqual(typeof nativeTaskCreationRequired, 'boolean');
  if (nativeTaskCreationRequired && !validRunwayAuthority(nativeTaskCreationAuthoritySource)) return {state: 'WAIT_NATIVE_TASK_AUTHORITY', durablePlanningWrite: false};
  if (intendedProjectIds.length !== 1) return {state: 'QUESTION', durablePlanningWrite: false};
  const intendedProjectId = intendedProjectIds[0];
  nonEmpty(intendedProjectId);
  assert(capabilities && typeof capabilities === 'object');
  const requiredCapabilities = ['nativeCreate', 'nativeReconcile', 'octopadSession', 'planningWrite', 'planReviewSubagent'];
  if (!requiredCapabilities.every((capability) => capabilities[capability] === true)) return {state: 'PREWRITE_BLOCK', durablePlanningWrite: false};
  if (currentProjectId === intendedProjectId) return {state: 'READY_TO_DRAFT', durablePlanningWrite: false};
  if (!validRunwayAuthority(relocationAuthoritySource)) return {state: 'WAIT_RELOCATION_AUTHORITY', durablePlanningWrite: false};
  return {state: 'RELOCATE', durablePlanningWrite: false, targetProjectId: intendedProjectId};
}
function persistenceGate(evidence) {
  const required = ['adaptersAvailable', 'deterministicCreates', 'draftComplete', 'matrixPass', 'prerequisitesReady', 'sourcesCurrent', 'verifiersAvailable', 'writeShapesValid'];
  assert.deepStrictEqual(Object.keys(evidence).sort(scalarCompare), required.slice().sort(scalarCompare));
  if (!required.every((key) => evidence[key] === true)) return {state: 'PREWRITE_BLOCK', durablePlanningWrite: false};
  return {state: 'READY_TO_PERSIST', durablePlanningWrite: true};
}
const fullRunwayCapabilities = {nativeCreate: true, nativeReconcile: true, octopadSession: true, planningWrite: true, planReviewSubagent: true};
const fullPersistenceEvidence = {adaptersAvailable: true, deterministicCreates: true, draftComplete: true, matrixPass: true, prerequisitesReady: true, sourcesCurrent: true, verifiersAvailable: true, writeShapesValid: true};
const nativeTaskAuthority = runwayAuthority('native-task-authority', 'a');
const relocationAuthority = runwayAuthority('relocation-authority', 'b');
const nullProjectRunway = executionRunway({currentProjectId: null, intendedProjectIds: ['project-a'], deliveryMode: 'Autonomous delivery', briefConfirmed: false, checkpointPublished: true, nativeTaskCreationRequired: true, nativeTaskCreationAuthoritySource: nativeTaskAuthority, relocationAuthoritySource: relocationAuthority, capabilities: fullRunwayCapabilities});
assert.deepStrictEqual(nullProjectRunway, {state: 'RELOCATE', durablePlanningWrite: false, targetProjectId: 'project-a'});
const runwayInput = {currentProjectId: null, intendedProjectIds: ['project-a'], deliveryMode: 'Autonomous delivery', briefConfirmed: false, checkpointPublished: true, nativeTaskCreationRequired: true, nativeTaskCreationAuthoritySource: nativeTaskAuthority, relocationAuthoritySource: relocationAuthority, capabilities: fullRunwayCapabilities};
assert.strictEqual(executionRunway({...runwayInput, checkpointPublished: false}).state, 'PUBLISH_CHECKPOINT');
assert.strictEqual(executionRunway({...runwayInput, nativeTaskCreationAuthoritySource: null}).state, 'WAIT_NATIVE_TASK_AUTHORITY');
assert.strictEqual(executionRunway({...runwayInput, nativeTaskCreationRequired: false, nativeTaskCreationAuthoritySource: null}).state, 'RELOCATE');
assert.strictEqual(executionRunway({...runwayInput, deliveryMode: 'Review before delivery', briefConfirmed: false}).state, 'WAIT_BRIEF');
assert.strictEqual(executionRunway({...runwayInput, deliveryMode: 'Review before delivery', briefConfirmed: true, relocationAuthoritySource: null}).state, 'WAIT_RELOCATION_AUTHORITY');
assert.strictEqual(executionRunway({...runwayInput, deliveryMode: 'Review before delivery', briefConfirmed: true}).state, 'RELOCATE');
assert.strictEqual(executionRunway({...runwayInput, intendedProjectIds: ['project-a', 'project-b']}).state, 'QUESTION');
assert.strictEqual(executionRunway({...runwayInput, capabilities: {...fullRunwayCapabilities, nativeCreate: false}}).state, 'PREWRITE_BLOCK');
assert.strictEqual(executionRunway({...runwayInput, currentProjectId: 'project-a', relocationAuthoritySource: null, capabilities: {...fullRunwayCapabilities, nativeReconcile: false}}).state, 'PREWRITE_BLOCK');
assert.deepStrictEqual(executionRunway({...runwayInput, currentProjectId: 'project-a', relocationAuthoritySource: null}), {state: 'READY_TO_DRAFT', durablePlanningWrite: false});
assert.strictEqual(nullProjectRunway.durablePlanningWrite, false); // the bootstrap task never writes the plan
assert.deepStrictEqual(persistenceGate(fullPersistenceEvidence), {state: 'READY_TO_PERSIST', durablePlanningWrite: true});
assert.strictEqual(persistenceGate({...fullPersistenceEvidence, verifiersAvailable: false}).durablePlanningWrite, false);
assert.strictEqual(persistenceGate({...fullPersistenceEvidence, writeShapesValid: false}).durablePlanningWrite, false);

function parseTarget(value) {
  const separator = ' · ';
  const first = value.indexOf(separator);
  const second = first < 0 ? -1 : value.indexOf(separator, first + separator.length);
  assert(first > 0 && second > first + separator.length && second + separator.length < value.length);
  const firstField = value.slice(0, first);
  const secondField = value.slice(first + separator.length, second);
  const remainder = value.slice(second + separator.length);
  assert(firstField.length > 0 && secondField.length > 0 && remainder.length > 0);
  if (firstField === 'projectless') {
    return {
      target: {kind: 'projectless', project_id: null, environment: null, directory_name: secondField, rationale: remainder},
      excludedEvidence: null
    };
  }
  assert(secondField === 'local' || secondField === 'worktree');
  return {
    target: {kind: 'project', project_id: firstField, environment: secondField, directory_name: null, rationale: null},
    excludedEvidence: remainder
  };
}
assert.deepStrictEqual(parseTarget('project-a · worktree · observed · proof'), {target: {kind: 'project', project_id: 'project-a', environment: 'worktree', directory_name: null, rationale: null}, excludedEvidence: 'observed · proof'});
assert.deepStrictEqual(parseTarget('projectless · content-room · non-code · operations'), {target: {kind: 'projectless', project_id: null, environment: null, directory_name: 'content-room', rationale: 'non-code · operations'}, excludedEvidence: null});
assert.throws(() => parseTarget('projectless ·  · rationale'));
assert.throws(() => parseTarget('project-a · unknown · evidence'));
assert.throws(() => parseTarget('project-a · worktree'));
assert.throws(() => parseTarget('project-a · worktree · '));

const targetKeys = ['kind', 'project_id', 'environment', 'directory_name', 'rationale'];
function validateTarget(target) {
  assert.deepStrictEqual(Object.keys(target).sort(scalarCompare), targetKeys.slice().sort(scalarCompare));
  assert(['project', 'projectless'].includes(target.kind));
  if (target.kind === 'project') {
    nonEmpty(target.project_id);
    assert(['local', 'worktree'].includes(target.environment));
    assert.strictEqual(target.directory_name, null);
    assert.strictEqual(target.rationale, null);
  } else {
    assert.strictEqual(target.project_id, null);
    assert.strictEqual(target.environment, null);
    nonEmpty(target.directory_name);
    nonEmpty(target.rationale);
  }
  return true;
}
function sameProjectIdentity(planningTarget, candidateTarget) {
  validateTarget(planningTarget);
  validateTarget(candidateTarget);
  assert.strictEqual(candidateTarget.kind, planningTarget.kind);
  if (planningTarget.kind === 'project') assert.strictEqual(candidateTarget.project_id, planningTarget.project_id);
  else assert.strictEqual(candidateTarget.directory_name, planningTarget.directory_name);
  return true;
}

const opaqueVisiblePattern = /(?:[0-9a-f]{8,}|[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}|(?:uuid|hash|thread(?:[_ -]?id)?|creation(?:[_ -]?(?:key|token))?)\b(?:\s*[:=#-]?\s*[A-Za-z0-9_-]+)?)/i;
function rejectOpaqueVisible(value, forbiddenIdentifiers = []) {
  assert(!opaqueVisiblePattern.test(value));
  for (const identifier of forbiddenIdentifiers) {
    nonEmpty(identifier);
    assert(!value.includes(identifier));
  }
}
function normalizeHumanLabel(value, forbiddenIdentifiers = []) {
  assert.strictEqual(typeof value, 'string');
  const normalized = value.trim().replace(/\s+/gu, ' ');
  assert(normalized);
  rejectOpaqueVisible(normalized, forbiddenIdentifiers);
  return normalized;
}
function shortenHumanLabel(value, maxChars, forbiddenIdentifiers = []) {
  const normalized = normalizeHumanLabel(value, forbiddenIdentifiers);
  const chars = Array.from(normalized);
  if (chars.length <= maxChars) return normalized;
  const words = normalized.split(' ');
  let prefix = '';
  for (const word of words) {
    const candidate = prefix ? `${prefix} ${word}` : word;
    if (Array.from(`${candidate}…`).length > maxChars) break;
    prefix = candidate;
  }
  assert(prefix && prefix.length < normalized.length);
  return `${prefix}…`;
}
function resolveHumanLabel(source, maxChars, peerSources, forbiddenIdentifiers = []) {
  const label = shortenHumanLabel(source, maxChars, forbiddenIdentifiers);
  const matches = peerSources.map((peer) => shortenHumanLabel(peer, maxChars, forbiddenIdentifiers)).filter((peer) => peer === label);
  assert.strictEqual(matches.length, 1);
  return label;
}
const titleStore = {
  streams: new Map([['stream-native', {id: 'stream-native', title: 'Octoplan native delivery', tracker_text: 'Saved stream tracker'}]]),
  details: new Map([['task-identity', {id: 'task-identity', title: 'Project identity proof'}]]),
  opaqueIdentifiers: new Set(['stream-native', 'task-identity', 'token-executor', 'token-planner', 'token-reviewer', 'token-specialist', 'token-recovery', 'token-supervisor', 'token-follow-up', 'thread-123', 'creation-token-abc'])
};
function validateSavedStreamRegistry(streams) {
  assert(streams instanceof Map);
  for (const [recordId, stream] of streams) {
    assert.deepStrictEqual(Object.keys(stream).sort(scalarCompare), ['id', 'title', 'tracker_text'].sort(scalarCompare));
    assert.strictEqual(stream.id, recordId);
    nonEmpty(stream.title);
    nonEmpty(stream.tracker_text);
  }
  return true;
}
function resolveSavedTitleLabel(recordId, maxChars, records, forbiddenIdentifiers) {
  assert(records instanceof Map);
  assert(records.has(recordId));
  const record = records.get(recordId);
  assert(record && typeof record === 'object');
  assert.strictEqual(record.id, recordId);
  nonEmpty(record.title);
  return resolveHumanLabel(record.title, maxChars, Array.from(records.values()).map((peer) => peer.title), forbiddenIdentifiers);
}
function makeNativeTitle(role, savedStreamId, savedDetailId, humanRef = null) {
  validateSavedStreamRegistry(titleStore.streams);
  const forbiddenIdentifiers = Array.from(titleStore.opaqueIdentifiers);
  const shortPlan = resolveSavedTitleLabel(savedStreamId, 18, titleStore.streams, forbiddenIdentifiers);
  const detail = resolveSavedTitleLabel(savedDetailId, 18, titleStore.details, forbiddenIdentifiers);
  assert(Array.from(shortPlan).length <= 18);
  assert(Array.from(detail).length <= 18);
  let title;
  if (role === 'supervisor') title = `Supervisor - ${shortPlan}`;
  else if (role === 'executor') {
    assert(/^(?:E\d{2,3}|#\d{1,3})$/.test(humanRef));
    title = `Executor ${humanRef} - ${shortPlan} - ${detail}`;
  } else if (role === 'reviewer') title = `Reviewer - ${shortPlan} - ${detail}`;
  else if (role === 'planner') title = `Planner - ${shortPlan} - ${detail}`;
  else if (role === 'specialist-reviewer') title = `Specialist reviewer - ${shortPlan} - ${detail}`;
  else assert.fail(`unknown title role: ${role}`);
  assert(Array.from(title).length <= 64);
  if (humanRef) rejectOpaqueVisible(humanRef, forbiddenIdentifiers);
  rejectOpaqueVisible(title, forbiddenIdentifiers);
  return title;
}
const titleStreamId = 'stream-native';
const titleTaskId = 'task-identity';
assert.strictEqual(makeNativeTitle('supervisor', titleStreamId, titleTaskId), 'Supervisor - Octoplan native…');
assert.strictEqual(makeNativeTitle('executor', titleStreamId, titleTaskId, 'E01'), 'Executor E01 - Octoplan native… - Project identity…');
assert.strictEqual(makeNativeTitle('executor', titleStreamId, titleTaskId, '#19'), 'Executor #19 - Octoplan native… - Project identity…');
assert.strictEqual(makeNativeTitle('reviewer', titleStreamId, titleTaskId), 'Reviewer - Octoplan native… - Project identity…');
assert.strictEqual(makeNativeTitle('planner', titleStreamId, titleTaskId), 'Planner - Octoplan native… - Project identity…');
assert.strictEqual(makeNativeTitle('specialist-reviewer', titleStreamId, titleTaskId), 'Specialist reviewer - Octoplan native… - Project identity…');
assert.throws(() => makeNativeTitle('supervisor', 'missing-stream', titleTaskId));
titleStore.streams.set('stream-migration', {id: 'stream-migration', title: 'Octoplan native migration', tracker_text: 'Saved peer stream tracker'});
assert.throws(() => makeNativeTitle('supervisor', titleStreamId, titleTaskId));
titleStore.streams.delete('stream-migration');
const opaqueUuid = ['123e4567', 'e89b', '12d3', 'a456', '426614174000'].join('-');
assert.throws(() => resolveHumanLabel(`Plan ${opaqueUuid}`, 18, [`Plan ${opaqueUuid}`]));
assert.throws(() => resolveHumanLabel('The same stream mission', 18, ['The same stream mission', 'The same stream migration']));
assert.throws(() => makeNativeTitle('executor', titleStreamId, titleTaskId, 'thread-123'));
titleStore.details.set('task-token', {id: 'task-token', title: 'token-executor'});
assert.throws(() => makeNativeTitle('reviewer', titleStreamId, 'task-token'));
titleStore.details.delete('task-token');
titleStore.streams.set('stream-token', {id: 'stream-token', title: 'creation-token-abc', tracker_text: 'Saved opaque stream tracker'});
assert.throws(() => makeNativeTitle('reviewer', 'stream-token', titleTaskId));
titleStore.streams.delete('stream-token');

const handoffFields = ['État', 'Fait', 'Bloqué', 'Décision attendue', 'Pour débloquer', 'Prochaine étape'];
function makeHandoff(values) {
  assert.deepStrictEqual(Object.keys(values), handoffFields);
  for (const field of handoffFields) {
    assert.strictEqual(typeof values[field], 'string');
    assert(values[field].trim());
    rejectOpaqueVisible(values[field], Array.from(titleStore.opaqueIdentifiers));
  }
  if (/^(?:paused|waiting-human)/i.test(values['État'])) {
    assert(/^(?:paused|waiting-human)\s*·\s*[^·]+$/i.test(values['État']));
    assert(/branch|branche|gate|review|project|identity|decision/i.test(values['État']));
    assert(/(?:was|were|is|are|completed|verified|reconciled|recorded|continues|finished)/i.test(values['Fait']));
    assert(/branch|branche/i.test(values['Bloqué']));
    assert(/(?:safe branch|branche sûre|no safe branch|aucune branche sûre)/i.test(values['Bloqué']));
    assert(/(?:when|once|after|equals|matches|quand|lorsque|si)\b.+/i.test(values['Pour débloquer']));
    assert(/(?:confirm|choose|select|decide|confirmer|choisir|décider)/i.test(values['Décision attendue']));
    assert(!/^(?:waiting for review|en attente de review|review required|en attente)$/i.test(values['Décision attendue'].trim()));
  } else if (/^completed\b/i.test(values['État'])) {
    assert(/^completed\s*·\s*[^·]+$/i.test(values['État']));
    assert(/artifact|check|review|complete|verified|delivered/i.test(values['Fait']));
    assert(/blocked|nothing|aucun|none/i.test(values['Bloqué']));
    assert(/decision|acceptance|none|aucune/i.test(values['Décision attendue']));
    assert(/resume|predicate|reprend|débloquer/i.test(values['Pour débloquer']));
    assert(/user|inspect|review|next|prochaine/i.test(values['Prochaine étape']));
  }
  return handoffFields.map((field) => `${field}: ${values[field]}`).join('\n');
}
function assertHandoffState(nextState, values) {
  assert.strictEqual(values['État'].split('·', 1)[0].trim().toLowerCase(), nextState);
  return true;
}
function transitionWithHandoff(nextState, values, publish) {
  assert(['waiting-human', 'paused', 'completed'].includes(nextState));
  const message = makeHandoff(values);
  assertHandoffState(nextState, values);
  const record = {state: nextState, outbox: {message, status: 'pending'}};
  if (publish(message) === true) record.outbox.status = 'sent';
  return record;
}
const pauseHandoff = {
  'État': 'paused · native project identity check',
  'Fait': 'The session intent was reconciled and safe branch E01 continues.',
  'Bloqué': 'The delivery branch is paused; Branche sûre: documentation review continues.',
  'Décision attendue': 'Confirm the native project association or choose a compliant target.',
  'Pour débloquer': 'Resume when observed projectId equals the planning project and the supervisor rereads the intent.',
  'Prochaine étape': 'Reconcile the native metadata, then activate only after the predicate passes.'
};
const waitingHumanHandoff = {...pauseHandoff, 'État': 'waiting-human · native project identity decision'};
assert.deepStrictEqual(transitionWithHandoff('paused', pauseHandoff, (message) => message.includes('État:')).state, 'paused');
assert.strictEqual(transitionWithHandoff('waiting-human', waitingHumanHandoff, (message) => message.includes('État:')).outbox.status, 'sent');
assert.throws(() => transitionWithHandoff('waiting-human', pauseHandoff, () => true));
assert.strictEqual(transitionWithHandoff('waiting-human', waitingHumanHandoff, () => false).outbox.status, 'pending');
assert.throws(() => transitionWithHandoff('paused', {...pauseHandoff, Extra: 'forbidden'}, () => true));
const finalHandoff = {
  'État': 'completed · Octoplan native delivery',
  'Fait': 'The artifact, checks, and independent review are complete and delivered.',
  'Bloqué': 'Nothing remains blocked; no safe branch is waiting.',
  'Décision attendue': 'None; acceptance is recorded separately and no decision remains.',
  'Pour débloquer': 'No resume predicate remains because the run is complete.',
  'Prochaine étape': 'The user may inspect the returned artifact link and acceptance record.'
};
assert.strictEqual(transitionWithHandoff('completed', finalHandoff, (message) => message.split('\n').length === 6).outbox.status, 'sent');

const nativeEvidenceSources = new Set(['native-metadata', 'native-registry']);
const nativeIdentityKeys = ['kind', 'projectId', 'directoryName'];
const nativeProjectRegistry = new Map([
  ['native-project-a', {source: 'native-metadata', identity: {kind: 'project', projectId: 'project-a', directoryName: null}}],
  ['native-project-b', {source: 'native-metadata', identity: {kind: 'project', projectId: 'project-b', directoryName: null}}],
  ['native-project-null', {source: 'native-metadata', identity: {kind: 'project', projectId: null, directoryName: null}}],
  ['native-projectless-content-room', {source: 'native-registry', identity: {kind: 'projectless', projectId: null, directoryName: 'content-room'}}]
]);
function readNativeProjectIdentity(observed) {
  if (!observed || typeof observed !== 'object' || typeof observed.nativeHandle !== 'string' || !observed.nativeHandle) return null;
  const evidence = nativeProjectRegistry.get(observed.nativeHandle);
  if (!evidence) return null;
  if (!nativeEvidenceSources.has(evidence.source)) return null;
  if (Object.keys(evidence).sort(scalarCompare).join('\u0000') !== ['identity', 'source'].sort(scalarCompare).join('\u0000')) return null;
  const identity = evidence.identity;
  if (!identity || typeof identity !== 'object' || Object.keys(identity).sort(scalarCompare).join('\u0000') !== nativeIdentityKeys.slice().sort(scalarCompare).join('\u0000')) return null;
  if (!['project', 'projectless'].includes(identity.kind)) return null;
  if (identity.kind === 'project') {
    assert(identity.projectId === null || typeof identity.projectId === 'string');
    assert.strictEqual(identity.directoryName, null);
  } else {
    assert.strictEqual(identity.projectId, null);
    nonEmpty(identity.directoryName);
  }
  return identity;
}
function reconcileNativeProject(planningTarget, observed, pauseHandoffValues) {
  validateTarget(planningTarget);
  const nativeIdentity = readNativeProjectIdentity(observed);
  const observedProjectId = nativeIdentity && nativeIdentity.projectId;
  const observedKind = nativeIdentity && nativeIdentity.kind;
  const matches = planningTarget.kind === 'project'
    ? observedKind === 'project' && typeof observedProjectId === 'string' && observedProjectId === planningTarget.project_id
    : observedKind === 'projectless' && nativeIdentity.directoryName === planningTarget.directory_name;
  if (matches) return {state: 'ready', message: null};
  assert(pauseHandoffValues);
  const message = makeHandoff(pauseHandoffValues);
  assertHandoffState('paused', pauseHandoffValues);
  return {state: 'paused', message};
}
const nativeMetadataProject = {nativeHandle: 'native-project-a', prompt: 'project-a'};
assert.strictEqual(reconcileNativeProject(parseTarget('project-a · local · planning session').target, nativeMetadataProject, pauseHandoff).state, 'ready');
assert.strictEqual(reconcileNativeProject(parseTarget('project-a · local · planning session').target, {prompt: 'project-a', projectId: 'project-a'}, pauseHandoff).state, 'paused');
assert.strictEqual(reconcileNativeProject(parseTarget('project-a · local · planning session').target, {nativeHandle: 'prompt-project-a', prompt: 'project-a'}, pauseHandoff).state, 'paused');
assert.strictEqual(reconcileNativeProject(parseTarget('project-a · local · planning session').target, {nativeHandle: 'native-project-null', prompt: 'project-a'}, pauseHandoff).state, 'paused');
assert.strictEqual(reconcileNativeProject(parseTarget('project-a · local · planning session').target, {nativeHandle: 'native-projectless-content-room'}, pauseHandoff).state, 'paused');
assert.strictEqual(reconcileNativeProject(parseTarget('project-a · local · planning session').target, {nativeHandle: 'native-project-b', prompt: 'project-a'}, pauseHandoff).state, 'paused');
assert.throws(() => reconcileNativeProject(parseTarget('project-a · local · planning session').target, {nativeHandle: 'native-project-null'}, null));
assert.strictEqual(reconcileNativeProject(parseTarget('projectless · content-room · planning session').target, {nativeHandle: 'native-projectless-content-room'}, pauseHandoff).state, 'ready');
assert.strictEqual(reconcileNativeProject(parseTarget('project-a · local · planning session').target, {nativeHandle: 'native-project-null'}, pauseHandoff).message.split('\n').length, 6);

const capacitySourceRegistry = new Map([
  ['route-a', {source: {kind: 'saved-route', record_id: 'route-a', evidence_digest: 'c'.repeat(64)}, route: 'route-a', model: 'gpt-5.6-luna', effort: 'max', capabilities: ['native-context'], can_detect: true}],
  ['delta-a', {source: {kind: 'incident-delta', record_id: 'delta-a', evidence_digest: 'd'.repeat(64)}, route: 'recovery-route-a', model: 'gpt-5.6-luna', effort: 'max', capabilities: ['incident-detection'], can_detect: true}],
  ['incident-luna', {source: {kind: 'incident-delta', record_id: 'incident-luna', evidence_digest: 'e'.repeat(64)}, route: 'incident-luna', model: 'gpt-5.6-luna', effort: 'max', capabilities: ['incident-detection'], can_detect: true}],
  ['incident-terra', {source: {kind: 'incident-delta', record_id: 'incident-terra', evidence_digest: 'f'.repeat(64)}, route: 'incident-terra', model: 'gpt-5.6-terra', effort: 'high', capabilities: ['incident-detection'], can_detect: false}],
  ['incident-sol', {source: {kind: 'incident-delta', record_id: 'incident-sol', evidence_digest: 'a'.repeat(64)}, route: 'incident-sol', model: 'gpt-5.6-sol', effort: 'high', capabilities: ['incident-detection'], can_detect: true}],
  ['saved-terra', {source: {kind: 'saved-route', record_id: 'saved-terra', evidence_digest: 'b'.repeat(64)}, route: 'saved-terra', model: 'gpt-5.6-terra', effort: 'max', capabilities: ['incident-detection'], can_detect: true}]
]);
function validateCapacitySource(source, sourceRegistry = null) {
  assert(source && typeof source === 'object' && !Array.isArray(source));
  assert.deepStrictEqual(Object.keys(source).sort(scalarCompare), ['kind', 'record_id', 'evidence_digest'].sort(scalarCompare));
  assert(new Set(['saved-route', 'incident-delta']).has(source.kind));
  nonEmpty(source.record_id);
  assert(/^[a-f0-9]{64}$/.test(source.evidence_digest));
  if (!sourceRegistry) return null;
  const record = sourceRegistry.get(source.record_id);
  assert(record && typeof record === 'object');
  assert.deepStrictEqual(record.source, source);
  return record;
}
function nonBlank(value) {
  assert.strictEqual(typeof value, 'string');
  assert(value.trim().length > 0);
  return value;
}
function normalizeCapacity(route, context = {}) {
  assert(route && typeof route === 'object');
  const model = String(route.model).trim().toLowerCase();
  const effort = String(route.effort).trim().toLowerCase();
  assert(['gpt-5.6-luna', 'gpt-5.6-terra', 'gpt-5.6-sol'].includes(model));
  assert(['high', 'xhigh', 'max'].includes(effort));
  if (model === 'gpt-5.6-luna') assert.strictEqual(effort, 'max');
  else nonBlank(route.rationale);
  const sourceRecord = context.sourceRegistry ? validateCapacitySource(route.capacity_source, context.sourceRegistry) : null;
  if (sourceRecord) {
    assert.strictEqual(sourceRecord.model, model);
    assert.strictEqual(sourceRecord.effort, effort);
    nonBlank(route.route);
    assert.strictEqual(sourceRecord.route, route.route);
    if (route.capabilities) assert.deepStrictEqual(route.capabilities, sourceRecord.capabilities);
    if (Object.prototype.hasOwnProperty.call(route, 'can_detect')) assert.strictEqual(route.can_detect, sourceRecord.can_detect);
  }
  if (context.requiredCapability) {
    assert(Array.isArray(route.capabilities));
    assert(route.capabilities.includes(context.requiredCapability));
  }
  const normalized = {model, effort, rationale: route.rationale ?? null};
  if (route.route) normalized.route = route.route;
  if (route.capacity_source) normalized.capacity_source = route.capacity_source;
  if (route.capabilities) normalized.capabilities = route.capabilities;
  if (Object.prototype.hasOwnProperty.call(route, 'can_detect')) normalized.can_detect = route.can_detect;
  return normalized;
}
const capacityCost = {
  'gpt-5.6-luna|max': 1,
  'gpt-5.6-terra|high': 2,
  'gpt-5.6-terra|xhigh': 3,
  'gpt-5.6-terra|max': 4,
  'gpt-5.6-sol|high': 5,
  'gpt-5.6-sol|xhigh': 6,
  'gpt-5.6-sol|max': 7
};
function leastCostlyCapacity(routes, context = {}) {
  assert(Array.isArray(routes));
  assert(context.sourceRegistry && context.requiredCapability);
  const normalized = routes.map((route) => normalizeCapacity(route, context));
  const adequate = normalized.filter((route) => route.can_detect === true);
  assert(adequate.length > 0);
  return adequate.slice().sort((a, b) => capacityCost[`${a.model}|${a.effort}`] - capacityCost[`${b.model}|${b.effort}`])[0];
}
assert.deepStrictEqual(normalizeCapacity({model: 'GPT-5.6-LUNA', effort: 'MAX'}), {model: 'gpt-5.6-luna', effort: 'max', rationale: null});
assert.throws(() => normalizeCapacity({model: 'gpt-5.6-luna', effort: 'high'}));
assert.throws(() => normalizeCapacity({model: 'gpt-5.6-luna', effort: 'xhigh'}));
assert.throws(() => normalizeCapacity({model: 'gpt-5.6-terra', effort: 'high', rationale: ' '}));
assert.deepStrictEqual(normalizeCapacity({model: 'gpt-5.6-terra', effort: 'high', rationale: 'bounded judgment'}).model, 'gpt-5.6-terra');
assert.deepStrictEqual(normalizeCapacity({model: 'gpt-5.6-sol', effort: 'max', rationale: 'weak verifier'}).effort, 'max');
const incidentRoutingContext = {sourceRegistry: capacitySourceRegistry, requiredCapability: 'incident-detection'};
const incidentRoutes = [
  {model: 'gpt-5.6-terra', effort: 'high', rationale: 'bounded judgment', route: 'incident-terra', capacity_source: capacitySourceRegistry.get('incident-terra').source, capabilities: ['incident-detection'], can_detect: false},
  {model: 'GPT-5.6-LUNA', effort: 'MAX', route: 'incident-luna', capacity_source: capacitySourceRegistry.get('incident-luna').source, capabilities: ['incident-detection'], can_detect: true},
  {model: 'gpt-5.6-sol', effort: 'high', rationale: 'weak verifier', route: 'incident-sol', capacity_source: capacitySourceRegistry.get('incident-sol').source, capabilities: ['incident-detection'], can_detect: true},
  {model: 'gpt-5.6-terra', effort: 'max', rationale: 'saved route has adequate incident detection', route: 'saved-terra', capacity_source: capacitySourceRegistry.get('saved-terra').source, capabilities: ['incident-detection'], can_detect: true}
];
const leastCostly = leastCostlyCapacity(incidentRoutes, incidentRoutingContext);
assert.strictEqual(leastCostly.model, 'gpt-5.6-luna');
assert.strictEqual(leastCostly.effort, 'max');
assert.strictEqual(leastCostly.capacity_source.record_id, 'incident-luna');
assert.throws(() => leastCostlyCapacity([], incidentRoutingContext));
assert.throws(() => leastCostlyCapacity([{...incidentRoutes[1], capacity_source: {...incidentRoutes[1].capacity_source, evidence_digest: '0'.repeat(64)}}], incidentRoutingContext));
assert.throws(() => leastCostlyCapacity([{...incidentRoutes[1], model: 'gpt-5.6-terra', effort: 'max', rationale: 'mismatched source evidence'}], incidentRoutingContext));
assert.throws(() => leastCostlyCapacity([{...incidentRoutes[1], route: ''}], incidentRoutingContext));

function validateOverrides(rows, planningTarget) {
  validateTarget(planningTarget);
  const keys = ['task_id', 'role', 'target'];
  const seen = new Set();
  for (const row of rows) {
    assert.deepStrictEqual(Object.keys(row).sort(scalarCompare), keys.slice().sort(scalarCompare));
    nonEmpty(row.task_id);
    assert(overrideRoles.has(row.role));
    validateTarget(row.target);
    sameProjectIdentity(planningTarget, row.target);
    const identity = `${row.task_id}\u0000${row.role}`;
    assert(!seen.has(identity));
    seen.add(identity);
  }
  assert.deepStrictEqual(rows, rows.slice().sort((a, b) => scalarCompare(a.task_id, b.task_id) || scalarCompare(a.role, b.role)));
  return true;
}
const plannerProjectTarget = parseTarget('project-a · local · planning session').target;
const overrideRows = [
  {task_id: 'task-a', role: 'executor', target: parseTarget('project-a · worktree · observed').target},
  {task_id: 'task-a', role: 'recovery', target: parseTarget('project-a · local · bounded recovery').target}
];
assert(validateOverrides(overrideRows, plannerProjectTarget));
assert(validateOverrides([
  overrideRows[0],
  {task_id: 'task-a', role: 'planner', target: parseTarget('project-a · local · incident planner').target},
  overrideRows[1]
], plannerProjectTarget));
assert(sameProjectIdentity(plannerProjectTarget, parseTarget('project-a · worktree · executor').target));
assert.throws(() => sameProjectIdentity(plannerProjectTarget, parseTarget('project-b · worktree · wrong project').target));
assert.throws(() => sameProjectIdentity(plannerProjectTarget, parseTarget('projectless · project-a · wrong target kind').target));
const plannerProjectlessTarget = parseTarget('projectless · content-room · planning session').target;
assert(sameProjectIdentity(plannerProjectlessTarget, parseTarget('projectless · content-room · executor').target));
assert.throws(() => sameProjectIdentity(plannerProjectlessTarget, parseTarget('projectless · other-room · wrong directory').target));
assert.deepStrictEqual(overrideRows[0].target, parseTarget('project-a · worktree · different observed evidence').target);
for (const key of ['task_id', 'role', 'target']) {
  const mutation = overrideRows[0].map ? overrideRows[0] : {...overrideRows[0]};
  if (key === 'task_id') mutation[key] = '';
  else if (key === 'role') mutation[key] = 'unknown';
  else mutation[key] = {...mutation[key], extra: true};
  assert.throws(() => validateOverrides([mutation, overrideRows[1]], plannerProjectTarget));
}
assert.throws(() => validateOverrides([{...overrideRows[0], extra: true}, overrideRows[1]], plannerProjectTarget));
assert.throws(() => validateOverrides([{task_id: 'task-a', role: 'executor'}, overrideRows[1]], plannerProjectTarget));
assert.throws(() => validateOverrides([overrideRows[1], overrideRows[0]], plannerProjectTarget));
assert.throws(() => validateOverrides([overrideRows[0], {...overrideRows[0]}], plannerProjectTarget));
assert.throws(() => validateOverrides([{task_id: 'task-b', role: 'executor', target: parseTarget('project-b · worktree · wrong project').target}], plannerProjectTarget));

const executionEnvironmentKeys = ['inline_supervisor_target', 'dedicated_supervisor_target', 'default_executor_target', 'task_role_target_overrides', 'reviewer_default'];
function validateExecutionEnvironment(value) {
  assert.deepStrictEqual(Object.keys(value).sort(scalarCompare), executionEnvironmentKeys.slice().sort(scalarCompare));
  validateTarget(value.inline_supervisor_target);
  if (value.dedicated_supervisor_target !== null) sameProjectIdentity(value.inline_supervisor_target, value.dedicated_supervisor_target);
  sameProjectIdentity(value.inline_supervisor_target, value.default_executor_target);
  sameProjectIdentity(value.inline_supervisor_target, value.reviewer_default);
  validateOverrides(value.task_role_target_overrides, value.inline_supervisor_target);
  return true;
}
const projectEnvironment = {
  inline_supervisor_target: plannerProjectTarget,
  dedicated_supervisor_target: parseTarget('project-a · worktree · dedicated supervisor').target,
  default_executor_target: parseTarget('project-a · worktree · default executor').target,
  task_role_target_overrides: overrideRows,
  reviewer_default: parseTarget('project-a · local · default reviewer').target
};
assert(validateExecutionEnvironment(projectEnvironment));
for (const key of ['dedicated_supervisor_target', 'default_executor_target', 'reviewer_default']) {
  assert.throws(() => validateExecutionEnvironment({...projectEnvironment, [key]: parseTarget('project-b · worktree · wrong project').target}));
}
const projectlessEnvironment = {
  inline_supervisor_target: plannerProjectlessTarget,
  dedicated_supervisor_target: null,
  default_executor_target: parseTarget('projectless · content-room · default executor').target,
  task_role_target_overrides: [{task_id: 'task-content', role: 'lead-reviewer', target: parseTarget('projectless · content-room · lead reviewer').target}],
  reviewer_default: parseTarget('projectless · content-room · default reviewer').target
};
assert(validateExecutionEnvironment(projectlessEnvironment));
for (const key of ['default_executor_target', 'reviewer_default']) {
  assert.throws(() => validateExecutionEnvironment({...projectlessEnvironment, [key]: parseTarget('projectless · other-room · wrong directory').target}));
}
assert.throws(() => validateExecutionEnvironment({...projectEnvironment, task_role_target_overrides: [{task_id: 'task-a', role: 'specialist-reviewer', target: parseTarget('project-b · worktree · wrong project').target}]}));

function sortRows(rows, keys) {
  return rows.slice().sort((a, b) => keys.reduce((delta, key) => delta || scalarCompare(a[key], b[key]), 0));
}
assert.deepStrictEqual(sortRows([{id: 'task-b'}, {id: 'task-a'}], ['id']).map((row) => row.id), ['task-a', 'task-b']);
assert.deepStrictEqual(sortRows([{id: 'decision-b'}, {id: 'decision-a'}], ['id']).map((row) => row.id), ['decision-a', 'decision-b']);
assert.deepStrictEqual(sortRows([{id: 'stream-b'}, {id: 'stream-a'}], ['id']).map((row) => row.id), ['stream-a', 'stream-b']);
assert.deepStrictEqual(sortRows([{id: 'question-b'}, {id: 'question-a'}], ['id']).map((row) => row.id), ['question-a', 'question-b']);
assert.deepStrictEqual(sortRows([{task_id: 'task-b', role: 'executor'}, {task_id: 'task-a', role: 'specialist-reviewer'}, {task_id: 'task-a', role: 'executor'}], ['task_id', 'role']).map((row) => `${row.task_id}:${row.role}`), ['task-a:executor', 'task-a:specialist-reviewer', 'task-b:executor']);
assert.deepStrictEqual(sortRows([{old_run_id: 'run-b', source_task_id: 'task-a', artifact_revision: 'artifact-a'}, {old_run_id: 'run-a', source_task_id: 'task-b', artifact_revision: 'artifact-a'}, {old_run_id: 'run-a', source_task_id: 'task-a', artifact_revision: 'artifact-b'}], ['old_run_id', 'source_task_id', 'artifact_revision']).map((row) => `${row.old_run_id}:${row.source_task_id}:${row.artifact_revision}`), ['run-a:task-a:artifact-b', 'run-a:task-b:artifact-a', 'run-b:task-a:artifact-a']);
assert.deepStrictEqual(sortRows([{task_id: 'task-b', invariant_id: 'inv-a'}, {task_id: 'task-a', invariant_id: 'inv-b'}, {task_id: 'task-a', invariant_id: 'inv-a'}], ['task_id', 'invariant_id']).map((row) => `${row.task_id}:${row.invariant_id}`), ['task-a:inv-a', 'task-a:inv-b', 'task-b:inv-a']);
assert.deepStrictEqual(sortRows([{invariant_id: 'inv-a', trigger_class: 'z'}, {invariant_id: 'inv-a', trigger_class: 'a'}, {invariant_id: 'inv-b', trigger_class: 'a'}], ['invariant_id', 'trigger_class']).map((row) => `${row.invariant_id}:${row.trigger_class}`), ['inv-a:a', 'inv-a:z', 'inv-b:a']);
assert.deepStrictEqual([{revision: 'rev-a'}, {revision: null}].sort((a, b) => revisionCompare(a.revision, b.revision)).map((row) => row.revision), [null, 'rev-a']);
assert.deepStrictEqual(['second', 'first'], ['second', 'first']);
assert.notStrictEqual(digest({value: ' value '}), digest({value: 'value'}));
assert.notStrictEqual(digest({value: 'é'}), digest({value: 'e\u0301'}));
assert.strictEqual(escapeString('/é\n'), '/é\\u000a');
assert.throws(() => escapeString('\uD800'));

function decision(record) {
  for (const key of ['id', 'title', 'status']) assert(record[key] !== undefined);
  return {id: record.id, work_stream_id: record.work_stream_id ?? null, title: record.title, content: record.content ?? null, rationale: record.rationale ?? null, status: record.status};
}
assert.deepStrictEqual(decision({id: 'decision-a', title: 'Choice', status: 'accepted'}).content, null);
assert.throws(() => decision({id: 'decision-a', title: 'Choice'}));
const question = {id: 'question-a', work_stream_id: null, question: 'Open?', status: 'open', answer: null};
assert.strictEqual(question.status, 'open');
assert.notStrictEqual(digest(question), digest({...question, status: 'resolved'}));

function taskRoutes(record, human = false) {
  const keys = ['exec', 'review', 'review_route', 'specialist_review_route', 'fallback', 'recovery_override', 'lineage_override'];
  const routes = Object.fromEntries(keys.map((key) => [key, record.routes?.[key] ?? null]));
  routes.parallel_safe_with = record.routes?.parallel_safe_with ?? [];
  assert(Number.isInteger(record.impact) && record.impact >= 1 && record.impact <= 5);
  if (human) assert(keys.every((key) => routes[key] === null) && routes.parallel_safe_with.length === 0);
  else assert(routes.exec !== null && routes.review !== null);
  return routes;
}
assert.strictEqual(taskRoutes({impact: 3, routes: {exec: 'Exec', review: 'Review'}}).fallback, null);
assert.deepStrictEqual(taskRoutes({impact: 4, routes: {}}, true).parallel_safe_with, []);
assert.throws(() => taskRoutes({impact: '4', routes: {exec: 'Exec', review: 'Review'}}));

function validateProtectedOccurrences(rows, tasks) {
  const taskMap = new Map(tasks.map((task) => [nonEmpty(task.id), task]));
  assert.strictEqual(taskMap.size, tasks.length);
  const seenOccurrences = new Set();
  const seenTasks = new Set();
  for (const row of rows) {
    assert.deepStrictEqual(Object.keys(row).sort(scalarCompare), occurrenceKeys.slice().sort(scalarCompare));
    const task = taskMap.get(row.task_id);
    assert(task && task.human === true);
    assert(actionKinds.has(row.action_kind));
    nonEmpty(row.target);
    assert(row.parameters && typeof row.parameters === 'object' && !Array.isArray(row.parameters));
    assert(row.environment === null || (typeof row.environment === 'string' && row.environment.length > 0));
    assert(row.audience === null || (typeof row.audience === 'string' && row.audience.length > 0));
    if (row.action_kind === 'publication') assert(row.audience !== null);
    if (row.action_kind === 'external-spend') {
      assert(row.amount_currency && typeof row.amount_currency === 'object' && !Array.isArray(row.amount_currency));
      assert.deepStrictEqual(Object.keys(row.amount_currency).sort(scalarCompare), ['amount', 'currency']);
      assert(/^(0|[1-9][0-9]*)(\.[0-9]+)?$/.test(nonEmpty(row.amount_currency.amount)));
      nonEmpty(row.amount_currency.currency);
    } else assert.strictEqual(row.amount_currency, null);
    for (const key of ['task_id', 'occurrence_key', 'owner_approval_rule', 'evidence', 'wake_predicate']) nonEmpty(row[key]);
    assert(!seenOccurrences.has(row.occurrence_key));
    assert(!seenTasks.has(row.task_id));
    seenOccurrences.add(row.occurrence_key);
    seenTasks.add(row.task_id);
  }
  for (const task of tasks) {
    if (task.human) assert(seenTasks.has(task.id));
    else assert(!seenTasks.has(task.id));
  }
  assert.deepStrictEqual(rows, rows.slice().sort((a, b) => scalarCompare(a.occurrence_key, b.occurrence_key)));
  return true;
}
function validOccurrence(task_id, action_kind, occurrence_key) {
  return {
    task_id,
    action_kind,
    target: 'target-a',
    parameters: {nested: {b: 2, a: 1}},
    environment: 'production',
    amount_currency: action_kind === 'external-spend' ? {amount: '12.50', currency: 'USD'} : null,
    audience: action_kind === 'publication' ? 'public-audience' : null,
    occurrence_key,
    owner_approval_rule: 'owner-approval',
    evidence: 'evidence-source',
    wake_predicate: 'wake-on-approval'
  };
}
const protectedTasks = [{id: 'human-merge', human: true}, {id: 'human-publish', human: true}, {id: 'human-spend', human: true}, {id: 'agent-a', human: false}];
const protectedRows = [validOccurrence('human-merge', 'merge', 'occ-merge'), validOccurrence('human-publish', 'publication', 'occ-publish'), validOccurrence('human-spend', 'external-spend', 'occ-spend')];
assert(validateProtectedOccurrences(protectedRows, protectedTasks));
const fingerprintObject = {fingerprint_schema: FINGERPRINT, ledger_task_id: 'ledger-a', plan_hash: 'PENDING', manifest: {delivery_mandate: baseMandate}, streams: [], decisions: [], questions: [], tasks: protectedTasks, protected_occurrences: protectedRows};
assert(Array.isArray(fingerprintObject.protected_occurrences));
assert.notStrictEqual(digest(fingerprintObject), digest({...fingerprintObject, protected_occurrences: protectedRows.slice(0, 2)}));
assert.strictEqual(digest({parameters: {b: 2, a: 1}}), digest({parameters: {a: 1, b: 2}}));
const validOccurrenceMutations = {
  task_id: () => {
    const rows = protectedRows.map((row) => ({...row, parameters: {...row.parameters}}));
    rows[0].task_id = protectedRows[1].task_id;
    rows[1].task_id = protectedRows[0].task_id;
    return rows;
  },
  action_kind: () => protectedRows.map((row, index) => index === 0 ? {...row, action_kind: 'acceptance'} : {...row, parameters: {...row.parameters}}),
  target: () => protectedRows.map((row, index) => index === 0 ? {...row, target: 'target-b', parameters: {...row.parameters}} : {...row, parameters: {...row.parameters}}),
  parameters: () => protectedRows.map((row, index) => index === 0 ? {...row, parameters: {nested: {a: 1, b: 2}, changed: true}} : {...row, parameters: {...row.parameters}}),
  environment: () => protectedRows.map((row, index) => index === 0 ? {...row, environment: 'staging', parameters: {...row.parameters}} : {...row, parameters: {...row.parameters}}),
  amount_currency: () => protectedRows.map((row, index) => index === 2 ? {...row, amount_currency: {amount: '13.50', currency: 'USD'}, parameters: {...row.parameters}} : {...row, parameters: {...row.parameters}}),
  audience: () => protectedRows.map((row, index) => index === 1 ? {...row, audience: 'different-audience', parameters: {...row.parameters}} : {...row, parameters: {...row.parameters}}),
  occurrence_key: () => protectedRows.map((row, index) => index === 0 ? {...row, occurrence_key: 'occ-aardvark', parameters: {...row.parameters}} : {...row, parameters: {...row.parameters}}),
  owner_approval_rule: () => protectedRows.map((row, index) => index === 0 ? {...row, owner_approval_rule: 'different-owner-rule', parameters: {...row.parameters}} : {...row, parameters: {...row.parameters}}),
  evidence: () => protectedRows.map((row, index) => index === 0 ? {...row, evidence: 'different-evidence', parameters: {...row.parameters}} : {...row, parameters: {...row.parameters}}),
  wake_predicate: () => protectedRows.map((row, index) => index === 0 ? {...row, wake_predicate: 'wake-on-review', parameters: {...row.parameters}} : {...row, parameters: {...row.parameters}})
};
for (const key of occurrenceKeys) {
  const mutatedRows = validOccurrenceMutations[key]();
  assert(validateProtectedOccurrences(mutatedRows, protectedTasks));
  assert.notStrictEqual(digest({protected_occurrences: protectedRows}), digest({protected_occurrences: mutatedRows}));
}
for (const key of occurrenceKeys) {
  const mutation = {...protectedRows[0], parameters: {...protectedRows[0].parameters}};
  if (key === 'task_id') mutation[key] = 'agent-a';
  else if (key === 'action_kind') mutation[key] = 'unknown';
  else if (key === 'target') mutation[key] = '';
  else if (key === 'parameters') mutation[key] = [];
  else if (key === 'environment' || key === 'audience') mutation[key] = 7;
  else if (key === 'amount_currency') mutation[key] = {amount: '1', currency: 'USD'};
  else if (key === 'occurrence_key') mutation[key] = protectedRows[1].occurrence_key;
  else mutation[key] = '';
  assert.notStrictEqual(digest({protected_occurrences: [protectedRows[0]]}), digest({protected_occurrences: [mutation]}));
  assert.throws(() => validateProtectedOccurrences([mutation, protectedRows[1], protectedRows[2]], protectedTasks));
}
assert.throws(() => validateProtectedOccurrences([], protectedTasks));
assert.strictEqual(baseMandate.protected_actions_authorized, false);
assert.throws(() => validateProtectedOccurrences(protectedRows.slice(0, 2), protectedTasks));

function feasibilityPass(tasks, coverage, rows, sources, verifiers) {
  const taskIds = new Set(tasks.map((task) => nonEmpty(task.id)));
  assert.strictEqual(taskIds.size, tasks.length);
  const coverageKeys = ['task_id', 'triggered_invariants'];
  const covered = new Map();
  for (const item of coverage) {
    assert.deepStrictEqual(Object.keys(item).sort(scalarCompare), coverageKeys.slice().sort(scalarCompare));
    assert(taskIds.has(item.task_id) && !covered.has(item.task_id));
    assert(Array.isArray(item.triggered_invariants));
    const seen = new Set();
    for (const triggered of item.triggered_invariants) {
      assert.deepStrictEqual(Object.keys(triggered).sort(scalarCompare), ['invariant_id', 'trigger_class']);
      nonEmpty(triggered.invariant_id);
      assert(triggerClasses.includes(triggered.trigger_class));
      assert(!seen.has(triggered.invariant_id));
      seen.add(triggered.invariant_id);
    }
    covered.set(item.task_id, item.triggered_invariants);
  }
  assert.strictEqual(covered.size, tasks.length);
  for (const task of tasks) assert(covered.has(task.id));
  const rowKeys = ['consistency_boundary', 'invariant_id', 'prerequisite_task_ids', 'primitive_ref', 'rollback_or_compensation', 'source_revisions', 'task_id', 'trigger_class', 'verifier', 'verifier_available'];
  const rowsByPair = new Map();
  for (const row of rows) {
    assert.deepStrictEqual(Object.keys(row).sort(scalarCompare), rowKeys.slice().sort(scalarCompare));
    assert(taskIds.has(row.task_id) && nonEmpty(row.invariant_id) && triggerClasses.includes(row.trigger_class));
    const pair = `${row.task_id}\u0000${row.invariant_id}`;
    assert(!rowsByPair.has(pair));
    assert(row.primitive_ref && row.consistency_boundary && row.rollback_or_compensation && row.verifier);
    assert(Array.isArray(row.source_revisions) && row.source_revisions.length > 0);
    assert(row.source_revisions.every((revision) => nonEmpty(revision) && sources.has(revision)));
    assert(row.verifier_available === true && verifiers.get(row.verifier) === true);
    assert(Array.isArray(row.prerequisite_task_ids));
    assert(row.prerequisite_task_ids.every((id) => taskIds.has(id)));
    rowsByPair.set(pair, row);
  }
  for (const [taskId, triggered] of covered) {
    for (const item of triggered) {
      const row = rowsByPair.get(`${taskId}\u0000${item.invariant_id}`);
      assert(row && row.trigger_class === item.trigger_class);
    }
  }
  assert.strictEqual(rowsByPair.size, coveredValues(covered).reduce((count, items) => count + items.length, 0));
  if (!rows.length) assert([...covered.values()].every((items) => items.length === 0));
  return true;
}
function coveredValues(covered) {
  return [...covered.values()];
}
const tasks = [{id: 'task-a'}, {id: 'task-b'}];
const sources = new Set(['source-a']);
const verifiers = new Map([['check-a', true]]);
const coverage = [{task_id: 'task-a', triggered_invariants: [{invariant_id: 'atomicity', trigger_class: 'atomicity-concurrency'}]}, {task_id: 'task-b', triggered_invariants: []}];
const matrix = [{task_id: 'task-a', invariant_id: 'atomicity', trigger_class: 'atomicity-concurrency', primitive_ref: 'batch', source_revisions: ['source-a'], consistency_boundary: 'transaction', rollback_or_compensation: 'restore', verifier: 'check-a', verifier_available: true, prerequisite_task_ids: []}];
assert(feasibilityPass(tasks, coverage, matrix, sources, verifiers));
assert.throws(() => feasibilityPass(tasks, coverage.slice(1), matrix, sources, verifiers));
assert.throws(() => feasibilityPass(tasks, coverage, [], sources, verifiers));
assert.throws(() => feasibilityPass(tasks, coverage, [...matrix, {...matrix[0], task_id: 'task-b', invariant_id: 'extra', trigger_class: 'paid-resource'}], sources, verifiers));
assert.throws(() => feasibilityPass(tasks, coverage, [matrix[0], matrix[0]], sources, verifiers));
assert.throws(() => feasibilityPass(tasks, coverage, [{...matrix[0], trigger_class: 'paid-resource'}], sources, verifiers));
assert.throws(() => feasibilityPass(tasks, coverage, [{...matrix[0], source_revisions: ['stale']}], sources, verifiers));
assert.throws(() => feasibilityPass(tasks, coverage, [{...matrix[0], verifier_available: false}], sources, verifiers));
assert.throws(() => feasibilityPass(tasks, coverage, [{...matrix[0], primitive_ref: null}], sources, verifiers));
assert.throws(() => feasibilityPass(tasks, coverage, [{...matrix[0], consistency_boundary: null}], sources, verifiers));
assert.throws(() => feasibilityPass(tasks, coverage, [{...matrix[0], prerequisite_task_ids: undefined}], sources, verifiers));
assert.strictEqual(matrix[0].primitive_ref, 'batch');
assert.strictEqual(matrix[0].verifier_available, true);
assert.strictEqual(coverage[0].triggered_invariants[0].trigger_class, 'atomicity-concurrency');
function selectGroupRoute(atomicGroupTransitionAvailable, evidence) {
  assert(evidence && typeof evidence === 'object' && !Array.isArray(evidence));
  assert.deepStrictEqual(Object.keys(evidence).sort(scalarCompare), ['member_ids', 'no_partial_creation', 'preflight_record_id', 'preflight_revision', 'review_artifact']);
  assert(Array.isArray(evidence.member_ids) && evidence.member_ids.length > 1 && evidence.member_ids.every(nonEmpty));
  assert.deepStrictEqual(evidence.member_ids, evidence.member_ids.slice().sort(scalarCompare));
  nonEmpty(evidence.preflight_record_id);
  nonEmpty(evidence.preflight_revision);
  assert.strictEqual(evidence.no_partial_creation, true);
  assert(Object.isFrozen(evidence.review_artifact));
  assert.deepStrictEqual(Object.keys(evidence.review_artifact).sort(scalarCompare), ['evidence_digest', 'verdict']);
  assert.strictEqual(evidence.review_artifact.verdict, 'PASS');
  assert(/^[a-f0-9]{64}$/.test(evidence.review_artifact.evidence_digest));
  return atomicGroupTransitionAvailable === true
    ? {route: 'parallel', partialStartAllowed: false, preflightRevision: evidence.preflight_revision}
    : {route: 'reviewed-serial-fallback', partialStartAllowed: false, preflightRevision: evidence.preflight_revision};
}
const groupRouteEvidence = {member_ids: ['task-a', 'task-b'], no_partial_creation: true, preflight_record_id: 'preflight-a', preflight_revision: 'revision-a', review_artifact: Object.freeze({verdict: 'PASS', evidence_digest: 'a'.repeat(64)})};
assert.deepStrictEqual(selectGroupRoute(true, groupRouteEvidence), {route: 'parallel', partialStartAllowed: false, preflightRevision: 'revision-a'});
assert.deepStrictEqual(selectGroupRoute(false, groupRouteEvidence), {route: 'reviewed-serial-fallback', partialStartAllowed: false, preflightRevision: 'revision-a'});
assert.throws(() => selectGroupRoute(false, {...groupRouteEvidence, no_partial_creation: false}));
assert.throws(() => selectGroupRoute(false, {...groupRouteEvidence, review_artifact: Object.freeze({verdict: 'REVISE', evidence_digest: 'a'.repeat(64)})}));

const verdictForImpossible = (row) => (!row.primitive_ref || !row.verifier_available ? 'REVISE' : 'PASS');
assert.strictEqual(verdictForImpossible({primitive_ref: null, verifier_available: false}), 'REVISE');
const stateTransitions = {active: ['replanning', 'waiting-human', 'paused', 'revoked', 'completed'], replanning: ['superseded', 'waiting-human', 'failed'], paused: ['active', 'revoked'], 'waiting-human': ['active', 'revoked']};
assert(stateTransitions.active.includes('replanning'));
assert(!stateTransitions.active.includes('superseded'));
const attentionTransitionStates = new Set(['waiting-human', 'paused', 'completed']);
const transitionEvents = [];
function guardedStateTransition(currentState, nextState, values, publish) {
  assert(stateTransitions[currentState] && stateTransitions[currentState].includes(nextState));
  const record = {state: nextState, outbox: null};
  if (attentionTransitionStates.has(nextState)) {
    const message = makeHandoff(values);
    assertHandoffState(nextState, values);
    record.outbox = {message, status: 'pending'};
  }
  transitionEvents.push(`transition:${nextState}`);
  if (record.outbox && publish(record.outbox.message) === true) record.outbox.status = 'sent';
  return record;
}
transitionEvents.length = 0;
let modeledState = guardedStateTransition('active', 'paused', pauseHandoff, (message) => { transitionEvents.push('publish'); return message.includes('État:'); });
assert.strictEqual(modeledState.state, 'paused');
assert.deepStrictEqual(transitionEvents, ['transition:paused', 'publish']);
transitionEvents.length = 0;
modeledState = guardedStateTransition('replanning', 'waiting-human', waitingHumanHandoff, (message) => { transitionEvents.push('publish'); return message.includes('État:'); });
assert.strictEqual(modeledState.state, 'waiting-human');
assert.deepStrictEqual(transitionEvents, ['transition:waiting-human', 'publish']);
transitionEvents.length = 0;
modeledState = guardedStateTransition('active', 'completed', finalHandoff, (message) => { transitionEvents.push('publish'); return message.includes('État:'); });
assert.strictEqual(modeledState.state, 'completed');
assert.deepStrictEqual(transitionEvents, ['transition:completed', 'publish']);
transitionEvents.length = 0;
assert.strictEqual(guardedStateTransition('active', 'replanning', null, () => { transitionEvents.push('publish'); return true; }).state, 'replanning');
assert.deepStrictEqual(transitionEvents, ['transition:replanning']);
transitionEvents.length = 0;
modeledState = guardedStateTransition('active', 'paused', pauseHandoff, () => { transitionEvents.push('publish-failed'); return false; });
assert.strictEqual(modeledState.state, 'paused');
assert.strictEqual(modeledState.outbox.status, 'pending');
assert.deepStrictEqual(transitionEvents, ['transition:paused', 'publish-failed']);

const blocker = {source_task_id: 'task-a', reason_enum: 'missing-primitive', affected_invariant_id: 'atomicity', prerequisite_or_human_task_id: 'design-a', external_resource_locator: null, policy_gate_locator: null, normalized_bound_values: {time_seconds: null, cost_minor_units: null, currency: null}};
const blockerKey = (value) => digest(blockerFields(value));
const blockerFields = (value) => ({source_task_id: value.source_task_id, reason_enum: value.reason_enum, affected_invariant_id: value.affected_invariant_id, prerequisite_or_human_task_id: value.prerequisite_or_human_task_id, external_resource_locator: value.external_resource_locator, policy_gate_locator: value.policy_gate_locator, normalized_bound_values: value.normalized_bound_values});
const firstKey = blockerKey(blocker);
assert.strictEqual(firstKey, blockerKey({...blocker, wording: 'rephrased'}));
assert.notStrictEqual(firstKey, blockerKey({...blocker, affected_invariant_id: 'different'}));

const adoption = [{old_run_id: 'run-a', old_plan_hash: 'hash-a', source_task_id: 'task-a', artifact_revision: 'artifact-a', destination_task_id: 'task-b', destination_lineage: 'carried-forward', invalidated_evidence_ids: ['evidence-a'], invalidated_pass_ids: ['pass-a'], fresh_conformance_pass: 'PASS'}];
assert.strictEqual(adoption[0].fresh_conformance_pass, 'PASS');
assert.notStrictEqual(digest(adoption), digest(adoption.map((row) => ({...row, artifact_revision: 'artifact-b'}))));
assert.throws(() => adoption.map((row) => ({...row, fresh_conformance_pass: 'REVISE'})).filter((row) => row.fresh_conformance_pass !== 'PASS').forEach(() => { throw new Error('no fresh PASS'); }));

assert.deepStrictEqual(occurrenceKeys.slice().sort(scalarCompare), ['action_kind', 'amount_currency', 'audience', 'environment', 'evidence', 'occurrence_key', 'owner_approval_rule', 'parameters', 'target', 'task_id', 'wake_predicate'].sort(scalarCompare));
assert.strictEqual(baseMandate.protected_actions_authorized, false);

function mutateCanonical(children) {
  assert(children.every((child) => !child.claimed || child.quiescent));
  return true;
}
assert.throws(() => mutateCanonical([{claimed: true, quiescent: false}]));
assert.strictEqual(mutateCanonical([{claimed: true, quiescent: true}]), true);

function cutoverFixture() {
  let phase = 'active';
  const children = new Map([['child-a', {finished: false}], ['child-b', {finished: false}]]);
  return {
    phase: () => phase,
    replan: () => { assert.strictEqual(phase, 'active'); phase = 'replanning'; },
    claim: () => { assert.notStrictEqual(phase, 'replanning'); },
    finish: (id) => { assert.strictEqual(phase, 'replanning'); assert(children.has(id)); children.get(id).finished = true; },
    fenceAndQuiesce: () => {
      assert.strictEqual(phase, 'replanning');
      assert([...children.values()].every((child) => child.finished));
      phase = 'quiescent';
    },
    reviewAdoption: (adoption, draft) => { assert.strictEqual(phase, 'quiescent'); assert(adoption.persisted && adoption.read_back && adoption.independent_review); assert(draft.persisted && draft.read_back && draft.independent_review); phase = 'adoption-reviewed'; },
    readyReplacement: (checks) => { assert.strictEqual(phase, 'adoption-reviewed'); assert.deepStrictEqual(checks, ['feasibility', 'source', 'verifier', 'equality', 'fingerprint', 'conformance']); phase = 'replacement-ready'; },
    supersede: () => { assert.strictEqual(phase, 'replacement-ready'); phase = 'superseded'; },
    startNew: () => { assert.strictEqual(phase, 'superseded'); phase = 'new-active'; }
  };
}
const cutover = cutoverFixture();
cutover.replan();
assert.strictEqual(cutover.phase(), 'replanning');
assert.throws(() => cutover.claim());
assert.throws(() => cutover.supersede());
cutover.finish('child-a');
assert.throws(() => cutover.fenceAndQuiesce());
cutover.finish('child-b');
cutover.fenceAndQuiesce();
assert.strictEqual(cutover.phase(), 'quiescent');
assert.throws(() => cutover.supersede());
cutover.reviewAdoption({persisted: true, read_back: true, independent_review: true}, {persisted: true, read_back: true, independent_review: true});
assert.strictEqual(cutover.phase(), 'adoption-reviewed');
assert.throws(() => cutover.supersede());
cutover.readyReplacement(['feasibility', 'source', 'verifier', 'equality', 'fingerprint', 'conformance']);
cutover.supersede();
assert.strictEqual(cutover.phase(), 'superseded');
cutover.startNew();
assert.strictEqual(cutover.phase(), 'new-active');

const creationKeys = ['run_id', 'subject_kind', 'subject_id', 'attempt_id', 'role', 'route', 'target', 'artifact_revision', 'role_packet_digest'];
const creationIdentityKeys = ['schema', 'creation_key', 'role_packet', 'creation_token', 'creator_owner_epoch'];
const nativeCreationSchema = 'octoplan-native-creation-v3';
function validateNativeCreationSchema(manifest) {
  assert(manifest && typeof manifest === 'object' && !Array.isArray(manifest));
  assert.strictEqual(manifest.native_creation_schema, nativeCreationSchema);
  return true;
}
assert(validateNativeCreationSchema({native_creation_schema: nativeCreationSchema}));
assert.throws(() => validateNativeCreationSchema({native_creation_schema: 'octoplan-native-creation-v2'}));
assert.throws(() => validateNativeCreationSchema({}));
const capabilityProfiles = {
  supervisor: ['native-context', 'native-create', 'native-ledger'],
  planner: ['native-context'],
  executor: ['native-context', 'native-task'],
  'lead-reviewer': ['native-context', 'native-review'],
  'specialist-reviewer': ['native-context', 'native-review'],
  recovery: ['native-context', 'native-task'],
  'follow-up': ['native-context']
};
const rolePacketKeys = ['organization', 'workspace', 'work_stream_id', 'task_id', 'role', 'route', 'target', 'model', 'effort', 'capability_profile', 'capability_rationale', 'capacity_source'];
function validateRolePacket(packet, planningTarget = plannerProjectTarget) {
  assert.deepStrictEqual(Object.keys(packet).sort(scalarCompare), rolePacketKeys.slice().sort(scalarCompare));
  for (const key of ['organization', 'workspace', 'work_stream_id', 'role', 'route', 'model', 'effort', 'capability_rationale']) nonEmpty(packet[key]);
  assert(packet.task_id === null || (typeof packet.task_id === 'string' && packet.task_id.length > 0));
  assert(creationRoles.has(packet.role));
  validateTarget(packet.target);
  sameProjectIdentity(planningTarget, packet.target);
  assert(Array.isArray(packet.capability_profile));
  assert.deepStrictEqual(packet.capability_profile, capabilityProfiles[packet.role]);
  const normalizedCapacity = normalizeCapacity({model: packet.model, effort: packet.effort, route: packet.route, rationale: packet.capability_rationale, capacity_source: packet.capacity_source}, {sourceRegistry: capacitySourceRegistry});
  assert.strictEqual(normalizedCapacity.model, packet.model);
  assert.strictEqual(normalizedCapacity.effort, packet.effort);
  assert(packet.capacity_source && typeof packet.capacity_source === 'object' && !Array.isArray(packet.capacity_source));
  assert.deepStrictEqual(Object.keys(packet.capacity_source).sort(scalarCompare), ['kind', 'record_id', 'evidence_digest'].sort(scalarCompare));
  assert(new Set(['saved-route', 'incident-delta']).has(packet.capacity_source.kind));
  nonEmpty(packet.capacity_source.record_id);
  assert(/^[a-f0-9]{64}$/.test(packet.capacity_source.evidence_digest));
  if (packet.capacity_source.kind === 'incident-delta') assert(['planner', 'recovery'].includes(packet.role));
  return true;
}
function creationIdentity(subject_kind = 'task', role = 'executor', token = 'token-a', creator_owner_epoch = 3, subject_id = 'task-a', artifact_revision = null, target = plannerProjectTarget) {
  const rolePacket = {
    organization: 'org-a',
    workspace: 'workspace-a',
    work_stream_id: 'stream-a',
    task_id: subject_kind === 'task' ? subject_id : null,
    role,
    route: 'route-a',
    target,
    model: 'gpt-5.6-luna',
    effort: 'max',
    capability_profile: capabilityProfiles[role],
    capability_rationale: 'fixture',
    capacity_source: {kind: 'saved-route', record_id: 'route-a', evidence_digest: 'c'.repeat(64)}
  };
  return {
    schema: nativeCreationSchema,
    creation_key: {
      run_id: 'run-a',
      subject_kind,
      subject_id,
      attempt_id: subject_kind === 'task' ? 'attempt-a' : null,
      role,
      route: 'route-a',
      target,
      artifact_revision,
      role_packet_digest: digest(rolePacket)
    },
    role_packet: rolePacket,
    creation_token: token,
    creator_owner_epoch
  };
}
function validateCreationIdentity(value, planningTarget = plannerProjectTarget) {
  assert.deepStrictEqual(Object.keys(value).sort(scalarCompare), creationIdentityKeys.slice().sort(scalarCompare));
  assert.strictEqual(value.schema, nativeCreationSchema);
  assert.deepStrictEqual(Object.keys(value.creation_key).sort(scalarCompare), creationKeys.slice().sort(scalarCompare));
  nonEmpty(value.creation_key.run_id);
  nonEmpty(value.creation_key.subject_id);
  nonEmpty(value.creation_key.route);
  assert(creationSubjectKinds.has(value.creation_key.subject_kind));
  assert(creationRoles.has(value.creation_key.role));
  validateTarget(value.creation_key.target);
  sameProjectIdentity(planningTarget, value.creation_key.target);
  assert(value.creation_key.attempt_id === null || (typeof value.creation_key.attempt_id === 'string' && value.creation_key.attempt_id.length > 0));
  assert(value.creation_key.artifact_revision === null || (typeof value.creation_key.artifact_revision === 'string' && value.creation_key.artifact_revision.length > 0));
  assert(/^[a-f0-9]{64}$/.test(value.creation_key.role_packet_digest));
  validateRolePacket(value.role_packet, planningTarget);
  assert.strictEqual(value.role_packet.role, value.creation_key.role);
  assert.strictEqual(value.role_packet.route, value.creation_key.route);
  assert.deepStrictEqual(value.role_packet.target, value.creation_key.target);
  assert.strictEqual(value.creation_key.role_packet_digest, digest(value.role_packet));
  assert.strictEqual(value.role_packet.task_id, value.creation_key.subject_kind === 'task' ? value.creation_key.subject_id : null);
  nonEmpty(value.creation_token);
  assert(Number.isInteger(value.creator_owner_epoch) && value.creator_owner_epoch > 0);
  if (value.creation_key.subject_kind === 'task') {
    assert(value.creation_key.attempt_id !== null);
    assert(!['supervisor', 'follow-up'].includes(value.creation_key.role));
  } else {
    assert.strictEqual(value.creation_key.attempt_id, null);
    assert.strictEqual(value.creation_key.role, value.creation_key.subject_kind);
  }
  if (['lead-reviewer', 'specialist-reviewer'].includes(value.creation_key.role)) assert(value.creation_key.artifact_revision !== null);
  return true;
}
function creationKey(value) {
  validateCreationIdentity(value);
  return {schema: value.schema, creation_key: value.creation_key};
}
const executorIdentity = creationIdentity('task', 'executor', 'token-executor', 3);
const plannerIdentity = creationIdentity('task', 'planner', 'token-planner', 3, 'task-a');
const reviewerIdentity = creationIdentity('task', 'lead-reviewer', 'token-reviewer', 3, 'task-a', 'artifact-a');
const specialistIdentity = creationIdentity('task', 'specialist-reviewer', 'token-specialist', 3, 'task-a', 'artifact-a');
const recoveryIdentity = creationIdentity('task', 'recovery', 'token-recovery', 3);
const supervisorIdentity = creationIdentity('supervisor', 'supervisor', 'token-supervisor', 3, 'supervisor-a');
const followUpIdentity = creationIdentity('follow-up', 'follow-up', 'token-follow-up', 3, 'follow-up-a');
const projectIdentities = [executorIdentity, plannerIdentity, reviewerIdentity, specialistIdentity, recoveryIdentity, supervisorIdentity, followUpIdentity];
for (const identity of projectIdentities) {
  assert(validateCreationIdentity(identity));
  assert.throws(() => validateCreationIdentity({...identity, creation_key: {...identity.creation_key, target: parseTarget('project-b · worktree · wrong project').target}}));
}
const stalePacket = {...plannerIdentity, role_packet: {...plannerIdentity.role_packet, workspace: 'workspace-b'}};
assert.throws(() => validateCreationIdentity(stalePacket));
const relocatedPacket = {...plannerIdentity, role_packet: {...plannerIdentity.role_packet, workspace: 'workspace-b'}};
relocatedPacket.creation_key = {...relocatedPacket.creation_key, role_packet_digest: digest(relocatedPacket.role_packet)};
assert(validateCreationIdentity(relocatedPacket));
assert.notDeepStrictEqual(creationKey(relocatedPacket), creationKey(plannerIdentity));
const wrongCapability = {...plannerIdentity, role_packet: {...plannerIdentity.role_packet, capability_profile: capabilityProfiles.executor}};
wrongCapability.creation_key = {...wrongCapability.creation_key, role_packet_digest: digest(wrongCapability.role_packet)};
assert.throws(() => validateCreationIdentity(wrongCapability));
const lowCapacity = {...executorIdentity, role_packet: {...executorIdentity.role_packet, effort: 'xhigh'}};
lowCapacity.creation_key = {...lowCapacity.creation_key, role_packet_digest: digest(lowCapacity.role_packet)};
assert.throws(() => validateCreationIdentity(lowCapacity));
const nonCanonicalCapacity = {...executorIdentity, role_packet: {...executorIdentity.role_packet, model: 'GPT-5.6-LUNA', effort: 'MAX'}};
nonCanonicalCapacity.creation_key = {...nonCanonicalCapacity.creation_key, role_packet_digest: digest(nonCanonicalCapacity.role_packet)};
assert.throws(() => validateCreationIdentity(nonCanonicalCapacity));
const projectlessIdentities = [
  creationIdentity('task', 'executor', 'token-projectless-executor', 3, 'task-projectless', null, plannerProjectlessTarget),
  creationIdentity('task', 'planner', 'token-projectless-planner', 3, 'task-projectless', null, plannerProjectlessTarget),
  creationIdentity('task', 'lead-reviewer', 'token-projectless-reviewer', 3, 'task-projectless', 'artifact-a', plannerProjectlessTarget),
  creationIdentity('task', 'specialist-reviewer', 'token-projectless-specialist', 3, 'task-projectless', 'artifact-a', plannerProjectlessTarget),
  creationIdentity('task', 'recovery', 'token-projectless-recovery', 3, 'task-projectless', null, plannerProjectlessTarget),
  creationIdentity('supervisor', 'supervisor', 'token-projectless-supervisor', 3, 'supervisor-projectless', null, plannerProjectlessTarget),
  creationIdentity('follow-up', 'follow-up', 'token-projectless-follow-up', 3, 'follow-up-projectless', null, plannerProjectlessTarget)
];
for (const identity of projectlessIdentities) {
  assert(validateCreationIdentity(identity, plannerProjectlessTarget));
  assert.throws(() => validateCreationIdentity(identity, plannerProjectTarget));
}

const plannerPacket = {
  organization: 'org-a', workspace: 'workspace-a', work_stream_id: 'stream-a', task_id: 'task-a', role: 'planner',
  route: 'recovery-route-a', target: plannerProjectTarget, model: 'gpt-5.6-luna', effort: 'max', capability_profile: capabilityProfiles.planner, capability_rationale: 'incident-detection',
  capacity_source: {kind: 'incident-delta', record_id: 'delta-a', evidence_digest: 'd'.repeat(64)}
};
assert(validateRolePacket(plannerPacket, plannerProjectTarget));
assert.throws(() => validateRolePacket({...plannerPacket, target: parseTarget('project-b · worktree · wrong project').target}, plannerProjectTarget));
function assignRole(role, substrate) {
  if (role === 'pre-run-plan-review') {
    assert.strictEqual(substrate.kind, 'analytical');
    assert(substrate.capabilities.has('read-only-plan-review'));
    return {kind: 'verdict-artifact-only', canPersist: false, canClaim: false, canLaunch: false};
  }
  assert(capabilityProfiles[role]);
  if (substrate.kind === 'analytical') return {kind: 'proposal-only'};
  assert(capabilityProfiles[role].every((capability) => substrate.capabilities.has(capability)));
  return {kind: 'native'};
}
assert.deepStrictEqual(assignRole('supervisor', {kind: 'native', capabilities: new Set(['native-context', 'native-ledger', 'native-create'])}), {kind: 'native'});
assert.deepStrictEqual(assignRole('planner', {kind: 'analytical', capabilities: new Set()}), {kind: 'proposal-only'});
assert.deepStrictEqual(assignRole('pre-run-plan-review', {kind: 'analytical', capabilities: new Set(['read-only-plan-review'])}), {kind: 'verdict-artifact-only', canPersist: false, canClaim: false, canLaunch: false});
assert.throws(() => assignRole('pre-run-plan-review', {kind: 'native', capabilities: new Set(['native-review'])}));
assert.throws(() => assignRole('lead-reviewer', {kind: 'native', capabilities: new Set(['native-context'])}));
function persistReviewArtifact(actor, artifact) {
  assert(['planner', 'supervisor'].includes(actor));
  assert(Object.isFrozen(artifact) && ['PASS', 'REVISE', 'INFEASIBLE', 'HUMAN_DECISION'].includes(artifact.verdict));
  return true;
}
const immutablePlanReview = Object.freeze({verdict: 'PASS', evidence_digest: 'e'.repeat(64)});
assert(persistReviewArtifact('planner', immutablePlanReview));
assert(persistReviewArtifact('supervisor', immutablePlanReview));
assert.throws(() => persistReviewArtifact('pre-run-plan-review', immutablePlanReview));
assert.throws(() => persistReviewArtifact('lead-reviewer', immutablePlanReview));

function resolveIncident({compliantPath, evidence, userAsked}) {
  if (compliantPath) {
    assert.strictEqual(userAsked, false);
    return 'continue-or-replan';
  }
  assert(evidence && evidence.no_compliant_path === true);
  assert(Array.isArray(evidence.checked_routes) && evidence.checked_routes.length > 0);
  assert(Array.isArray(evidence.failed_criteria) && evidence.failed_criteria.length > 0);
  nonEmpty(evidence.capability_environment);
  nonEmpty(evidence.protected_action_boundary);
  assert.strictEqual(userAsked, true);
  return 'human-decision';
}
const noPathEvidence = {no_compliant_path: true, checked_routes: ['saved-route', 'fallback'], failed_criteria: ['native-capability'], capability_environment: 'native tools absent', protected_action_boundary: 'unchanged'};
assert.strictEqual(resolveIncident({compliantPath: true, userAsked: false}), 'continue-or-replan');
assert.strictEqual(resolveIncident({compliantPath: false, evidence: noPathEvidence, userAsked: true}), 'human-decision');
assert.throws(() => resolveIncident({compliantPath: false, evidence: {no_compliant_path: true}, userAsked: true}));
assert.throws(() => resolveIncident({compliantPath: true, evidence: noPathEvidence, userAsked: true}));

function validateTaskGranularity(task) {
  const taskKeys = ['id', 'work_stream_id', 'parent_task_id', 'title', 'description', 'dependencies', 'assignment', 'impact', 'impact_rationale', 'routes'];
  assert.deepStrictEqual(Object.keys(task).sort(scalarCompare), taskKeys.slice().sort(scalarCompare));
  assert(nonEmpty(task.id));
  assert(nonEmpty(task.title));
  assert(task.description.includes('Why:') && task.description.includes('What:') && task.description.includes('Done when:'));
  const what = task.description.match(/^What:\s*(.*)$/m);
  const deliverableNoun = /\b(artifact|matrix|report|implementation|decision|file|page|configuration|plan|release)\b/i;
  const operationalOnly = /\b(access|session|connection|login|endpoint|object|service)\b/i.test(what ? what[1] : '') && !deliverableNoun.test(what ? what[1] : '');
  assert(what && !/^(open|connect|log in|login|inspect|run|call|probe|check|verify|validate|confirm)\b/i.test(what[1].trim()));
  assert(!operationalOnly);
  assert(Array.isArray(task.dependencies));
  assert(nonEmpty(task.assignment));
  assert(Number.isInteger(task.impact) && task.impact >= 1 && task.impact <= 5);
  assert(nonEmpty(task.impact_rationale));
  assert(task.routes && nonEmpty(task.routes.exec) && nonEmpty(task.routes.review));
  return true;
}
const granularityRoutes = {exec: 'executor-route', review: 'review-route', review_route: null, specialist_review_route: null, fallback: null, recovery_override: null, lineage_override: null, parallel_safe_with: []};
assert.throws(() => validateTaskGranularity({id: 'task-login', work_stream_id: null, parent_task_id: null, title: 'Connect service', description: 'Why: access is needed\nWhat: Log in to service\nDone when: session exists', dependencies: [], assignment: 'agent', impact: 1, impact_rationale: 'preflight', routes: granularityRoutes}));
assert.throws(() => validateTaskGranularity({id: 'task-access', work_stream_id: null, parent_task_id: null, title: 'Check OAuth access', description: 'Why: access is needed\nWhat: Check OAuth access\nDone when: access exists', dependencies: [], assignment: 'agent', impact: 1, impact_rationale: 'probe', routes: granularityRoutes}));
assert.throws(() => validateTaskGranularity({id: 'task-verify', work_stream_id: null, parent_task_id: null, title: 'Verify report', description: 'Why: evidence matters\nWhat: Verify the report\nDone when: verification passes', dependencies: [], assignment: 'agent', impact: 1, impact_rationale: 'procedural', routes: granularityRoutes}));
assert.throws(() => validateTaskGranularity({id: 'task-impact', work_stream_id: null, parent_task_id: null, title: 'Produce report', description: 'Why: evidence matters\nWhat: Produce the report\nDone when: review passes', dependencies: [], assignment: 'agent', impact: '5', impact_rationale: 'typed wrong', routes: granularityRoutes}));
assert.throws(() => validateTaskGranularity({id: 'task-rationale', work_stream_id: null, parent_task_id: null, title: 'Produce report', description: 'Why: evidence matters\nWhat: Produce the report\nDone when: review passes', dependencies: [], assignment: 'agent', impact: 5, impact_rationale: ' ', routes: granularityRoutes}));
assert(validateTaskGranularity({id: 'task-deliverable', work_stream_id: null, parent_task_id: null, title: 'Produce matrix', description: 'Why: the decision needs evidence\nWhat: Produce a verified matrix\nDone when: independent review passes', dependencies: [], assignment: 'agent', impact: 2, impact_rationale: 'bounded deliverable', routes: granularityRoutes}));

assert.strictEqual(new Set(projectIdentities.map((identity) => identity.creation_token)).size, projectIdentities.length);
assert.notStrictEqual(executorIdentity.creation_token, reviewerIdentity.creation_token);
assert.strictEqual(creationKey(executorIdentity).creation_key.creator_owner_epoch, undefined);
assert.deepStrictEqual(creationKey(executorIdentity), creationKey({...executorIdentity, creation_token: 'different-token', creator_owner_epoch: 9}));
function creationPrompt(identity) {
  return `OCTOPLAN_CREATION ${stable(identity)}`;
}
function parseCreationPrompt(line, planningTarget = plannerProjectTarget) {
  const prefix = 'OCTOPLAN_CREATION ';
  assert(line.startsWith(prefix));
  const suffix = line.slice(prefix.length);
  const parsed = JSON.parse(suffix);
  assert.strictEqual(stable(parsed), suffix);
  validateCreationIdentity(parsed, planningTarget);
  return parsed;
}
const creationPromptLine = creationPrompt(executorIdentity);
assert.strictEqual(creationPromptLine, `OCTOPLAN_CREATION ${stable(executorIdentity)}`);
assert.deepStrictEqual(parseCreationPrompt(creationPromptLine), executorIdentity);
const projectlessPromptLine = creationPrompt(projectlessIdentities[0]);
assert.deepStrictEqual(parseCreationPrompt(projectlessPromptLine, plannerProjectlessTarget), projectlessIdentities[0]);
assert.throws(() => parseCreationPrompt(projectlessPromptLine, plannerProjectTarget));
assert.throws(() => parseCreationPrompt(`OCTOPLAN_CREATION  ${stable(executorIdentity)}`));
assert.throws(() => parseCreationPrompt(`OCTOPLAN_CREATION\t${stable(executorIdentity)}`));
assert.throws(() => parseCreationPrompt(`prefix OCTOPLAN_CREATION ${stable(executorIdentity)}`));
assert.throws(() => validateCreationIdentity({...executorIdentity, creation_token: ''}));
assert.throws(() => validateCreationIdentity({...executorIdentity, creator_owner_epoch: 0}));
assert.throws(() => validateCreationIdentity({...executorIdentity, creation_key: {...executorIdentity.creation_key, attempt_id: null}}));
assert.throws(() => validateCreationIdentity({...reviewerIdentity, creation_key: {...reviewerIdentity.creation_key, artifact_revision: null}}));
assert.throws(() => validateCreationIdentity({...executorIdentity, creation_key: {...executorIdentity.creation_key, target: parseTarget('project-b · worktree · wrong project').target}}));

function createSession(response, expectedIdentity = executorIdentity, planningTarget = plannerProjectTarget, nativeObservation = null, publishHandoff = (message) => message.includes('État:')) {
  validateCreationIdentity(expectedIdentity, planningTarget);
  const nativeProject = nativeObservation ?? (planningTarget.kind === 'project'
    ? {nativeHandle: `native-${planningTarget.project_id}`}
    : {nativeHandle: `native-projectless-${planningTarget.directory_name}`});
  let currentOwnerEpoch = expectedIdentity.creator_owner_epoch;
  let calls = 0;
  let intentWritten = false;
  let state = 'intent';
  let wake = null;
  let handoffCount = 0;
  const outbox = [];
  const receipts = new Set();
  const guardEpoch = (actorEpoch) => { assert.strictEqual(actorEpoch, currentOwnerEpoch); };
  const transition = (actorEpoch, nextState, nextWake) => {
    guardEpoch(actorEpoch);
    state = nextState;
    wake = nextWake;
  };
  const writeIntent = (actorEpoch = currentOwnerEpoch) => { guardEpoch(actorEpoch); assert.strictEqual(state, 'intent'); intentWritten = true; };
  const create = (actorEpoch = currentOwnerEpoch) => {
    guardEpoch(actorEpoch);
    assert.strictEqual(intentWritten, true);
    assert.strictEqual(state, 'intent');
    calls += 1;
    assert.strictEqual(calls, 1);
    state = 'pending';
    wake = 'reconcile-native-session';
    return response;
  };
  const prepareAttention = (expectedState, values) => {
    const message = makeHandoff(values);
    assertHandoffState(expectedState, values);
    return message;
  };
  const transitionWithOutbox = (actorEpoch, nextState, nextWake, message) => {
    guardEpoch(actorEpoch);
    const eventId = digest({nextState, nextWake, message, sequence: outbox.length});
    state = nextState;
    wake = nextWake;
    outbox.push({eventId, message, status: 'pending'});
    return eventId;
  };
  const retryOutbox = () => {
    const event = outbox.find((item) => item.status === 'pending');
    if (!event) return false;
    if (receipts.has(event.eventId)) { event.status = 'sent'; return false; }
    if (publishHandoff(event.message) !== true) return false;
    receipts.add(event.eventId);
    event.status = 'sent';
    handoffCount += 1;
    return true;
  };
  const pause = (actorEpoch, nextWake, values = pauseHandoff, publishNow = true) => {
    const message = prepareAttention('paused', values);
    transitionWithOutbox(actorEpoch, 'paused', nextWake, message);
    if (publishNow) retryOutbox();
  };
  const reconcile = (matches, actorEpoch = currentOwnerEpoch) => {
    assert(['pending', 'paused'].includes(state));
    assert(Array.isArray(matches));
    const exact = matches.filter((match) => {
      try {
        validateCreationIdentity(match, planningTarget);
        return stable(match) === stable(expectedIdentity);
      } catch (_) {
        return false;
      }
    });
    if (matches.length === 0) {
      transition(actorEpoch, 'pending', 'reconcile-native-session');
    } else if (matches.length === 1 && exact.length === 1) {
      const projectResult = reconcileNativeProject(planningTarget, nativeProject, pauseHandoff);
      if (projectResult.state === 'paused') {
        transitionWithOutbox(actorEpoch, 'paused', 'native-project-identity-handoff', projectResult.message);
        retryOutbox();
        return;
      }
      transition(actorEpoch, 'ready', null);
    } else {
      pause(actorEpoch, 'human-or-reconciliation-evidence');
    }
  };
  const exhaust = (actorEpoch = currentOwnerEpoch) => {
    assert.strictEqual(state, 'pending');
    pause(actorEpoch, 'human-or-reconciliation-evidence');
  };
  const resume = (actorEpoch = currentOwnerEpoch) => {
    assert(['pending', 'paused'].includes(state));
    transition(actorEpoch, 'pending', 'reconcile-native-session');
  };
  const waitHuman = (actorEpoch = currentOwnerEpoch, values = waitingHumanHandoff, publishNow = true) => {
    const message = prepareAttention('waiting-human', values);
    transitionWithOutbox(actorEpoch, 'waiting-human', 'human-decision', message);
    if (publishNow) retryOutbox();
  };
  const complete = (actorEpoch = currentOwnerEpoch, values = finalHandoff, publishNow = true) => {
    const message = prepareAttention('completed', values);
    transitionWithOutbox(actorEpoch, 'completed', null, message);
    if (publishNow) retryOutbox();
  };
  const activate = (actorEpoch = currentOwnerEpoch, currentNativeProject = nativeProject) => {
    assert.strictEqual(state, 'ready');
    const projectResult = reconcileNativeProject(planningTarget, currentNativeProject, pauseHandoff);
    if (projectResult.state === 'paused') {
      transitionWithOutbox(actorEpoch, 'paused', 'native-project-identity-handoff', projectResult.message);
      retryOutbox();
      return;
    }
    transition(actorEpoch, 'activated', null);
  };
  const lateWrite = (actorEpoch) => { guardEpoch(actorEpoch); };
  const takeover = (actorEpoch = currentOwnerEpoch) => {
    guardEpoch(actorEpoch);
    currentOwnerEpoch += 1;
    return currentOwnerEpoch;
  };
  return {identity: () => expectedIdentity, writeIntent, create, reconcile, exhaust, resume, waitHuman, complete, retryOutbox, activate, lateWrite, takeover, ownerEpoch: () => currentOwnerEpoch, calls: () => calls, handoffs: () => handoffCount, pendingOutbox: () => outbox.filter((event) => event.status === 'pending').length, state: () => state, wake: () => wake};
}

function canonicalReviewSubject(plan) {
  const subject = JSON.parse(JSON.stringify(plan));
  delete subject.manifest.plan_review;
  subject.plan_hash = 'PENDING';
  return subject;
}
function normalizedJourneyPlan(plan) {
  const normalized = JSON.parse(JSON.stringify(plan));
  normalized.plan_hash = 'PENDING';
  normalized.manifest.plan_review.final_binding.plan_hash = 'PENDING';
  return normalized;
}
function governedJourney({mode, initialGrant = null, openQuestions = 1, nativeTaskCreationAuthoritySource = null}) {
  assert(['Review before delivery', 'Autonomous delivery'].includes(mode));
  let phase = 'idea';
  let questions = openQuestions;
  let confirmed = false;
  let candidate = null;
  let candidateRecords = [];
  let planReviewer = null;
  let reviewArtifact = null;
  let draftPlan = null;
  let sealedPlan = null;
  let sealedEntry = null;
  let planHash = null;
  let consentHash = null;
  let bindingWritten = false;
  let nativeCreates = 0;
  const brief = () => { assert.strictEqual(phase, 'idea'); phase = mode === 'Autonomous delivery' && stable(initialGrant) === stable(completeNoLoopGrant) ? 'checkpoint' : 'brief-wait'; };
  const answerAllAndAcceptMode = () => { assert.strictEqual(phase, 'brief-wait'); questions = 0; confirmed = true; phase = 'confirmed'; };
  const continueCheckpoint = () => { assert.strictEqual(phase, 'checkpoint'); assert(stable(initialGrant) === stable(completeNoLoopGrant)); confirmed = true; phase = 'confirmed'; };
  const preflight = () => {
    assert.strictEqual(phase, 'confirmed');
    assert.strictEqual(questions, 0);
    const runway = executionRunway({currentProjectId: 'project-a', intendedProjectIds: ['project-a'], deliveryMode: mode, briefConfirmed: confirmed, checkpointPublished: true, nativeTaskCreationRequired: true, nativeTaskCreationAuthoritySource, relocationAuthoritySource: null, capabilities: fullRunwayCapabilities});
    assert.strictEqual(runway.state, 'READY_TO_DRAFT');
    phase = 'drafting';
  };
  const challengeOffRecord = () => {
    assert.strictEqual(phase, 'drafting');
    planReviewer = Object.freeze({id: 'fresh-plan-reviewer-a', pack: 'plan-reviewer', nativeActor: false});
    phase = 'challenged';
  };
  const persist = (evidence = fullPersistenceEvidence) => {
    assert.strictEqual(phase, 'challenged');
    assert.strictEqual(persistenceGate(evidence).state, 'READY_TO_PERSIST');
    const journal = candidateJournal([{kind: 'stream', id: 'stream-a'}, {kind: 'decision', id: 'decision-a'}, {kind: 'task', id: 'task-a'}]);
    for (let index = 0; index < 3; index += 1) { journal.writeCurrent(); journal.advance(); }
    candidate = journal.root();
    candidateRecords = journal.records();
    validateCandidate(candidate);
    phase = 'candidate';
  };
  const crash = () => { assert.strictEqual(phase, 'candidate'); phase = 'crashed'; };
  const resume = () => { assert.strictEqual(phase, 'crashed'); assert.strictEqual(classifyEntry({...emptyEntry, candidates: [candidate], candidateRecords}), 'CANDIDATE'); phase = 'candidate'; };
  const reviewAndReadback = () => {
    assert.strictEqual(phase, 'candidate');
    candidate = {...candidate, phase: 'ready-to-seal'};
    assert.strictEqual(classifyEntry({...emptyEntry, candidates: [candidate], candidateRecords}), 'CANDIDATE');
    const deliveryMandate = mode === 'Autonomous delivery' ? noLoopMandate : baseMandate;
    draftPlan = {fingerprint_schema: FINGERPRINT, ledger_task_id: 'ledger-a', plan_hash: 'PENDING', manifest: {native_creation_schema: 'octoplan-native-creation-v3', supervision_contract: {schema: SUPERVISION}, delivery_mandate: deliveryMandate, plan_review: null}, streams: [{id: 'stream-a'}], decisions: [{id: 'decision-a'}], questions: [], tasks: [{id: 'task-a'}], protected_occurrences: []};
    const subjectDigest = digest(canonicalReviewSubject(draftPlan));
    assert(planReviewer && planReviewer.pack === 'plan-reviewer' && planReviewer.nativeActor === false);
    reviewArtifact = Object.freeze({reviewer_id: planReviewer.id, subject_digest: subjectDigest, verdict: 'PASS', evidence_digest: digest({subjectDigest, evidence: 'independent-source-first-review'})});
    phase = 'reviewed';
  };
  const seal = (guardSucceeded = true) => {
    assert.strictEqual(phase, 'reviewed');
    assert.strictEqual(guardSucceeded, true);
    const planReview = {reviewed_draft_digest: reviewArtifact.subject_digest, feasibility_matrix_digest: 'f'.repeat(64), lead: 'pre-run-plan-review', specialist: null, verdict: reviewArtifact.verdict, mandate_conformance: 'PASS', review_pass: reviewArtifact.evidence_digest, final_binding: {plan_hash: 'PENDING', saved_state_equality: true, critical_sources_and_verifiers: 'PASS'}};
    assert.strictEqual(planReview.reviewed_draft_digest, digest(canonicalReviewSubject(draftPlan)));
    sealedPlan = {...draftPlan, manifest: {...draftPlan.manifest, plan_review: planReview}};
    planHash = digest(normalizedJourneyPlan(sealedPlan));
    sealedPlan = {...sealedPlan, plan_hash: planHash, manifest: {...sealedPlan.manifest, plan_review: {...planReview, final_binding: {...planReview.final_binding, plan_hash: planHash}}}};
    candidate = null;
    candidateRecords = [];
    sealedEntry = {...emptyEntry, supervisions: [SUPERVISION], fingerprints: [FINGERPRINT], mandates: [sealedPlan.manifest.delivery_mandate], nativeSchemas: ['octoplan-native-creation-v3']};
    assert(validateSupportedPair(sealedEntry));
    assert.strictEqual(digest(normalizedJourneyPlan(sealedPlan)), planHash);
    phase = 'sealed';
  };
  const consent = (hash) => { assert.strictEqual(phase, 'sealed'); consentHash = hash; phase = 'consented'; };
  const driftAfterConsent = () => { assert.strictEqual(phase, 'consented'); sealedPlan = {...sealedPlan, streams: [...sealedPlan.streams, {id: 'stream-drift'}]}; };
  const bind = (guardSucceeded) => {
    assert.strictEqual(phase, mode === 'Autonomous delivery' ? 'sealed' : 'consented');
    assert(validateSupportedPair(sealedEntry));
    assert.strictEqual(digest(normalizedJourneyPlan(sealedPlan)), planHash);
    assert.strictEqual(mode === 'Autonomous delivery' ? planHash : consentHash, planHash);
    assert.strictEqual(guardSucceeded, true);
    bindingWritten = true;
    phase = 'bound';
  };
  const launch = () => {
    assert.strictEqual(phase, 'bound');
    assert(bindingWritten && reviewArtifact.verdict === 'PASS' && questions === 0 && validateSupportedPair(sealedEntry));
    const session = createSession('direct', executorIdentity);
    session.writeIntent(); session.create(); nativeCreates += 1; session.reconcile([executorIdentity]); session.activate(3);
    assert.strictEqual(session.state(), 'activated'); phase = 'launched';
  };
  return {phase: () => phase, entryState: () => sealedEntry === null ? classifyEntry({...emptyEntry, candidates: candidate === null ? [] : [candidate], candidateRecords}) : classifyEntry(sealedEntry), planHash: () => planHash, nativeCreates: () => nativeCreates, brief, answerAllAndAcceptMode, continueCheckpoint, preflight, challengeOffRecord, persist, crash, resume, reviewAndReadback, seal, consent, driftAfterConsent, bind, launch};
}

const journeyNativeAuthority = runwayAuthority('journey-native-authority', 'c');
const noNativeAuthorityJourney = governedJourney({mode: 'Review before delivery', openQuestions: 0});
noNativeAuthorityJourney.brief(); noNativeAuthorityJourney.answerAllAndAcceptMode();
assert.throws(noNativeAuthorityJourney.preflight);
assert.strictEqual(noNativeAuthorityJourney.entryState(), 'GREENFIELD');
assert.strictEqual(noNativeAuthorityJourney.nativeCreates(), 0);
const defaultJourney = governedJourney({mode: 'Review before delivery', nativeTaskCreationAuthoritySource: journeyNativeAuthority});
defaultJourney.brief();
assert.throws(defaultJourney.preflight);
assert.strictEqual(defaultJourney.nativeCreates(), 0);
defaultJourney.answerAllAndAcceptMode();
defaultJourney.preflight();
assert.throws(defaultJourney.persist);
defaultJourney.challengeOffRecord(); defaultJourney.persist(); defaultJourney.crash(); defaultJourney.resume(); defaultJourney.reviewAndReadback(); defaultJourney.seal();
assert.strictEqual(defaultJourney.entryState(), 'SUPPORTED');
assert.strictEqual(defaultJourney.nativeCreates(), 0);
const failedSealJourney = governedJourney({mode: 'Review before delivery', openQuestions: 0, nativeTaskCreationAuthoritySource: journeyNativeAuthority});
failedSealJourney.brief(); failedSealJourney.answerAllAndAcceptMode(); failedSealJourney.preflight(); failedSealJourney.challengeOffRecord(); failedSealJourney.persist(); failedSealJourney.reviewAndReadback();
assert.throws(() => failedSealJourney.seal(false));
assert.strictEqual(failedSealJourney.entryState(), 'CANDIDATE');
assert.strictEqual(failedSealJourney.nativeCreates(), 0);
const staleHashJourney = governedJourney({mode: 'Review before delivery', openQuestions: 0, nativeTaskCreationAuthoritySource: journeyNativeAuthority});
staleHashJourney.brief(); staleHashJourney.answerAllAndAcceptMode(); staleHashJourney.preflight(); staleHashJourney.challengeOffRecord(); staleHashJourney.persist(); staleHashJourney.reviewAndReadback(); staleHashJourney.seal(); staleHashJourney.consent('e'.repeat(64));
assert.throws(() => staleHashJourney.bind(true));
assert.strictEqual(staleHashJourney.nativeCreates(), 0);
const driftJourney = governedJourney({mode: 'Review before delivery', openQuestions: 0, nativeTaskCreationAuthoritySource: journeyNativeAuthority});
driftJourney.brief(); driftJourney.answerAllAndAcceptMode(); driftJourney.preflight(); driftJourney.challengeOffRecord(); driftJourney.persist(); driftJourney.reviewAndReadback(); driftJourney.seal(); driftJourney.consent(driftJourney.planHash()); driftJourney.driftAfterConsent();
assert.throws(() => driftJourney.bind(true));
assert.strictEqual(driftJourney.nativeCreates(), 0);
const failedGuardJourney = governedJourney({mode: 'Review before delivery', openQuestions: 0, nativeTaskCreationAuthoritySource: journeyNativeAuthority});
failedGuardJourney.brief(); failedGuardJourney.answerAllAndAcceptMode(); failedGuardJourney.preflight(); failedGuardJourney.challengeOffRecord(); failedGuardJourney.persist(); failedGuardJourney.reviewAndReadback(); failedGuardJourney.seal(); failedGuardJourney.consent(failedGuardJourney.planHash());
assert.throws(() => failedGuardJourney.bind(false));
assert.strictEqual(failedGuardJourney.nativeCreates(), 0);
const successfulJourney = governedJourney({mode: 'Review before delivery', openQuestions: 0, nativeTaskCreationAuthoritySource: journeyNativeAuthority});
successfulJourney.brief(); successfulJourney.answerAllAndAcceptMode(); successfulJourney.preflight(); successfulJourney.challengeOffRecord(); successfulJourney.persist(); successfulJourney.reviewAndReadback(); successfulJourney.seal(); successfulJourney.consent(successfulJourney.planHash()); successfulJourney.bind(true); successfulJourney.launch();
assert.strictEqual(successfulJourney.nativeCreates(), 1);
const autonomousJourney = governedJourney({mode: 'Autonomous delivery', initialGrant: completeNoLoopGrant, openQuestions: 0, nativeTaskCreationAuthoritySource: runwayAuthority('initial-no-loop-source', 'd')});
autonomousJourney.brief(); autonomousJourney.continueCheckpoint(); autonomousJourney.preflight(); autonomousJourney.challengeOffRecord(); autonomousJourney.persist(); autonomousJourney.reviewAndReadback(); autonomousJourney.seal(); autonomousJourney.bind(true); autonomousJourney.launch();
assert.strictEqual(autonomousJourney.nativeCreates(), 1);

for (const response of ['client', 'direct', 'empty', 'crash', 'no-response']) {
  const session = createSession(response, executorIdentity);
  assert.deepStrictEqual(session.identity(), executorIdentity);
  session.writeIntent();
  assert.strictEqual(session.state(), 'intent');
  assert.strictEqual(session.create(), response);
  session.reconcile([]);
  assert.strictEqual(session.state(), 'pending');
  assert(session.wake());
  assert.strictEqual(session.calls(), 1);
  assert.throws(() => session.create());
  session.exhaust();
  assert.strictEqual(session.state(), 'paused');
  assert.strictEqual(session.handoffs(), 1);
  assert(session.wake());
}
const exact = createSession('direct', executorIdentity);
exact.writeIntent();
exact.create();
exact.reconcile([executorIdentity]);
assert.strictEqual(exact.state(), 'ready');
assert.throws(() => exact.activate(1));
assert.throws(() => exact.activate(2));
exact.activate(3);
assert.strictEqual(exact.state(), 'activated');
assert.strictEqual(exact.handoffs(), 0);
assert.throws(() => exact.lateWrite(1));
assert.throws(() => exact.lateWrite(2));
const humanGate = createSession('direct', executorIdentity);
humanGate.writeIntent();
humanGate.create();
humanGate.reconcile([executorIdentity]);
humanGate.waitHuman();
assert.strictEqual(humanGate.state(), 'waiting-human');
assert.strictEqual(humanGate.handoffs(), 1);
const wrongHumanGate = createSession('direct', executorIdentity);
wrongHumanGate.writeIntent();
wrongHumanGate.create();
wrongHumanGate.reconcile([executorIdentity]);
assert.throws(() => wrongHumanGate.waitHuman(3, pauseHandoff));
assert.strictEqual(wrongHumanGate.state(), 'ready');
assert.strictEqual(wrongHumanGate.handoffs(), 0);
const failedHumanHandoff = createSession('direct', executorIdentity, plannerProjectTarget, null, () => false);
failedHumanHandoff.writeIntent();
failedHumanHandoff.create();
failedHumanHandoff.reconcile([executorIdentity]);
failedHumanHandoff.waitHuman();
assert.strictEqual(failedHumanHandoff.state(), 'waiting-human');
assert.strictEqual(failedHumanHandoff.handoffs(), 0);
assert.strictEqual(failedHumanHandoff.pendingOutbox(), 1);
let publicationAvailable = false;
const crashBeforePublication = createSession('direct', executorIdentity, plannerProjectTarget, null, () => publicationAvailable);
crashBeforePublication.writeIntent();
crashBeforePublication.create();
crashBeforePublication.reconcile([executorIdentity]);
crashBeforePublication.waitHuman(undefined, waitingHumanHandoff, false); // durable state and pending event survive before publish
assert.strictEqual(crashBeforePublication.state(), 'waiting-human');
assert.strictEqual(crashBeforePublication.pendingOutbox(), 1);
assert.strictEqual(crashBeforePublication.handoffs(), 0);
assert.strictEqual(crashBeforePublication.retryOutbox(), false);
publicationAvailable = true;
assert.strictEqual(crashBeforePublication.retryOutbox(), true);
assert.strictEqual(crashBeforePublication.pendingOutbox(), 0);
assert.strictEqual(crashBeforePublication.handoffs(), 1);
assert.strictEqual(crashBeforePublication.retryOutbox(), false); // receipt makes retry idempotent
assert.strictEqual(crashBeforePublication.handoffs(), 1);
const completedSession = createSession('direct', executorIdentity);
completedSession.writeIntent();
completedSession.create();
completedSession.reconcile([executorIdentity]);
completedSession.complete();
assert.strictEqual(completedSession.state(), 'completed');
assert.strictEqual(completedSession.handoffs(), 1);
const failedCompletion = createSession('direct', executorIdentity, plannerProjectTarget, null, () => false);
failedCompletion.writeIntent();
failedCompletion.create();
failedCompletion.reconcile([executorIdentity]);
failedCompletion.complete();
assert.strictEqual(failedCompletion.state(), 'completed');
assert.strictEqual(failedCompletion.handoffs(), 0);
assert.strictEqual(failedCompletion.pendingOutbox(), 1);
const takeover = createSession('direct', executorIdentity);
takeover.writeIntent();
takeover.create();
takeover.reconcile([executorIdentity]);
assert.strictEqual(takeover.state(), 'ready');
assert.strictEqual(takeover.ownerEpoch(), 3);
const takeoverIdentityBytes = stable(takeover.identity());
assert.strictEqual(takeover.takeover(3), 4);
assert.strictEqual(takeover.ownerEpoch(), 4);
assert.strictEqual(stable(takeover.identity()), takeoverIdentityBytes);
assert.throws(() => takeover.activate(3));
assert.throws(() => takeover.lateWrite(3));
takeover.activate(4);
assert.strictEqual(takeover.state(), 'activated');
function supervisorObservation(status, overrides = {}) {
  return {status, source_record_id: 'native-observation-a', source_revision: 'revision-a', evidence_digest: 'e'.repeat(64), wake_attempted: true, terminal_or_unreachable_proven: false, fence_guard_succeeded: false, owner_epoch_before: 3, ...overrides};
}
function resumeSupervisor(candidates, observation, replacementRoute) {
  assert(Array.isArray(candidates) && nonEmpty(replacementRoute));
  if (candidates.length !== 1) return {state: 'PAUSED', wakes: 0, replacements: 0};
  assert(observation && typeof observation === 'object' && !Array.isArray(observation));
  assert.deepStrictEqual(Object.keys(observation).sort(scalarCompare), ['evidence_digest', 'fence_guard_succeeded', 'owner_epoch_before', 'source_record_id', 'source_revision', 'status', 'terminal_or_unreachable_proven', 'wake_attempted']);
  assert(['resumable', 'terminal', 'unreachable', 'ambiguous'].includes(observation.status));
  nonEmpty(observation.source_record_id);
  nonEmpty(observation.source_revision);
  assert(/^[a-f0-9]{64}$/.test(observation.evidence_digest));
  assert.strictEqual(observation.wake_attempted, true);
  assert(Number.isInteger(observation.owner_epoch_before) && observation.owner_epoch_before > 0);
  if (observation.status === 'resumable') return {state: 'RESUMED', wakes: 1, replacements: 0, sourceRevision: observation.source_revision};
  if (['terminal', 'unreachable'].includes(observation.status) && observation.terminal_or_unreachable_proven === true && observation.fence_guard_succeeded === true) {
    return {state: 'REPLACED', wakes: 1, replacements: 1, previousFenced: true, ownerEpochBefore: observation.owner_epoch_before, ownerEpochAfter: observation.owner_epoch_before + 1, replacementRoute, sourceRevision: observation.source_revision};
  }
  return {state: 'PAUSED', wakes: 1, replacements: 0};
}
assert.deepStrictEqual(resumeSupervisor([supervisorIdentity], supervisorObservation('resumable'), 'saved-replacement'), {state: 'RESUMED', wakes: 1, replacements: 0, sourceRevision: 'revision-a'});
const provenTerminal = resumeSupervisor([supervisorIdentity], supervisorObservation('terminal', {terminal_or_unreachable_proven: true, fence_guard_succeeded: true}), 'saved-replacement');
assert.strictEqual(provenTerminal.replacements, 1);
assert.strictEqual(provenTerminal.ownerEpochAfter, provenTerminal.ownerEpochBefore + 1);
assert.strictEqual(resumeSupervisor([supervisorIdentity], supervisorObservation('unreachable'), 'saved-replacement').replacements, 0);
assert.strictEqual(resumeSupervisor([supervisorIdentity], supervisorObservation('unreachable', {terminal_or_unreachable_proven: true, fence_guard_succeeded: false}), 'saved-replacement').replacements, 0);
assert.strictEqual(resumeSupervisor([supervisorIdentity], supervisorObservation('unreachable', {terminal_or_unreachable_proven: true, fence_guard_succeeded: true}), 'saved-replacement').previousFenced, true);
assert.deepStrictEqual(resumeSupervisor([supervisorIdentity, {...supervisorIdentity, creation_token: 'other'}], supervisorObservation('ambiguous'), 'saved-replacement'), {state: 'PAUSED', wakes: 0, replacements: 0});
const distinct = createSession('empty', executorIdentity);
distinct.writeIntent();
distinct.create();
distinct.reconcile([creationIdentity('task', 'executor', 'token-b', 3, 'task-b'), creationIdentity('task', 'executor', 'token-c', 3, 'task-c')]);
assert.strictEqual(distinct.state(), 'paused');
assert.strictEqual(distinct.handoffs(), 1);
assert.throws(() => distinct.create());
const ambiguous = createSession('empty', executorIdentity);
ambiguous.writeIntent();
ambiguous.create();
ambiguous.reconcile([executorIdentity, creationIdentity('task', 'executor', 'token-d', 3, 'task-d')]);
assert.strictEqual(ambiguous.state(), 'paused');
assert.strictEqual(ambiguous.handoffs(), 1);
const duplicate = createSession('empty', executorIdentity);
duplicate.writeIntent();
duplicate.create();
duplicate.reconcile([executorIdentity, executorIdentity]);
assert.strictEqual(duplicate.state(), 'paused');
assert.strictEqual(duplicate.handoffs(), 1);
const changedCreator = createSession('empty', executorIdentity);
changedCreator.writeIntent();
changedCreator.create();
changedCreator.reconcile([{...executorIdentity, creator_owner_epoch: 4}]);
assert.strictEqual(changedCreator.state(), 'paused');
assert.strictEqual(changedCreator.handoffs(), 1);
const resumed = createSession('empty', executorIdentity);
resumed.writeIntent();
resumed.create();
resumed.resume();
resumed.reconcile([executorIdentity]);
assert.strictEqual(resumed.calls(), 1);
assert.strictEqual(resumed.state(), 'ready');
assert.throws(() => resumed.activate(2));

const projectlessNative = createSession('direct', executorIdentity, plannerProjectTarget, {nativeHandle: 'native-projectless-content-room'});
projectlessNative.writeIntent();
projectlessNative.create();
projectlessNative.reconcile([executorIdentity]);
assert.strictEqual(projectlessNative.state(), 'paused');
assert.strictEqual(projectlessNative.handoffs(), 1);
const nullProjectNative = createSession('direct', executorIdentity, plannerProjectTarget, {nativeHandle: 'native-project-null', prompt: 'project-a'});
nullProjectNative.writeIntent();
nullProjectNative.create();
nullProjectNative.reconcile([executorIdentity]);
assert.strictEqual(nullProjectNative.state(), 'paused');
assert.strictEqual(nullProjectNative.handoffs(), 1);
const failedProjectHandoff = createSession('direct', executorIdentity, plannerProjectTarget, {nativeHandle: 'native-projectless-content-room'}, () => false);
failedProjectHandoff.writeIntent();
failedProjectHandoff.create();
failedProjectHandoff.reconcile([executorIdentity]);
assert.strictEqual(failedProjectHandoff.state(), 'paused');
assert.strictEqual(failedProjectHandoff.pendingOutbox(), 1);
const lateProjectMismatch = createSession('direct', executorIdentity);
lateProjectMismatch.writeIntent();
lateProjectMismatch.create();
lateProjectMismatch.reconcile([executorIdentity]);
assert.strictEqual(lateProjectMismatch.state(), 'ready');
lateProjectMismatch.activate(3, {nativeHandle: 'native-project-null', prompt: 'project-a'});
assert.strictEqual(lateProjectMismatch.state(), 'paused');
assert.strictEqual(lateProjectMismatch.handoffs(), 1);

function quarantine(record) {
  assert.strictEqual(record.parsed, false);
  assert(record.sessions.every((session) => session.terminal || session.quiescent || session.adopted || session.rejected));
  return true;
}
assert(quarantine({parsed: false, sessions: [{terminal: true}, {quiescent: true}]}));
assert.throws(() => quarantine({parsed: true, sessions: []}));
assert.throws(() => quarantine({parsed: false, sessions: [{terminal: false, quiescent: false, adopted: false, rejected: false}]}));

const projectlessPlan = {provider: 'content-ops', target: 'projectless · editorial-room · approved non-code operations', publication: {kind: 'human', occurrence: occurrenceKeys}};
assert(projectlessPlan.provider !== 'github');
assert(!('repository' in projectlessPlan));
assert(!('pull_request' in projectlessPlan));
assert(!('head' in projectlessPlan));
assert.strictEqual(projectlessPlan.publication.kind, 'human');
assert.strictEqual(projectlessPlan.publication.occurrence.length, 11);
assert(sameProjectIdentity(parseTarget(projectlessPlan.target).target, parseTarget('projectless · editorial-room · executor').target));
assert.throws(() => sameProjectIdentity(parseTarget(projectlessPlan.target).target, parseTarget('projectless · other-room · executor').target));

function fingerprintSource(source) {
  const begin = 'OCTOPLAN_PLAN_MANIFEST_V6_BEGIN';
  const end = 'OCTOPLAN_PLAN_MANIFEST_V6_END';
  const normalized = source.replace(/\r\n?/g, '\n');
  assert.strictEqual(normalized.split(begin).length - 1, 1);
  assert.strictEqual(normalized.split(end).length - 1, 1);
  const start = normalized.indexOf(begin);
  const finish = normalized.indexOf(end);
  assert(start < finish);
  const lineEnd = normalized.indexOf('\n', finish);
  const cutEnd = lineEnd < 0 ? normalized.length : lineEnd + 1;
  return normalized.slice(0, start) + normalized.slice(cutEnd);
}
const sourceA = 'prefix\r\nOCTOPLAN_PLAN_MANIFEST_V6_BEGIN\r\n{"plan_hash":"hash-a"}\r\nOCTOPLAN_PLAN_MANIFEST_V6_END\r\nsuffix\r\n';
const sourceB = 'prefix\nOCTOPLAN_PLAN_MANIFEST_V6_BEGIN\n{"plan_hash":"hash-b"}\nOCTOPLAN_PLAN_MANIFEST_V6_END\nsuffix\n';
assert.strictEqual(fingerprintSource(sourceA), 'prefix\nsuffix\n');
assert.strictEqual(fingerprintSource(sourceA), fingerprintSource(sourceB));
assert.throws(() => fingerprintSource(sourceA + 'OCTOPLAN_PLAN_MANIFEST_V6_END'));

function canonicalPlan(plan) {
  const {blueprint, ...authoritative} = plan;
  return digest(authoritative);
}
const planA = {streams: ['stream-a'], questions: [], blueprint: {summary: 'old'}};
const planB = {...planA, blueprint: {summary: 'changed'}};
assert.strictEqual(canonicalPlan(planA), canonicalPlan(planB));
assert.notStrictEqual(canonicalPlan(planA), canonicalPlan({...planA, questions: ['question-a']}));

console.log('PASS: deterministic 10.2.0 contract fixtures');
NODE

changed_files=$({
  git -C "$root" diff --name-only origin/main --
  git -C "$root" diff --cached --name-only --
  git -C "$root" ls-files --others --exclude-standard
} | sort -u)
if printf '%s\n' "$changed_files" | grep -E '(^|/)(\.claude-plugin|plugins/octoplan-claude|docs/clients/claude)(/|$)' >/dev/null 2>&1; then
  fail 'public diff contains a protected Claude surface'
fi

private_pattern='/(Users|home|private|var/folders)/|[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}|-----BEGIN (RSA|OPENSSH|EC) PRIVATE KEY-----|\b(sk|ghp|xox)[A-Za-z0-9_-]{16,}\b'
if git -C "$root" diff --no-ext-diff origin/main -- | grep -E "$private_pattern" >/dev/null 2>&1; then
  fail 'public diff contains a private path, identifier, or secret-like value'
fi
untracked_files=$(git -C "$root" ls-files --others --exclude-standard)
for file in $untracked_files; do
  if [ -f "$root/$file" ] && grep -E "$private_pattern" "$root/$file" >/dev/null 2>&1; then
    fail "untracked public file contains a private path, identifier, or secret-like value: $file"
  fi
done

printf 'PASS: octoplan-codex 10.2.0 contract\n'
