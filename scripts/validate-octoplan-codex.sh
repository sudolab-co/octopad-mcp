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

require_text() {
  grep -Fq -- "$2" "$1" || fail "missing contract text in ${1##*/}: $2"
}

for file in "$main" "$planning" "$runtime" "$supervision" "$multi_stream" "$recovery" "$conformance" "$manifest" "$agent_manifest"; do
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
skill_lines=$(wc -l < "$main" | tr -d ' ')
planning_lines=$(wc -l < "$planning" | tr -d ' ')
runtime_lines=$(wc -l < "$runtime" | tr -d ' ')
supervision_lines=$(wc -l < "$supervision" | tr -d ' ')
multi_stream_lines=$(wc -l < "$multi_stream" | tr -d ' ')
recovery_lines=$(wc -l < "$recovery" | tr -d ' ')
[ "$skill_lines" -le 75 ] || fail "SKILL.md exceeds 75 lines: $skill_lines"
[ "$planning_lines" -le 180 ] || fail "planning.md exceeds 180 lines: $planning_lines"
[ "$runtime_lines" -le 80 ] || fail "codex-runtime.md exceeds 80 lines: $runtime_lines"
[ "$supervision_lines" -le 150 ] || fail "codex-supervision.md exceeds 150 lines: $supervision_lines"
[ "$multi_stream_lines" -le 60 ] || fail "multi-stream.md exceeds 60 lines: $multi_stream_lines"
[ "$recovery_lines" -le 80 ] || fail "recovery.md exceeds 80 lines: $recovery_lines"
active_lines=$((skill_lines + planning_lines + runtime_lines + supervision_lines + multi_stream_lines + recovery_lines))
active_words=$(wc -w "$main" "$planning" "$runtime" "$supervision" "$multi_stream" "$recovery" | awk 'END {print $1}')
[ "$active_lines" -le 460 ] || fail "active skill documents exceed 460 lines: $active_lines"
[ "$active_words" -le 6800 ] || fail "active skill documents exceed 6800 words: $active_words"

for foundation in F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 F13; do
  require_text "$main" "**$foundation,"
  require_text "$conformance" "| $foundation,"
done

brief_banner='**Octoplan · Step 1 of 3 — Brief**'
plan_banner='**Octoplan · Step 2 of 3 — Plan**'
delivery_banner='**Octoplan · Step 3 of 3 — Delivery**'
require_text "$main" "$brief_banner"
require_text "$main" "$plan_banner"
require_text "$main" "$delivery_banner"
require_text "$planning" "$brief_banner"
require_text "$planning" "$plan_banner"
require_text "$supervision" "$delivery_banner"
if grep -Fq '## Octoplan ·' "$main" "$planning" "$runtime" "$supervision" "$multi_stream" "$recovery" ||
  grep -Fq 'Marked checkpoints' "$main" "$planning" "$runtime" "$supervision" "$multi_stream" "$recovery"; then
  fail 'non-canonical stage banner or interruption-level name remains'
fi
require_text "$main" '**Full autonomy.**'
require_text "$main" '**Checkpoints.**'
require_text "$main" '**Step-by-step.**'
require_text "$main" "The user's go authorizes every effect the Plan disclosed."
require_text "$main" 'reports when done'
require_text "$main" 'Octoplan contacts the user mid-delivery only for an undisclosed effect'
require_text "$main" 'House rules are not a level.'
require_text "$main" 'eight or more tasks'
require_text "$main" 'at least two independent judgments with distinct primary lenses'
require_text "$main" 'Every material executable change gets at least one fresh independent review'
require_text "$main" 'a second focused independent lens for a one-way-door surface'
require_text "$main" 'Use staging before production where the target provides it and design changes to be reversible'
require_text "$main" '`built`'
require_text "$main" '`accepted`'
require_text "$main" 'Keep no shadow plan, scheduler, artifact ledger, or delivery report.'
require_text "$main" 'Shared semantics decide what persists'

require_text "$planning" 'explicit playback'
require_text "$planning" 'Brief confirmation authorizes planning only.'
require_text "$planning" 'Build the first integrated result'
require_text "$planning" 'Use one stream for one success definition'
require_text "$planning" 'Full autonomy · Checkpoints · Step-by-step'
require_text "$planning" '**User checkpoints in Checkpoints mode**'
require_text "$planning" 'define each user checkpoint with exact subject/version or future binding rule'
require_text "$planning" '**Open questions**'
require_text "$planning" '**First ready work**'
require_text "$planning" 'Do not offer or accept a Plan go while an open question can change the fingerprint'
require_text "$planning" 'that one choice is the Plan go'
require_text "$planning" 'Planning-only permission never authorizes delivery.'
require_text "$planning" '`**Plan ref**`'
require_text "$planning" 'One reviewer applying two checklists does not satisfy the higher floor.'
require_text "$planning" '`OCTOPLAN_PLAN_REVIEW` receipt'
require_text "$planning" 'Server-generated stream/task IDs, statuses, assignees, timestamps, and the later user choice are excluded.'
require_text "$planning" 'require one-to-one ref-to-ID mappings'
require_text "$planning" 'disclosed effects; user checkpoints; house-rule gates'
require_text "$planning" 'Activation requires the complete applicable lens set at PASS on one fingerprint.'
require_text "$planning" '`Octoplan 18 plan contract`'
require_text "$planning" '`Octoplan 18 delivery authorization`'
require_text "$planning" '`Octoplan 18 supervisor lease`'
require_text "$planning" 'required outcome and constraint'
require_text "$planning" 'name a precedent only when current evidence shows it fits this case.'
require_text "$planning" 'A required login, third-party seat, or UI the executor cannot drive'
require_text "$planning" "If \`How\`, \`Verify\`, or \`Preconditions\` consumes another task's output"
require_text "$planning" 'one task that owns its final wording'

require_text "$runtime" 'The only automatic routes are Luna `max` and Sol `high|xhigh|max`.'
require_text "$runtime" 'Role admission is stricter:'
require_text "$runtime" 'Prompt text, title, or the requested route is not observation.'
require_text "$runtime" 'Keep a small sequential task inline.'
require_text "$runtime" '`OCTOPLAN_DISPATCH <stable-key>`'
require_text "$runtime" 'Ambiguous creation pauses that branch'
require_text "$runtime" 'predecessor stopped and the authoritative targets prove its effects quiescent'
require_text "$runtime" 'Full autonomy proceeds without a new Octoplan checkpoint'
require_text "$runtime" 'Any billing to any party is protected'

require_text "$supervision" 'Do not mirror a scheduler, Plan page, delivery report, or artifact registry.'
require_text "$supervision" 'guarded lease names its exact native-task identity and Goal'
require_text "$supervision" 'A reviewer may expose risk but cannot enlarge `Done when`.'
require_text "$supervision" 'absent from the reviewed plan is a material plan change, not a verification detail.'
require_text "$supervision" 'Use native blocked only after the same real impasse persists for three consecutive Goal turns'
require_text "$supervision" 'no task or dispatch remains active'
require_text "$supervision" 'no ambiguous effect is unresolved'
require_text "$supervision" 'only after its call returns or the authoritative target confirms it'
require_text "$supervision" 'one compact supervisor comment that references existing receipts'
require_text "$supervision" 'require the exact strings and surface'
require_text "$supervision" 'without changing its reviewed specification'
require_text "$supervision" 'if its owner started or closed, replan instead.'
require_text "$supervision" 'perform a disclosed effect without contacting the user'
require_text "$supervision" 'Undisclosed event'
require_text "$supervision" 'negative proof at the real call site'
require_text "$supervision" 'without interrupting Full autonomy'
require_text "$supervision" 'every selected user checkpoint or Step-by-step pause has a valid continuation receipt'

