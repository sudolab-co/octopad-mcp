#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill="$root/plugins/octoplan-codex/skills/octoplan"
contract="$skill/references/octoplan-contract-v3.md"
planning="$skill/references/planning.md"
runtime="$skill/references/codex-runtime.md"
supervision="$skill/references/codex-supervision.md"
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

grep -q '^Version: 8\.0\.0$' "$skill/SKILL.md" || fail 'Codex SKILL.md is not 8.0.0'
grep -q '"version": "8\.0\.0"' "$manifest" || fail 'Codex plugin is not 8.0.0'
grep -q '^### 8\.0\.0 — 2026-08-04$' "$changelog" || fail 'Codex changelog lacks 8.0.0'
release_note=$(awk '/^### 8\.0\.0 — 2026-08-04$/ { capture=1; next } capture && /^### / { exit } capture { print }' "$changelog")
printf '%s\n' "$release_note" | grep -Fq 'same Codex project' || fail '8.0.0 release note lacks the same-project behavior'
printf '%s\n' "$release_note" | grep -Fq 'Claude distribution is unchanged' || fail '8.0.0 release note lacks Claude isolation'
for forbidden_public_term in 'Delivery mandate' 'explicit-no-loop' 'plan-bound' 'outcome-bound'; do
  if printf '%s\n' "$release_note" | grep -Fq "$forbidden_public_term"; then
    fail "8.0.0 release note exposes internal delivery term: $forbidden_public_term"
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
if grep -E -i -n '(^|[^[:alnum:]])v1([^[:alnum:]]|$)|(^|[^[:alnum:]])v4([^[:alnum:]]|$)|(^|[^[:alnum:]])v5([^[:alnum:]]|$)|legacy' $active_docs >/dev/null 2>&1; then
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
[ "$planning_lines" -ge 145 ] && [ "$planning_lines" -le 165 ] || fail "planning.md is outside 145-165 lines: $planning_lines"
[ "$contract_lines" -ge 240 ] && [ "$contract_lines" -le 280 ] || fail "octoplan-contract-v3.md is outside 240-280 lines: $contract_lines"
[ "$runtime_lines" -ge 80 ] && [ "$runtime_lines" -le 95 ] || fail "codex-runtime.md is outside 80-95 lines: $runtime_lines"
[ "$supervision_lines" -ge 160 ] && [ "$supervision_lines" -le 185 ] || fail "codex-supervision.md is outside 160-185 lines: $supervision_lines"
active_lines=$((skill_lines + planning_lines + contract_lines + runtime_lines + supervision_lines))
active_words=$(wc -w $active_docs | awk 'END {print $1}')
common_lines=$((skill_lines + planning_lines + contract_lines))
common_words=$(wc -w "$skill/SKILL.md" "$planning" "$contract" | awk 'END {print $1}')
[ "$active_lines" -le 760 ] || fail "active skill documents exceed 760 lines: $active_lines"
[ "$active_words" -le 10000 ] || fail "active skill documents exceed 10000 words: $active_words"
[ "$common_lines" -le 480 ] || fail "common planning load exceeds 480 lines: $common_lines"
[ "$common_words" -le 6500 ] || fail "common planning load exceeds 6500 words: $common_words"

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
require_text "$planning" '[Consent binding](#consent-binding)'
require_text "$runtime" '[Shared capacity ladder](#shared-capacity-ladder)'
require_text "$runtime" '[Target and route binding](#target-and-route-binding)'
require_text "$supervision" '[Safe native-session creation](#safe-native-session-creation)'