require_text "$multi_stream" 'It adds graph breadth, not a second protocol.'
require_text "$multi_stream" 'Give every stream an immutable plan-local ref'
require_text "$multi_stream" 'One fenced supervisor selects the ready frontier across every active stream.'
require_text "$multi_stream" 'A blocked stream or gate stops only downstream work'

require_text "$recovery" '`OCTOPLAN_ACTION <stable-key>`'
require_text "$recovery" 'Retry only when authoritative evidence proves it absent'
require_text "$recovery" 'Never replay a whole batch'
require_text "$recovery" '`OCTOPLAN_DISPATCH <stable-key>`'
require_text "$recovery" 'one fresh retry on the same Octopad task'
require_text "$recovery" 'predecessor stopped'
require_text "$recovery" 'effects quiescent'
require_text "$recovery" 'Share one two-route verification-recovery budget'
require_text "$recovery" 'After two comparable work or review cycles'
require_text "$recovery" 'Record a quiescence receipt.'
require_text "$recovery" 'Goals never transfer'
require_text "$recovery" 'Do not execute any pre-v18 plan contract'
require_text "$recovery" 'Never transfer an old PASS'

require_text "$conformance" '## v17.2 guarantee retention'
require_text "$conformance" 'Autopilot sources are outside this release.'

for retired in OCTOPLAN_STATE_BEGIN manifest_hash task_generation active_actors pending_actions supervisor_epoch creation_key binding_hash artifact_refs; do
  if grep -Fq "$retired" "$main" "$planning" "$runtime" "$supervision" "$multi_stream" "$recovery"; then
    fail "retired universal control field remains active: $retired"
  fi
done

require_text "$agent_manifest" 'allow_implicit_invocation: false'
plugin_prompt=$(node -p 'require(process.argv[1]).interface.defaultPrompt[0]' "$manifest")
agent_prompt=$(sed -n 's/^  default_prompt: "\(.*\)"$/\1/p' "$agent_manifest")
[ -n "$plugin_prompt" ] && [ "${#plugin_prompt}" -le 128 ] || fail 'plugin default prompt exceeds 128 characters'
[ "$plugin_prompt" = "$agent_prompt" ] || fail 'plugin and agent default prompts differ'

private_material_pattern="/""Users/|[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY"
for file in "$main" "$planning" "$runtime" "$supervision" "$multi_stream" "$recovery" "$conformance" "$manifest" "$agent_manifest"; do
  if sed 's/support@octopad\.ai//g' "$file" | grep -E "$private_material_pattern" >/dev/null 2>&1; then
    fail "private or identifying material appears in public file: ${file#$root/}"
  fi
done

node <<'NODE'
const assert = require('assert');
const crypto = require('crypto');

function routeDecision(role, model, effort, observed = false, available = false) {
  const automatic = (model === 'gpt-5.6-luna' && effort === 'max') ||
    (model === 'gpt-5.6-sol' && ['high', 'xhigh', 'max'].includes(effort));
  const roleAdmitted = role === 'worker' ? automatic :
    role === 'planner' ? model === 'gpt-5.6-sol' && ['xhigh', 'max'].includes(effort) :
    ['plan-reviewer', 'supervisor', 'delivery-reviewer'].includes(role) ?
      model === 'gpt-5.6-sol' && ['high', 'xhigh', 'max'].includes(effort) : false;
  return automatic && roleAdmitted && observed === true && available === true ?
    'USE_EXACT' : 'PAUSE_NO_SUBSTITUTION';
}

assert.strictEqual(routeDecision('worker', 'gpt-5.6-luna', 'max'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('worker', 'gpt-5.6-luna', 'max', true, true), 'USE_EXACT');
assert.strictEqual(routeDecision('planner', 'gpt-5.6-sol', 'xhigh', true, true), 'USE_EXACT');
assert.strictEqual(routeDecision('plan-reviewer', 'gpt-5.6-sol', 'high', true, true), 'USE_EXACT');
assert.strictEqual(routeDecision('supervisor', 'gpt-5.6-sol', 'max', true, true), 'USE_EXACT');
assert.strictEqual(routeDecision('planner', 'gpt-5.6-sol', 'high'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('plan-reviewer', 'gpt-5.6-luna', 'max'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('worker', 'gpt-5.6-luna', 'high'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('worker', 'gpt-5.6-terra', 'max'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('supervisor', 'gpt-5.6-sol', 'high', false), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('supervisor', 'gpt-5.6-sol', 'high', 'observed'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('unknown', 'gpt-5.6-sol', 'max'), 'PAUSE_NO_SUBSTITUTION');

function descendantsOf(rootId, edges) {
  const found = new Set([rootId]);
  let changed = true;
  while (changed) {
    changed = false;
    for (const [from, to] of edges) {
      if (found.has(from) && !found.has(to)) {
        found.add(to);
        changed = true;
      }
    }
  }
  return found;
}

const graph = [['E01', 'E02'], ['E02', 'E04'], ['E01', 'E03']];
const gateBlocked = descendantsOf('E02', graph);
assert.deepStrictEqual([...gateBlocked].sort(), ['E02', 'E04']);
assert.strictEqual(gateBlocked.has('E03'), false);

function canonical(value) {
  if (Array.isArray(value)) return value.map(canonical);
  if (value && typeof value === 'object') {
    return Object.fromEntries(Object.keys(value).sort().map(key => [key, canonical(value[key])]));
  }
  return value;
}

function fingerprint(packet) {
  return crypto.createHash('sha256').update(JSON.stringify(canonical(packet))).digest('hex');
}

function sortedValues(values) {
  if (!Array.isArray(values)) return null;
  return [...values].map(canonical).sort((a, b) =>
    JSON.stringify(a).localeCompare(JSON.stringify(b)));
}

function reviewedPacketFromDraft(draft) {
  return {
    ...draft,
    streams: [...draft.streams].sort((a, b) => a.ref.localeCompare(b.ref)),
    tasks: [...draft.tasks].sort((a, b) => a.ref.localeCompare(b.ref)),
    edges: [...draft.edges].sort((a, b) => `${a.from}:${a.to}`.localeCompare(`${b.from}:${b.to}`)),
    decisions: sortedValues(draft.decisions),
    questions: sortedValues(draft.questions),
    disclosedEffects: sortedValues(draft.disclosedEffects),
    userCheckpoints: sortedValues(draft.userCheckpoints),
    houseRuleGates: sortedValues(draft.houseRuleGates),
    routes: sortedValues(draft.routes),
  };
}

function planRefFromDescription(description) {
  if (typeof description !== 'string') return null;
  const matches = [...description.matchAll(/(?:^|\n)\*\*Plan ref\*\*\r?\n([^\r\n]+)(?=\r?\n|$)/g)];
  if (matches.length !== 1) return null;
  const ref = matches[0][1].trim();
  return /^[A-Z][A-Z0-9-]*$/.test(ref) ? ref : null;
}

function gateDefinitionValid(gate, nameField) {
  return gate && gate[nameField] && gate.owner && (gate.subjectVersion || gate.bindingRule) &&
    Array.isArray(gate.blockedDescendants) && gate.requiredEvidence && gate.invalidationRule;
}

function reviewedPacketFromPersisted(persisted) {
  const listFields = ['streams', 'tasks', 'edges', 'decisions', 'questions', 'disclosedEffects',
    'userCheckpoints', 'houseRuleGates', 'interruptionSemantics', 'routes'];
  const reviewTriggerNames = ['schema', 'permissions', 'money', 'privacy', 'destructive'];
  if (listFields.some(field => !Array.isArray(persisted[field])) || !persisted.briefFingerprint ||
    !persisted.targetSourceVersions || !persisted.rules || !persisted.reviewTriggers ||
    reviewTriggerNames.some(name => typeof persisted.reviewTriggers[name] !== 'boolean') ||
    JSON.stringify(persisted.interruptionSemantics) !==
      JSON.stringify(['full-autonomy', 'checkpoints', 'step-by-step'])) return null;
  const streams = persisted.streams.map(stream => ({
    id: stream.id,
    ref: stream.ref,
    title: stream.title,
    definitionOfSuccess: stream.definitionOfSuccess,
    deliveryTarget: stream.deliveryTarget,
    owner: stream.owner,
  }));
  const streamIds = streams.map(stream => stream.id);
  const streamRefs = streams.map(stream => stream.ref);
  if (streamIds.some(id => !id) || new Set(streamIds).size !== streamIds.length ||
    streamRefs.some(ref => !/^[A-Z][A-Z0-9-]*$/.test(ref || '')) ||
    new Set(streamRefs).size !== streamRefs.length || streams.some(stream =>
      !stream.title || !stream.definitionOfSuccess || !stream.deliveryTarget || !stream.owner)) return null;
  const streamById = new Map(streams.map(stream => [stream.id, stream.ref]));
  const tasks = persisted.tasks.map(task => ({
    id: task.id,
    ref: planRefFromDescription(task.description),
    streamRef: streamById.get(task.workStreamId),
    title: task.title,
    description: task.description,
  }));
  const ids = tasks.map(task => task.id);
  const refs = tasks.map(task => task.ref);
  if (ids.some(id => !id) || new Set(ids).size !== ids.length || refs.some(ref => !ref) ||
    new Set(refs).size !== refs.length || tasks.some(task => !task.title || !task.streamRef)) return null;
  const byId = new Map(tasks.map(task => [task.id, task.ref]));
  const edges = persisted.edges.map(edge => ({
    from: byId.get(edge.fromId), to: byId.get(edge.toId), rationale: edge.rationale,
  }));
  const edgeKeys = edges.map(edge => `${edge.from}:${edge.to}`);
  if (edges.some(edge => !edge.from || !edge.to || typeof edge.rationale !== 'string' ||
    !edge.rationale.trim()) || new Set(edgeKeys).size !== edgeKeys.length) return null;
  if (!persisted.userCheckpoints.every(checkpoint => gateDefinitionValid(checkpoint, 'name')) ||
    !persisted.houseRuleGates.every(gate => gateDefinitionValid(gate, 'subject'))) return null;
  return reviewedPacketFromDraft({
    briefFingerprint: persisted.briefFingerprint,
    streams: streams.map(({ref, title, definitionOfSuccess, deliveryTarget, owner}) =>
      ({ref, title, definitionOfSuccess, deliveryTarget, owner})),
    tasks: tasks.map(({ref, streamRef, title, description}) => ({ref, streamRef, title, description})),
    edges,
    decisions: persisted.decisions,
    questions: persisted.questions,
    reviewTriggers: persisted.reviewTriggers,
    disclosedEffects: persisted.disclosedEffects,
    userCheckpoints: persisted.userCheckpoints,
    houseRuleGates: persisted.houseRuleGates,
    interruptionSemantics: persisted.interruptionSemantics,
    routes: persisted.routes,
    targetSourceVersions: persisted.targetSourceVersions,
    rules: persisted.rules,
  });
}

function reviewAdmitted(packet, receipt) {
  const dispositions = new Set(['fixed', 'deferred', 'dismissed']);
  const findingsComplete = Array.isArray(receipt.findings) && receipt.findings.every(finding =>
    finding && finding.key && dispositions.has(finding.disposition) &&
    (finding.disposition !== 'fixed' || finding.evidence) &&
    (finding.disposition !== 'deferred' || (finding.authority && finding.rationale)) &&
    (finding.disposition !== 'dismissed' || finding.evidence));
  return receipt.verdict === 'PASS' && receipt.fingerprint === fingerprint(packet) &&
    typeof receipt.reviewerTaskId === 'string' && receipt.reviewerTaskId.length > 0 &&
    receipt.reviewerTaskId !== receipt.plannerTaskId && receipt.sourceRulesSnapshot &&
    fingerprint(receipt.sourceRulesSnapshot) === fingerprint(packet.rules) &&
    typeof receipt.primaryLens === 'string' && receipt.primaryLens.trim().length > 0 &&
    Array.isArray(receipt.checks) && receipt.checks.length > 0 &&
    Array.isArray(receipt.evidence) && receipt.evidence.length > 0 && receipt.evidence.every(Boolean) &&
    findingsComplete &&
    routeDecision('plan-reviewer', receipt.model, receipt.effort,
    receipt.observed, receipt.available) === 'USE_EXACT';
}

function requiredPlanReviewCount({taskCount = 0, schema = false, permissions = false,
  money = false, privacy = false, destructive = false}) {
  return taskCount >= 8 || schema || permissions || money || privacy || destructive ? 2 : 1;
}

function reviewSetAdmitted(packet, receipts) {
  const required = requiredPlanReviewCount({...packet.reviewTriggers, taskCount: packet.tasks.length});
  const admitted = receipts.filter(receipt => reviewAdmitted(packet, receipt));
  const identities = new Set(admitted.map(receipt => receipt.reviewerTaskId));
  const lenses = new Set(admitted.map(receipt => receipt.primaryLens.toLowerCase()));
  const triggerLenses = {
    schema: ['schema'], permissions: ['permissions'], money: ['money', 'spend'],
    privacy: ['privacy'], destructive: ['destructive', 'data-loss', 'reversibility'],
  };
  const triggeredLensesPresent = Object.entries(packet.reviewTriggers).every(([trigger, active]) =>
    !active || triggerLenses[trigger].some(lens => lenses.has(lens)));
  return admitted.length >= required && identities.size === admitted.length &&
    identities.size >= required && lenses.size >= required && triggeredLensesPresent;
}

const draft = reviewedPacketFromDraft({
  briefFingerprint: 'brief-a1',
  streams: [{ref: 'S01', title: 'Product delivery', definitionOfSuccess: 'integrated result works',
    deliveryTarget: 'repository-a', owner: 'product team'}],
  tasks: [
    {ref: 'E02', streamRef: 'S01', title: 'Integrate', description: '**Plan ref**\nE02'},
    {ref: 'E01', streamRef: 'S01', title: 'Build', description: '**Plan ref**\nE01'},
  ],
  edges: [{from: 'E01', to: 'E02', rationale: 'integration needs build'}],
  decisions: [{title: 'Delivery target', content: 'repository-a'}],
  questions: [{question: 'Release window?', status: 'open'}],
  reviewTriggers: {schema: false, permissions: false, money: false, privacy: false, destructive: false},
  disclosedEffects: [{kind: 'publication', target: 'release notes', consequence: 'becomes public'}],
  userCheckpoints: [{name: 'preview', consequence: 'review the rendered preview', owner: 'user',
    bindingRule: 'latest E02 output', blockedDescendants: ['E02'], requiredEvidence: 'continue reply',
    invalidationRule: 'reopen when E02 output changes'}],
  houseRuleGates: [{owner: 'maintainer', subject: 'merge', bindingRule: 'current merge head',
    blockedDescendants: ['E02'], requiredEvidence: 'green checks',
    invalidationRule: 'reopen when merge head changes'}],
  interruptionSemantics: ['full-autonomy', 'checkpoints', 'step-by-step'],
  routes: [{planRef: 'E01', model: 'gpt-5.6-luna', effort: 'max'}],
  targetSourceVersions: {target: 'repository-a@head-a', sources: ['spec@rev-a']},
  rules: 'rules@a1',
});
const persisted = {
  briefFingerprint: draft.briefFingerprint,
  streams: [{id: 'stream-generated', ref: 'S01', title: 'Product delivery',
    definitionOfSuccess: 'integrated result works', deliveryTarget: 'repository-a', owner: 'product team'}],
  tasks: [
    {id: 'generated-b', ref: 'FORGED', workStreamId: 'stream-generated', title: 'Integrate', description: '**Plan ref**\nE02', status: 'todo'},
    {id: 'generated-a', ref: 'FORGED', workStreamId: 'stream-generated', title: 'Build', description: '**Plan ref**\nE01', status: 'todo'},
  ],
  edges: [{fromId: 'generated-a', toId: 'generated-b', rationale: 'integration needs build'}],
  decisions: draft.decisions,
  questions: draft.questions,
  reviewTriggers: draft.reviewTriggers,
  disclosedEffects: draft.disclosedEffects,
  userCheckpoints: draft.userCheckpoints,
  houseRuleGates: draft.houseRuleGates,
  interruptionSemantics: draft.interruptionSemantics,
  routes: draft.routes,
  targetSourceVersions: draft.targetSourceVersions,
  rules: draft.rules,
};
const packet = reviewedPacketFromPersisted(persisted);
assert.deepStrictEqual(packet, draft);
assert.strictEqual(fingerprint(packet), fingerprint(draft));
assert.notStrictEqual(fingerprint({...draft, tasks: persisted.tasks}), fingerprint(draft));
assert.strictEqual(reviewedPacketFromPersisted({...persisted, tasks: [...persisted.tasks, {...persisted.tasks[0], id: 'generated-c'}]}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, tasks: [persisted.tasks[0],
  {...persisted.tasks[1], id: 'generated-b'}]}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, tasks: persisted.tasks.map(task =>
  ({...task, description: 'missing canonical plan ref'}))}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, edges: [{fromId: 'unknown', toId: 'generated-b', rationale: 'bad'}]}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, edges: [{fromId: 'generated-a', toId: 'generated-b', rationale: ''}]}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, edges: [...persisted.edges, ...persisted.edges]}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, routes: undefined}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, streams: [...persisted.streams,
  {...persisted.streams[0], id: 'stream-generated-2'}]}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, tasks: persisted.tasks.map(task =>
  ({...task, workStreamId: 'unknown-stream'}))}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, userCheckpoints:
  persisted.userCheckpoints.map(checkpoint => ({...checkpoint, invalidationRule: ''}))}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, houseRuleGates:
  persisted.houseRuleGates.map(gate => ({...gate, requiredEvidence: ''}))}), null);