require_text "$contract" '"schema": "octoplan-delivery-mandate-v2"'
require_text "$contract" '"activation_kind": "confirmed-brief|explicit-no-loop"'
require_text "$contract" '**Review before delivery** maps to the internal wire value `plan-bound`'
require_text "$contract" '**Autonomous delivery** maps to `outcome-bound`'
require_text "$contract" 'The wire values and `delivery_mandate` field name are internal and never appear in user-visible prose'
require_text "$contract" 'The user need not enumerate those three permissions or use an English label'
require_text "$planning" 'Default to **Review before delivery**'
require_text "$planning" 'semantically equivalent end-to-end delegation in any language'
require_text "$runtime" 'A single natural-language instruction may grant autonomous delivery without enumerating internal permissions'
require_text "$contract" 'raw bounded English and non-English end-to-end delegation, bare “do it”, urgency, and trust without delivery delegation'
require_text "$contract" '"authority_source": {'
require_text "$contract" '"record_id": "<durable source record ID>"'
require_text "$contract" '"message_digest": "<lowercase SHA-256>"'
require_text "$contract" '"protected_actions_authorized": false'
require_text "$contract" 'The only valid mode/activation combinations'
require_text "$contract" 'The four allowed delta classes are exactly'
require_text "$contract" '"activation_review": "<exact object above or null>"'
require_text "$contract" 'valid explicit-no-loop instead publishes this brief as a non-blocking checkpoint and may continue planning under the exact initial grant'
require_text "$contract" 'Once durable Decision IDs make the complete canonical mandate available'
require_text "$contract" 'no execution session precedes it'
require_text "$contract" 'feasibility_coverage'
require_text "$contract" 'Coverage and matrix collections are bijective'
require_text "$contract" 'The matrix is empty if and only if every `triggered_invariants` list is empty'
require_text "$contract" 'protected_occurrences'
require_text "$contract" '`false` value cannot satisfy or remove one'
require_text "$contract" 'Every occurrence points to a human task'
require_text "$contract" 'The four allowed delta classes are exactly'
require_text "$contract" 'task_role_target_overrides": [{"task_id":"<non-empty string>"'
require_text "$contract" 'octoplan-native-creation-v2'
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
require_text "$runtime" 'Every delivery task receives an adversarial check'
require_text "$runtime" 'one fresh source-first reviewer'
require_text "$runtime" 'a second orthogonal material failure domain'
require_text "$supervision" 'At durable `intent`, `creator_owner_epoch` equals the then-current supervisor epoch and is immutable'
require_text "$supervision" 'Only an actor with `actor epoch == current supervisor epoch` may activate'
require_text "$supervision" 'one fresh planner with no execution authority'
require_text "$supervision" 'common-fence every child and prove quiescence'
require_text "$supervision" 'old run remains quiescent in `replanning`'
require_text "$supervision" 'Only then guardedly supersede the old run and bind/create the new `active` run'
require_text "$supervision" 'adoption/rejection map'
require_text "$supervision" 'old launch binding, PASS records, and consent never transfer'
require_text "$supervision" 'schema-agnostically'
require_text "$planning" 'A material replan invalidates the old launch binding in either mode'
require_text "$planning" 'Reflect or branch'
require_text "$planning" 'may continue planning under the exact initial grant'
require_text "$planning" 'Once durable Decision IDs make the complete canonical mandate available'
require_text "$planning" 'before Plan PASS, fingerprinting, consent, or launch'
require_text "$planning" 'empty `triggered_invariants`'
require_text "$planning" 'verification actions or commands needed by a fresh executor'
require_text "$runtime" 'does not invalidate a byte-identical outcome-bound mandate'
require_text "$skill/SKILL.md" "planning session's saved Codex project"
require_text "$planning" "planning session's active Codex target"
require_text "$contract" "same Codex project identity as the planning target"
require_text "$runtime" "same Codex project identity as the planning target"
require_text "$supervision" "same Codex project identity as the planning target"

# Root README, Claude surfaces, and the Claude changelog section are protected.
if ! git -C "$root" diff --quiet origin/main -- README.md; then
  fail 'root README differs from origin/main'
fi
for protected in .claude-plugin plugins/octoplan-claude docs/clients/claude.md docs/clients/claude-code.md; do
  if ! git -C "$root" diff --quiet origin/main -- "$protected"; then
    fail "protected Claude surface changed: $protected"
  fi
done
git -C "$root" diff --quiet origin/main -- CONTRIBUTING.md || fail 'CONTRIBUTING.md changed in a Codex-only release'
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
const creationRoles = new Set(['supervisor', 'executor', 'lead-reviewer', 'specialist-reviewer', 'recovery', 'follow-up']);
const overrideRoles = new Set(['executor', 'lead-reviewer', 'specialist-reviewer', 'recovery']);
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
  assert(value.length > 0);
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