assert.notStrictEqual(fingerprint(reviewedPacketFromPersisted({...persisted,
  disclosedEffects: [{kind: 'spend', target: 'credits', consequence: 'bills money'}]})), fingerprint(draft));
for (const [field, changed] of Object.entries({
  streams: persisted.streams.map(stream => ({...stream,
    definitionOfSuccess: 'different integrated result'})),
  decisions: [{title: 'Delivery target', content: 'repository-b'}],
  questions: [],
  reviewTriggers: {...draft.reviewTriggers, privacy: true},
  userCheckpoints: [],
  houseRuleGates: [],
  interruptionSemantics: ['full-autonomy', 'step-by-step'],
  routes: [{planRef: 'E01', model: 'gpt-5.6-sol', effort: 'high'}],
  targetSourceVersions: {target: 'repository-a@head-b', sources: ['spec@rev-a']},
  rules: 'rules@b2',
})) {
  assert.notStrictEqual(fingerprint(reviewedPacketFromPersisted({...persisted, [field]: changed})),
    fingerprint(draft), `fingerprint ignored ${field}`);
}
const review = {
  verdict: 'PASS', fingerprint: fingerprint(packet), plannerTaskId: 'plan-1', reviewerTaskId: 'review-1',
  primaryLens: 'integration', sourceRulesSnapshot: 'rules@a1', checks: ['scope', 'proof'],
  evidence: ['source inspection'], findings: [], model: 'gpt-5.6-sol', effort: 'high',
  observed: true, available: true,
};
assert.strictEqual(reviewAdmitted(packet, review), true);
assert.strictEqual(reviewAdmitted({...packet, rules: 'rules@b2'}, review), false);
assert.strictEqual(reviewAdmitted(packet, {...review, reviewerTaskId: 'plan-1'}), false);
assert.strictEqual(reviewAdmitted(packet, {...review, observed: false}), false);
assert.strictEqual(reviewAdmitted(packet, {...review, available: false}), false);
assert.strictEqual(reviewAdmitted(packet, {...review, sourceRulesSnapshot: 'wrong'}), false);
assert.strictEqual(reviewAdmitted(packet, {...review, evidence: []}), false);
assert.strictEqual(reviewAdmitted(packet, {...review, findings: undefined}), false);
assert.strictEqual(reviewAdmitted(packet, {...review, findings: [{key: 'F1', disposition: 'deferred'}]}), false);
assert.strictEqual(reviewAdmitted(packet, {...review, findings: [{key: 'F1', disposition: 'dismissed'}]}), false);
assert.strictEqual(reviewAdmitted(packet, {...review, findings: [{key: 'F1', disposition: 'fixed',
  evidence: 'corrected packet'}]}), true);
assert.strictEqual(requiredPlanReviewCount({taskCount: 7}), 1);
for (const trigger of ['schema', 'permissions', 'money', 'privacy', 'destructive']) {
  assert.strictEqual(requiredPlanReviewCount({[trigger]: true}), 2);
}
assert.strictEqual(requiredPlanReviewCount({taskCount: 8}), 2);
assert.strictEqual(reviewSetAdmitted(packet, [review]), true);
const moneyPacket = reviewedPacketFromDraft({...packet,
  reviewTriggers: {...packet.reviewTriggers, money: true}});
const moneyReview = {...review, fingerprint: fingerprint(moneyPacket)};
const secondReview = {...review, reviewerTaskId: 'review-2', primaryLens: 'money'};
const secondMoneyReview = {...secondReview, fingerprint: fingerprint(moneyPacket)};
assert.strictEqual(reviewSetAdmitted(moneyPacket, [moneyReview]), false);
assert.strictEqual(reviewSetAdmitted(moneyPacket, [moneyReview, secondMoneyReview]), true);
assert.strictEqual(reviewSetAdmitted(moneyPacket, [moneyReview,
  {...secondMoneyReview, primaryLens: 'dependency'}]), false);
assert.strictEqual(reviewSetAdmitted(moneyPacket, [moneyReview,
  {...secondMoneyReview, reviewerTaskId: 'review-1'}]), false);
assert.strictEqual(reviewSetAdmitted(moneyPacket, [moneyReview,
  {...secondMoneyReview, primaryLens: 'integration'}]), false);
assert.strictEqual(reviewSetAdmitted(moneyPacket, [moneyReview,
  {...secondMoneyReview, primaryLens: ''}]), false);
assert.strictEqual(reviewSetAdmitted(moneyPacket, [moneyReview,
  {...secondMoneyReview, primaryLens: undefined}]), false);
const moneyPrivacyPacket = reviewedPacketFromDraft({...packet,
  reviewTriggers: {...packet.reviewTriggers, money: true, privacy: true}});
const integrationReview = {...review, fingerprint: fingerprint(moneyPrivacyPacket)};
const moneyLensReview = {...secondReview, fingerprint: fingerprint(moneyPrivacyPacket)};
const duplicateIdentityPrivacyReview = {...moneyLensReview, primaryLens: 'privacy'};
assert.strictEqual(reviewSetAdmitted(moneyPrivacyPacket,
  [integrationReview, moneyLensReview, duplicateIdentityPrivacyReview]), false);
assert.strictEqual(reviewSetAdmitted(moneyPrivacyPacket, [moneyLensReview,
  {...duplicateIdentityPrivacyReview, reviewerTaskId: 'review-3'}]), true);
const eightTaskPacket = reviewedPacketFromDraft({...packet, tasks: Array.from({length: 8}, (_, index) => {
  const ref = `E${String(index + 1).padStart(2, '0')}`;
  return {ref, streamRef: 'S01', title: `Task ${ref}`, description: `**Plan ref**\n${ref}`};
})});
const eightReview = {...review, fingerprint: fingerprint(eightTaskPacket)};
const eightSecondReview = {...eightReview, reviewerTaskId: 'review-2', primaryLens: 'dependency'};
assert.strictEqual(reviewSetAdmitted(eightTaskPacket, [eightReview]), false);
assert.strictEqual(reviewSetAdmitted(eightTaskPacket, [eightReview, eightSecondReview]), true);

function deliveryInterruption({level, planGo = false, fingerprintMatches = false,
  disclosed, houseRuleGate = false,
  userCheckpoint = false, stepComplete = false, outcomeChanged = false, authorityNeed = false}) {
  if (!['full-autonomy', 'checkpoints', 'step-by-step'].includes(level)) return 'PAUSE_INVALID_LEVEL';
  if ([planGo, fingerprintMatches, disclosed, houseRuleGate, userCheckpoint, stepComplete,
    outcomeChanged, authorityNeed].some(value => typeof value !== 'boolean')) return 'PAUSE_INVALID_EVIDENCE';
  if (disclosed !== true || outcomeChanged === true || authorityNeed === true) return 'NEW_CONSEQUENCE_CONSENT';
  if (planGo !== true || fingerprintMatches !== true) return 'PAUSE_NO_DELIVERY_AUTHORITY';
  if (houseRuleGate === true) return 'WAIT_NAMED_HOUSE_RULE_OWNER';
  if (level === 'checkpoints' && userCheckpoint === true) return 'WAIT_USER_CHECKPOINT';
  if (level === 'step-by-step' && stepComplete === true) return 'WAIT_AFTER_STEP';
  return 'CONTINUE_AND_PERSIST';
}

assert.strictEqual(deliveryInterruption({}), 'PAUSE_INVALID_LEVEL');
assert.strictEqual(deliveryInterruption({level: 'unknown'}), 'PAUSE_INVALID_LEVEL');
assert.strictEqual(deliveryInterruption({level: 'full-autonomy'}), 'PAUSE_INVALID_EVIDENCE');
assert.strictEqual(deliveryInterruption({level: 'full-autonomy', planGo: 'recorded',
  fingerprintMatches: 'current'}), 'PAUSE_INVALID_EVIDENCE');
const fullAutonomy = {level: 'full-autonomy', planGo: true, fingerprintMatches: true,
  disclosed: true};
assert.strictEqual(deliveryInterruption(fullAutonomy), 'CONTINUE_AND_PERSIST');
assert.strictEqual(deliveryInterruption({...fullAutonomy, disclosed: false}), 'NEW_CONSEQUENCE_CONSENT');
assert.strictEqual(deliveryInterruption({...fullAutonomy, houseRuleGate: true}), 'WAIT_NAMED_HOUSE_RULE_OWNER');
assert.strictEqual(deliveryInterruption({...fullAutonomy, disclosed: false,
  houseRuleGate: true}), 'NEW_CONSEQUENCE_CONSENT');
assert.strictEqual(deliveryInterruption({level: 'checkpoints', planGo: true,
  fingerprintMatches: true, disclosed: true, userCheckpoint: true}), 'WAIT_USER_CHECKPOINT');
assert.strictEqual(deliveryInterruption({level: 'step-by-step', planGo: true,
  fingerprintMatches: true, disclosed: true, stepComplete: true}), 'WAIT_AFTER_STEP');

function deliveryReviewFloor({riskAssessed = false, material, oneWayDoor}) {
  if (riskAssessed !== true || typeof material !== 'boolean' ||
    typeof oneWayDoor !== 'boolean') return 2;
  if (oneWayDoor === true) return 2;
  return material === true ? 1 : 0;
}

assert.strictEqual(deliveryReviewFloor({}), 2);
assert.strictEqual(deliveryReviewFloor({riskAssessed: true, material: false, oneWayDoor: false}), 0);
assert.strictEqual(deliveryReviewFloor({riskAssessed: true, material: true, oneWayDoor: false}), 1);
assert.strictEqual(deliveryReviewFloor({riskAssessed: true, material: true, oneWayDoor: true}), 2);
assert.strictEqual(deliveryReviewFloor({riskAssessed: true, material: 'no', oneWayDoor: false}), 2);

function findingDisposition({effectiveRule = false, reviewedVerify = false, reviewedDoneWhen = false,
  unclearedCheckpoint = false, correctnessFailure = false}) {
  return effectiveRule || reviewedVerify || reviewedDoneWhen || unclearedCheckpoint || correctnessFailure ?
    'BLOCKING' : 'RESIDUAL_RISK';
}

assert.strictEqual(findingDisposition({}), 'RESIDUAL_RISK'); // An unplanned, unrun pgTAP suggestion.
for (const basis of ['effectiveRule', 'reviewedVerify', 'reviewedDoneWhen', 'unclearedCheckpoint', 'correctnessFailure']) {
  assert.strictEqual(findingDisposition({[basis]: true}), 'BLOCKING');
}

function persistentVerifierDecision({inReviewedPlan = false, requiredByRule = false, requiredByOutcome = false}) {
  if (inReviewedPlan === true) return 'USE_REVIEWED_PLAN';
  return requiredByRule === true || requiredByOutcome === true ?
    'REPLAN_BEFORE_BUILD' : 'REJECT_SCOPE_EXPANSION';
}