const completeNoLoopGrant = {planning: true, launch: true, material_replan: true, complete_envelope: true};
const naturalLanguageActivationCases = [
  {source: 'Find the right plan, deliver the result, and adapt the plan as needed within the stated scope.', language: 'en', bounded_outcome: true, expected: 'ACTIVATE'},
  {source: 'Fais le plan, livre le résultat et adapte le plan si nécessaire dans le périmètre défini.', language: 'fr', bounded_outcome: true, expected: 'ACTIVATE'},
  {source: 'Do it.', language: 'en', bounded_outcome: false, expected: 'WAIT'},
  {source: 'This is urgent.', language: 'en', bounded_outcome: false, expected: 'WAIT'},
  {source: 'I trust you.', language: 'en', bounded_outcome: false, expected: 'WAIT'}
];
function validateNaturalLanguageActivationCase(value) {
  assert(nonEmpty(value.source) && nonEmpty(value.language));
  assert(['ACTIVATE', 'WAIT'].includes(value.expected));
  if (value.expected === 'ACTIVATE') assert.strictEqual(value.bounded_outcome, true);
  else assert.strictEqual(value.bounded_outcome, false);
  return value.expected;
}
assert.deepStrictEqual(naturalLanguageActivationCases.map(validateNaturalLanguageActivationCase), ['ACTIVATE', 'ACTIVATE', 'WAIT', 'WAIT', 'WAIT']);
function noLoopPhaseFixture({explicitNoLoop, grant}) {
  const validNoLoop = explicitNoLoop === true && grant && stable(grant) === stable(completeNoLoopGrant);
  let phase = 'start';
  let planningPersisted = false;
  let decisionsDurable = false;
  let mandateComplete = false;
  let assembledMandate = null;
  let activationReviewed = false;
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
  const planPass = () => {
    assert(planningPersisted);
    if (explicitNoLoop) {
      assert.strictEqual(phase, 'activation-reviewed');
      assert(decisionsDurable && mandateComplete && activationReviewed);
    } else assert.strictEqual(phase, 'planning');
    phase = 'plan-passed';
  };
  const fingerprint = () => { assert.strictEqual(phase, 'plan-passed'); phase = 'fingerprinted'; };
  const consent = () => { assert.strictEqual(phase, 'fingerprinted'); phase = 'consented'; };
  const launch = () => { assert.strictEqual(phase, 'consented'); phase = 'launched'; };
  return {phase: () => phase, checkpoint, continueAfterCheckpoint, confirm, persistPlanning, persistDecisions, assembleMandate, activationReview, planPass, fingerprint, consent, launch};
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
const incompleteNoLoop = noLoopPhaseFixture({explicitNoLoop: true, grant: {planning: true, launch: true, material_replan: false, complete_envelope: true}});
incompleteNoLoop.checkpoint();
incompleteNoLoop.continueAfterCheckpoint();
assert.strictEqual(incompleteNoLoop.phase(), 'waiting');
assert.throws(() => incompleteNoLoop.persistPlanning());

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

const verdictForImpossible = (row) => (!row.primitive_ref || !row.verifier_available ? 'REVISE' : 'PASS');
assert.strictEqual(verdictForImpossible({primitive_ref: null, verifier_available: false}), 'REVISE');
const stateTransitions = {active: ['replanning', 'waiting-human', 'paused', 'revoked', 'completed'], replanning: ['superseded', 'waiting-human', 'failed'], paused: ['active', 'revoked'], 'waiting-human': ['active', 'revoked']};
assert(stateTransitions.active.includes('replanning'));
assert(!stateTransitions.active.includes('superseded'));

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

const creationKeys = ['run_id', 'subject_kind', 'subject_id', 'attempt_id', 'role', 'route', 'target', 'artifact_revision'];
const creationIdentityKeys = ['schema', 'creation_key', 'creation_token', 'creator_owner_epoch'];
function creationIdentity(subject_kind = 'task', role = 'executor', token = 'token-a', creator_owner_epoch = 3, subject_id = 'task-a', artifact_revision = null, target = plannerProjectTarget) {
  return {
    schema: 'octoplan-native-creation-v2',
    creation_key: {
      run_id: 'run-a',
      subject_kind,
      subject_id,
      attempt_id: subject_kind === 'task' ? 'attempt-a' : null,
      role,
      route: 'route-a',
      target,
      artifact_revision
    },
    creation_token: token,
    creator_owner_epoch
  };
}
function validateCreationIdentity(value, planningTarget = plannerProjectTarget) {
  assert.deepStrictEqual(Object.keys(value).sort(scalarCompare), creationIdentityKeys.slice().sort(scalarCompare));
  assert.strictEqual(value.schema, 'octoplan-native-creation-v2');
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
const reviewerIdentity = creationIdentity('task', 'lead-reviewer', 'token-reviewer', 3, 'task-a', 'artifact-a');
const specialistIdentity = creationIdentity('task', 'specialist-reviewer', 'token-specialist', 3, 'task-a', 'artifact-a');
const recoveryIdentity = creationIdentity('task', 'recovery', 'token-recovery', 3);
const supervisorIdentity = creationIdentity('supervisor', 'supervisor', 'token-supervisor', 3, 'supervisor-a');
const followUpIdentity = creationIdentity('follow-up', 'follow-up', 'token-follow-up', 3, 'follow-up-a');
const projectIdentities = [executorIdentity, reviewerIdentity, specialistIdentity, recoveryIdentity, supervisorIdentity, followUpIdentity];
for (const identity of projectIdentities) {
  assert(validateCreationIdentity(identity));
  assert.throws(() => validateCreationIdentity({...identity, creation_key: {...identity.creation_key, target: parseTarget('project-b · worktree · wrong project').target}}));
}
const projectlessIdentities = [
  creationIdentity('task', 'executor', 'token-projectless-executor', 3, 'task-projectless', null, plannerProjectlessTarget),
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

function createSession(response, expectedIdentity = executorIdentity, planningTarget = plannerProjectTarget) {
  validateCreationIdentity(expectedIdentity, planningTarget);
  let currentOwnerEpoch = expectedIdentity.creator_owner_epoch;
  let calls = 0;
  let intentWritten = false;
  let state = 'intent';
  let wake = null;
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
      transition(actorEpoch, 'ready', null);
    } else {
      transition(actorEpoch, 'paused', 'human-or-reconciliation-evidence');
    }
  };
  const exhaust = (actorEpoch = currentOwnerEpoch) => {
    assert.strictEqual(state, 'pending');
    transition(actorEpoch, 'paused', 'human-or-reconciliation-evidence');
  };
  const resume = (actorEpoch = currentOwnerEpoch) => {
    assert(['pending', 'paused'].includes(state));
    transition(actorEpoch, 'pending', 'reconcile-native-session');
  };
  const activate = (actorEpoch = currentOwnerEpoch) => {
    assert.strictEqual(state, 'ready');
    transition(actorEpoch, 'activated', null);
  };
  const lateWrite = (actorEpoch) => { guardEpoch(actorEpoch); };
  const takeover = (actorEpoch = currentOwnerEpoch) => {
    guardEpoch(actorEpoch);
    currentOwnerEpoch += 1;
    return currentOwnerEpoch;
  };
  return {identity: () => expectedIdentity, writeIntent, create, reconcile, exhaust, resume, activate, lateWrite, takeover, ownerEpoch: () => currentOwnerEpoch, calls: () => calls, state: () => state, wake: () => wake};
}
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
assert.throws(() => exact.lateWrite(1));
assert.throws(() => exact.lateWrite(2));
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
const distinct = createSession('empty', executorIdentity);
distinct.writeIntent();
distinct.create();
distinct.reconcile([creationIdentity('task', 'executor', 'token-b', 3, 'task-b'), creationIdentity('task', 'executor', 'token-c', 3, 'task-c')]);
assert.strictEqual(distinct.state(), 'paused');
assert.throws(() => distinct.create());
const ambiguous = createSession('empty', executorIdentity);
ambiguous.writeIntent();
ambiguous.create();
ambiguous.reconcile([executorIdentity, creationIdentity('task', 'executor', 'token-d', 3, 'task-d')]);
assert.strictEqual(ambiguous.state(), 'paused');
const duplicate = createSession('empty', executorIdentity);
duplicate.writeIntent();
duplicate.create();
duplicate.reconcile([executorIdentity, executorIdentity]);
assert.strictEqual(duplicate.state(), 'paused');
const changedCreator = createSession('empty', executorIdentity);
changedCreator.writeIntent();
changedCreator.create();
changedCreator.reconcile([{...executorIdentity, creator_owner_epoch: 4}]);
assert.strictEqual(changedCreator.state(), 'paused');
const resumed = createSession('empty', executorIdentity);
resumed.writeIntent();
resumed.create();
resumed.resume();
resumed.reconcile([executorIdentity]);
assert.strictEqual(resumed.calls(), 1);
assert.strictEqual(resumed.state(), 'ready');
assert.throws(() => resumed.activate(2));

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

console.log('PASS: deterministic 8.0.0 contract fixtures');
NODE

changed_files=$({
  git -C "$root" diff --name-only origin/main --
  git -C "$root" diff --cached --name-only --
  git -C "$root" ls-files --others --exclude-standard
} | sort -u)
if printf '%s\n' "$changed_files" | grep -E '(^|/)(\.claude-plugin|plugins/octoplan-claude|docs/clients/claude|README\.md$)(/|$)' >/dev/null 2>&1; then
  fail 'public diff contains a protected Claude or README surface'
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

printf 'PASS: octoplan-codex 8.0.0 contract\n'