assert.strictEqual(persistentVerifierDecision({}), 'REJECT_SCOPE_EXPANSION'); // A new generic CI harness.
assert.strictEqual(persistentVerifierDecision({requiredByRule: true}), 'REPLAN_BEFORE_BUILD');
assert.strictEqual(persistentVerifierDecision({inReviewedPlan: 'no'}), 'REJECT_SCOPE_EXPANSION');

function productionPathProof({testCanBypassProduction = false, realCallSiteExercised = false,
  bypassProbeFails = false}) {
  if (testCanBypassProduction === false) return 'TARGETED_CHECK_SUFFICIENT';
  return testCanBypassProduction === true && realCallSiteExercised === true &&
    bypassProbeFails === true ? 'NEGATIVE_PROOF_ESTABLISHED' :
    'REQUIRE_REAL_CALL_SITE_PROOF';
}

assert.strictEqual(productionPathProof({}), 'TARGETED_CHECK_SUFFICIENT');
assert.strictEqual(productionPathProof({testCanBypassProduction: true}), 'REQUIRE_REAL_CALL_SITE_PROOF');
assert.strictEqual(productionPathProof({testCanBypassProduction: true,
  realCallSiteExercised: true}), 'REQUIRE_REAL_CALL_SITE_PROOF');
assert.strictEqual(productionPathProof({testCanBypassProduction: true,
  realCallSiteExercised: true, bypassProbeFails: true}), 'NEGATIVE_PROOF_ESTABLISHED');
assert.strictEqual(productionPathProof({testCanBypassProduction: true,
  realCallSiteExercised: 'yes', bypassProbeFails: 'yes'}), 'REQUIRE_REAL_CALL_SITE_PROOF');

function verificationRecovery(failedRoutes) {
  return failedRoutes.length >= 2 ? 'HANDOFF_EVIDENCE_GAP' : 'TRY_NEXT_SAFE_ROUTE';
}

assert.strictEqual(verificationRecovery([{actor: 'worker', route: 'local-postgres'}]), 'TRY_NEXT_SAFE_ROUTE');
assert.strictEqual(verificationRecovery([
  {actor: 'worker', route: 'local-postgres'}, {actor: 'reviewer', route: 'container-postgres'},
]), 'HANDOFF_EVIDENCE_GAP');

function specInstruction({hasOutcome, hasConstraint, prescribesTechnique = false,
  verifiedTrap = false, namesPrecedent = false, precedentFits = false}) {
  const flags = [hasOutcome, hasConstraint, prescribesTechnique, verifiedTrap, namesPrecedent,
    precedentFits];
  if (flags.some(flag => typeof flag !== 'boolean') || hasOutcome !== true ||
    hasConstraint !== true) return 'REVISE';
  if (prescribesTechnique === true && verifiedTrap !== true) return 'REVISE';
  if (namesPrecedent === true && precedentFits !== true) return 'REVISE';
  return 'ACCEPT';
}

assert.strictEqual(specInstruction({hasOutcome: true, hasConstraint: true}), 'ACCEPT');
assert.strictEqual(specInstruction({hasOutcome: false, hasConstraint: true}), 'REVISE');
assert.strictEqual(specInstruction({hasOutcome: true, hasConstraint: false}), 'REVISE');
assert.strictEqual(specInstruction({hasOutcome: true, hasConstraint: true,
  prescribesTechnique: true}), 'REVISE');
assert.strictEqual(specInstruction({hasOutcome: true, hasConstraint: true,
  prescribesTechnique: true, verifiedTrap: true}), 'ACCEPT');
assert.strictEqual(specInstruction({hasOutcome: true, hasConstraint: true,
  namesPrecedent: true, precedentFits: false}), 'REVISE');
assert.strictEqual(specInstruction({hasOutcome: 'no', hasConstraint: 'no'}), 'REVISE');

function verificationPlacement({requiresLogin = false, requiresThirdPartySeat = false,
  requiresUndrivableUi = false, accessAvailable}) {
  const flags = [requiresLogin, requiresThirdPartySeat, requiresUndrivableUi, accessAvailable];
  if (flags.some(flag => typeof flag !== 'boolean')) return 'PROTECTED_CHECKPOINT';
  return accessAvailable !== true && (requiresLogin === true || requiresThirdPartySeat === true ||
    requiresUndrivableUi === true) ?
    'PROTECTED_CHECKPOINT' : 'VERIFY';
}

assert.strictEqual(verificationPlacement({requiresLogin: true, accessAvailable: false}), 'PROTECTED_CHECKPOINT');
assert.strictEqual(verificationPlacement({requiresThirdPartySeat: true, accessAvailable: false}), 'PROTECTED_CHECKPOINT');
assert.strictEqual(verificationPlacement({requiresUndrivableUi: true, accessAvailable: false}), 'PROTECTED_CHECKPOINT');
assert.strictEqual(verificationPlacement({requiresLogin: true, accessAvailable: true}), 'VERIFY');
assert.strictEqual(verificationPlacement({requiresLogin: true}), 'PROTECTED_CHECKPOINT');
assert.strictEqual(verificationPlacement({requiresLogin: true,
  accessAvailable: 'false'}), 'PROTECTED_CHECKPOINT');

function planWiringValid(tasks, edges) {
  const edgeKeys = new Set(edges.map(([from, to]) => `${from}->${to}`));
  const textOwners = new Set();
  for (const task of tasks) {
    for (const source of task.consumes || []) {
      if (!edgeKeys.has(`${source}->${task.ref}`)) return false;
    }
    for (const surface of task.finalText || []) {
      if (textOwners.has(surface)) return false;
      textOwners.add(surface);
    }
  }
  return true;
}

const wiredTasks = [
  {ref: 'E01', finalText: ['settings.empty-state']},
  {ref: 'E02', consumes: ['E01'], finalText: ['settings.help']},
];
assert.strictEqual(planWiringValid(wiredTasks, [['E01', 'E02']]), true);
assert.strictEqual(planWiringValid(wiredTasks, []), false);
assert.strictEqual(planWiringValid([
  ...wiredTasks, {ref: 'E03', finalText: ['settings.empty-state']},
], [['E01', 'E02']]), false);

function routeMintedWording({hasOwner, ownerStarted = false, ownerClosed = false}) {
  if (hasOwner !== true || ownerStarted !== false || ownerClosed !== false) return 'REPLAN';
  return 'COMMENT_ON_OWNER';
}

assert.strictEqual(routeMintedWording({hasOwner: true, ownerStarted: false}), 'COMMENT_ON_OWNER');
assert.strictEqual(routeMintedWording({hasOwner: true, ownerStarted: true}), 'REPLAN');
assert.strictEqual(routeMintedWording({hasOwner: true, ownerClosed: true}), 'REPLAN');
assert.strictEqual(routeMintedWording({hasOwner: false, ownerStarted: false}), 'REPLAN');
assert.strictEqual(routeMintedWording({hasOwner: 'no', ownerStarted: false}), 'REPLAN');

function supervisorCloseEvidence({callReturned = false, authoritativeConfirmation = false,
  identity, checks, outcome, retriesRecorded = false}) {
  return (callReturned === true || authoritativeConfirmation === true) && identity &&
    checks.length > 0 && outcome === 'PASS' && retriesRecorded === true ?
    'CLOSE_EVIDENCED' : 'KEEP_OPEN';
}

assert.strictEqual(supervisorCloseEvidence({callReturned: false, identity: null,
  checks: ['test'], outcome: 'PASS'}), 'KEEP_OPEN');
assert.strictEqual(supervisorCloseEvidence({callReturned: true, identity: 'review-1',
  checks: ['test'], outcome: 'PASS', retriesRecorded: true}), 'CLOSE_EVIDENCED');
assert.strictEqual(supervisorCloseEvidence({callReturned: true, identity: 'review-1',
  checks: ['test'], outcome: 'FAIL'}), 'KEEP_OPEN');
assert.strictEqual(supervisorCloseEvidence({callReturned: 'returned', identity: 'review-1',
  checks: ['test'], outcome: 'PASS'}), 'KEEP_OPEN');
assert.strictEqual(supervisorCloseEvidence({authoritativeConfirmation: true, identity: 'review-1',
  checks: ['test'], outcome: 'PASS', retriesRecorded: true}), 'CLOSE_EVIDENCED');

function clearanceValid(checkpoint, artifact) {
  return Boolean(checkpoint.subject === artifact.subject && checkpoint.version === artifact.version &&
    checkpoint.owner === artifact.owner && checkpoint.evidence && checkpoint.invalidationRule &&
    checkpoint.invalidated === false);
}

const clearance = {subject: 'pr', version: 'sha-a', owner: 'alex', evidence: 'approval-1',
  invalidationRule: 'reopen when head changes', invalidated: false};
assert.strictEqual(clearanceValid(clearance, {subject: 'pr', version: 'sha-a', owner: 'alex'}), true);
assert.strictEqual(clearanceValid(clearance, {subject: 'pr', version: 'sha-b', owner: 'alex'}), false);
assert.strictEqual(clearanceValid({...clearance, invalidationRule: ''},
  {subject: 'pr', version: 'sha-a', owner: 'alex'}), false);
assert.strictEqual(clearanceValid({...clearance, invalidated: 'no'},
  {subject: 'pr', version: 'sha-a', owner: 'alex'}), false);
assert.strictEqual(clearanceValid({...clearance, invalidated: true}, {subject: 'pr', version: 'sha-a', owner: 'alex'}), false);

function prepareDispatch({key, role, octopadTaskId, nativeTarget, route}) {
  assert(key && role && octopadTaskId && nativeTarget && route);
  return {key, role, octopadTaskId, nativeTarget, route, state: 'prepared', createAttempts: 0};
}

function createOnce(dispatch, result) {
  if (dispatch.createAttempts !== 0) return {...dispatch, decision: 'PAUSE_DUPLICATE_CREATE'};
  const next = {...dispatch, createAttempts: 1};
  return result.taskId ? {...next, state: 'created', taskId: result.taskId} :
    {...next, state: 'ambiguous', decision: 'RECONCILE_NATIVE_READ'};
}

function bindDispatch(dispatch, observed) {
  const exact = dispatch.taskId === observed.taskId && dispatch.nativeTarget === observed.nativeTarget &&
    dispatch.octopadTaskId === observed.octopadTaskId && dispatch.route === observed.route;
  return exact ? {...dispatch, state: 'bound'} : {...dispatch, decision: 'PAUSE_BINDING_MISMATCH'};
}

function replacementAllowed(dispatch, evidence, successorDispatchKey) {
  return Boolean(dispatch.state === 'terminal' && evidence.predecessorStopped === true &&
    evidence.effectsQuiescent === true && successorDispatchKey && successorDispatchKey !== dispatch.key);
}

const prepared = prepareDispatch({key: 'd-1', role: 'worker', octopadTaskId: 'E01', nativeTarget: 'project-a', route: 'luna-max'});
const ambiguous = createOnce(prepared, {});
assert.strictEqual(ambiguous.decision, 'RECONCILE_NATIVE_READ');
assert.strictEqual(createOnce(ambiguous, {taskId: 'native-2'}).decision, 'PAUSE_DUPLICATE_CREATE');
const created = createOnce(prepared, {taskId: 'native-1'});
assert.strictEqual(bindDispatch(created, {taskId: 'native-1', nativeTarget: 'project-b', octopadTaskId: 'E01', route: 'luna-max'}).decision, 'PAUSE_BINDING_MISMATCH');
const bound = bindDispatch(created, {taskId: 'native-1', nativeTarget: 'project-a', octopadTaskId: 'E01', route: 'luna-max'});
assert.strictEqual(bound.state, 'bound');
assert.strictEqual(replacementAllowed({...bound, state: 'terminal'},
  {predecessorStopped: true, effectsQuiescent: true}, 'd-2'), true);
assert.strictEqual(replacementAllowed({...bound, state: 'terminal'},
  {predecessorStopped: true, effectsQuiescent: true}), false);
assert.strictEqual(replacementAllowed({...bound, state: 'terminal'},
  {predecessorStopped: true, effectsQuiescent: true}, 'd-1'), false);
assert.strictEqual(replacementAllowed({...bound, state: 'terminal'},
  {predecessorStopped: false, effectsQuiescent: true}, 'd-2'), false);
assert.strictEqual(replacementAllowed({...bound, state: 'terminal'},
  {predecessorStopped: 'yes', effectsQuiescent: 'yes'}, 'd-2'), false);
assert.strictEqual(replacementAllowed(bound,
  {predecessorStopped: true, effectsQuiescent: true}, 'd-2'), false);

function rotateLease(current, expectedUpdatedAt, successorTaskId, evidence) {
  if (current.updatedAt !== expectedUpdatedAt) return {decision: 'CAS_CONFLICT'};
  if (typeof successorTaskId !== 'string' || !successorTaskId || successorTaskId === current.ownerTaskId) {
    return {decision: 'PAUSE_INVALID_SUCCESSOR'};
  }
  if (evidence.safeBoundary !== true || evidence.effectsQuiescent !== true ||
    typeof evidence.quiescenceReceipt !== 'string' || !evidence.quiescenceReceipt) {
    return {decision: 'PAUSE_NOT_QUIESCENT'};
  }
  return {
    ownerTaskId: successorTaskId, generation: current.generation + 1, goalId: null,
    status: 'acquired-no-goal', updatedAt: `${current.updatedAt}-next`, predecessorFenced: true,
  };
}

const lease = {ownerTaskId: 'sup-1', generation: 3, goalId: 'goal-old', updatedAt: 't1'};
const quiescent = {safeBoundary: true, effectsQuiescent: true, quiescenceReceipt: 'receipt-1'};
assert.strictEqual(rotateLease(lease, 'stale', 'sup-2', quiescent).decision, 'CAS_CONFLICT');
assert.strictEqual(rotateLease(lease, 't1', '', quiescent).decision, 'PAUSE_INVALID_SUCCESSOR');
assert.strictEqual(rotateLease(lease, 't1', 'sup-1', quiescent).decision, 'PAUSE_INVALID_SUCCESSOR');
assert.strictEqual(rotateLease(lease, 't1', 'sup-2',
  {...quiescent, effectsQuiescent: false}).decision, 'PAUSE_NOT_QUIESCENT');
assert.strictEqual(rotateLease(lease, 't1', 'sup-2',
  {...quiescent, quiescenceReceipt: ''}).decision, 'PAUSE_NOT_QUIESCENT');
const rotated = rotateLease(lease, 't1', 'sup-2', quiescent);
assert.strictEqual(rotated.ownerTaskId, 'sup-2');
assert.strictEqual(rotated.generation, 4);
assert.strictEqual(rotated.goalId, null);
assert.strictEqual(rotateLease(rotated, 't1', 'sup-3', quiescent).decision, 'CAS_CONFLICT');

function successorGoalAllowed(rotatedLease, successorTaskId, evidence) {
  return Boolean(rotatedLease.ownerTaskId === successorTaskId && rotatedLease.goalId === null &&
    rotatedLease.predecessorFenced === true &&
    (evidence.predecessorTerminal === true || evidence.predecessorUnreachable === true) &&
    evidence.postFenceEffectsQuiescent === true);
}

const takeoverEvidence = {predecessorTerminal: true, predecessorUnreachable: false,
  postFenceEffectsQuiescent: true};
assert.strictEqual(successorGoalAllowed(rotated, 'sup-2', takeoverEvidence), true);
assert.strictEqual(successorGoalAllowed(rotated, 'sup-2',
  {...takeoverEvidence, predecessorTerminal: false}), false);
assert.strictEqual(successorGoalAllowed(rotated, 'sup-2',
  {...takeoverEvidence, predecessorTerminal: 'terminal'}), false);
assert.strictEqual(successorGoalAllowed(rotated, 'sup-3', takeoverEvidence), false);

function ambiguousEffect(action, evidence) {
  if (evidence.authoritative !== true) return 'PAUSE_AFFECTED_BRANCH';
  if (evidence.observed === 'present') return 'RECORD_RECEIPT';
  if (evidence.observed === 'absent' && evidence.operationKey === action.key && action.retryCount === 0) {
    return 'RETRY_SAME_KEY_ONCE';
  }
  return 'PAUSE_AFFECTED_BRANCH';
}

const action = {key: 'action-1', retryCount: 0};
assert.strictEqual(ambiguousEffect(action,
  {authoritative: true, observed: 'present', operationKey: 'action-1'}), 'RECORD_RECEIPT');
assert.strictEqual(ambiguousEffect(action,
  {authoritative: true, observed: 'absent', operationKey: 'action-1'}), 'RETRY_SAME_KEY_ONCE');
assert.strictEqual(ambiguousEffect({...action, retryCount: 1},
  {authoritative: true, observed: 'absent', operationKey: 'action-1'}), 'PAUSE_AFFECTED_BRANCH');
assert.strictEqual(ambiguousEffect(action,
  {authoritative: true, observed: 'absent', operationKey: 'action-2'}), 'PAUSE_AFFECTED_BRANCH');
assert.strictEqual(ambiguousEffect(action,
  {authoritative: false, observed: 'absent', operationKey: 'action-1'}), 'PAUSE_AFFECTED_BRANCH');
assert.strictEqual(ambiguousEffect(action,
  {authoritative: 'yes', observed: 'absent', operationKey: 'action-1'}), 'PAUSE_AFFECTED_BRANCH');
assert.strictEqual(ambiguousEffect(action,
  {authoritative: true, observed: 'unknown', operationKey: 'action-1'}), 'PAUSE_AFFECTED_BRANCH');

function completionAllowed(state) {
  const evidenceFields = ['integratedProof', 'briefMatches', 'planFingerprintMatches',
    'reviewFloorSatisfied', 'findingsDispositioned', 'versionBoundGatesValid',
    'interruptionObligationsSatisfied', 'disclosedEffectsReconciled', 'leaseOwnerMatches',
    'goalObjectiveAchieved'];
  return evidenceFields.every(field => state[field] === true) &&
    ['activeTasks', 'activeDispatches', 'unresolvedActions'].every(field =>
      Number.isInteger(state[field]) && state[field] === 0);
}

const complete = {integratedProof: true, briefMatches: true, planFingerprintMatches: true,
  reviewFloorSatisfied: true, findingsDispositioned: true, versionBoundGatesValid: true,
  interruptionObligationsSatisfied: true, disclosedEffectsReconciled: true,
  activeTasks: 0, activeDispatches: 0, unresolvedActions: 0,
  leaseOwnerMatches: true, goalObjectiveAchieved: true};
assert.strictEqual(completionAllowed(complete), true);
assert.strictEqual(completionAllowed({...complete, integratedProof: 'pending'}), false);
for (const field of ['integratedProof', 'briefMatches', 'planFingerprintMatches', 'reviewFloorSatisfied',
  'findingsDispositioned', 'versionBoundGatesValid', 'disclosedEffectsReconciled',
  'interruptionObligationsSatisfied', 'leaseOwnerMatches', 'goalObjectiveAchieved']) {
  assert.strictEqual(completionAllowed({...complete, [field]: false}), false);
}
for (const field of ['activeTasks', 'activeDispatches', 'unresolvedActions']) {
  assert.strictEqual(completionAllowed({...complete, [field]: 1}), false);
}

function reviewSession({materialChange, stableFindings, requiredFreshReviews = 1}) {
  if (materialChange) return `NEW_FRESH_REVIEW_SET_${requiredFreshReviews}`;
  return stableFindings ? 'SAME_REVIEWER_TARGETED_RECHECK' : 'NO_EXTRA_REVIEW';
}
assert.strictEqual(reviewSession({materialChange: false, stableFindings: true}), 'SAME_REVIEWER_TARGETED_RECHECK');
assert.strictEqual(reviewSession({materialChange: true, stableFindings: true}), 'NEW_FRESH_REVIEW_SET_1');
assert.strictEqual(reviewSession({materialChange: true, stableFindings: true, requiredFreshReviews: 2}), 'NEW_FRESH_REVIEW_SET_2');

function supervisorRoute({heavyPlanning, contextThinning, unrelatedGoal}) {
  return heavyPlanning || contextThinning || unrelatedGoal ? 'FRESH_SUPERVISOR' : 'CURRENT_TASK';
}
assert.strictEqual(supervisorRoute({heavyPlanning: false, contextThinning: false, unrelatedGoal: false}), 'CURRENT_TASK');
assert.strictEqual(supervisorRoute({heavyPlanning: true, contextThinning: false, unrelatedGoal: false}), 'FRESH_SUPERVISOR');
assert.strictEqual(supervisorRoute({heavyPlanning: false, contextThinning: true, unrelatedGoal: false}), 'FRESH_SUPERVISOR');

const closureVocabulary = new Set(['built', 'reviewed', 'merged', 'applied', 'verified', 'released', 'accepted']);
assert.strictEqual(closureVocabulary.has('verified'), true);
assert.strictEqual(closureVocabulary.has('done'), false);
assert.strictEqual(closureVocabulary.has('green'), false);

console.log('PASS: Octoplan 18 staged UX, authority, routing, graph, review-floor, recovery, gate, dispatch, lease, effect, and completion fixtures');
NODE

latest_changelog=$(awk '/^## octoplan-codex$/ { found=1; next } found && /^### / { sub(/^### /, ""); sub(/ — .*/, ""); print; exit }' "$root/CHANGELOG.md")
[ "$latest_changelog" = "$skill_version" ] || fail 'latest Codex changelog version differs from the skill'

printf 'PASS: Octoplan Codex 18.0.0 shared-core contract\n'
