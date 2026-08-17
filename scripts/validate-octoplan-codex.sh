#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill="$root/plugins/octoplan-codex/skills/octoplan"
main="$skill/SKILL.md"
planning="$skill/references/planning.md"
runtime="$skill/references/codex-runtime.md"
supervision="$skill/references/codex-supervision.md"
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

for file in "$main" "$planning" "$runtime" "$supervision" "$manifest" "$agent_manifest"; do
  require_file "$file"
done

[ ! -d "$skill/roles" ] || fail 'retired role-pack directory remains'
expected_refs='codex-runtime.md
codex-supervision.md
planning.md'
actual_refs=$(find "$skill/references" -maxdepth 1 -type f -name '*.md' -exec basename '{}' \; | sort)
[ "$actual_refs" = "$expected_refs" ] || fail 'unexpected Codex reference set'

skill_version=$(sed -n 's/^Version: //p' "$main")
[ "$skill_version" = '17.2.0' ] || fail 'Codex SKILL.md is not 17.2.0'
manifest_version=$(node -e 'process.stdout.write(JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).version)' "$manifest")
[ "$manifest_version" = "$skill_version" ] || fail 'Codex skill and manifest versions differ'
readme_row=$(printf '| [`octoplan-codex`](plugins/octoplan-codex/skills/octoplan/SKILL.md) | Codex | %s | Builds a lean governed plan, challenges it once, then supervises authorized delivery from Octopad. |' "$skill_version")
[ "$(grep -Fxc "$readme_row" "$root/README.md")" -eq 1 ] || fail 'README Codex version or behavior is stale'
skill_lines=$(wc -l < "$main" | tr -d ' ')
planning_lines=$(wc -l < "$planning" | tr -d ' ')
runtime_lines=$(wc -l < "$runtime" | tr -d ' ')
supervision_lines=$(wc -l < "$supervision" | tr -d ' ')
[ "$skill_lines" -le 65 ] || fail "SKILL.md exceeds 65 lines: $skill_lines"
[ "$planning_lines" -le 160 ] || fail "planning.md exceeds 160 lines: $planning_lines"
[ "$runtime_lines" -le 80 ] || fail "codex-runtime.md exceeds 80 lines: $runtime_lines"
[ "$supervision_lines" -le 150 ] || fail "codex-supervision.md exceeds 150 lines: $supervision_lines"
active_lines=$((skill_lines + planning_lines + runtime_lines + supervision_lines))
active_words=$(wc -w "$main" "$planning" "$runtime" "$supervision" | awk 'END {print $1}')
[ "$active_lines" -le 420 ] || fail "active skill documents exceed 420 lines: $active_lines"
[ "$active_words" -le 6000 ] || fail "active skill documents exceed 6000 words: $active_words"

require_text "$main" 'Store the plan where the team already works'
require_text "$main" 'Do not mirror the plan into a private JSON control object'
require_text "$main" 'Run exactly one fresh plan challenge'
require_text "$main" 'canonical plan fingerprint'
require_text "$main" 'exact subject/version, owner, evidence, and invalidation rule'
require_text "$main" 'record one stable dispatch key'
require_text "$main" 'A checkpoint blocks only its dependent branch.'
require_text "$main" 'Choose a fresh supervisor before Goal creation after a heavy planning pass.'
require_text "$main" 'guarded supervisor-lease rotation and quiescence proof; Goals never transfer'
require_text "$main" 'report six localized fields'
require_text "$main" 'Do not execute private Octoplan v3-v6 control objects.'
require_text "$planning" 'creation brief'
require_text "$planning" 'first integrated demonstrable result'
require_text "$planning" '`**Plan ref**`'
require_text "$planning" 'Scale lenses inside this one review instead of multiplying reviewers.'
require_text "$planning" '`OCTOPLAN_PLAN_REVIEW` receipt'
require_text "$planning" 'Server-generated task IDs, statuses, assignees, and timestamps are excluded.'
require_text "$planning" 'require a one-to-one ref-to-ID mapping'
require_text "$planning" 'require an exact fingerprint match to the latest PASS'
require_text "$planning" '`Octoplan 17 plan contract`'
require_text "$planning" '`Octoplan 17 delivery authorization`'
require_text "$planning" '`Octoplan 17 supervisor lease`'
require_text "$planning" 'Never replay the whole batch.'
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
require_text "$runtime" 'A checkpoint blocks only descendants that need it'
require_text "$supervision" 'Do not mirror a scheduler or artifact registry.'
require_text "$supervision" 'guarded lease names its exact native-task identity and Goal'
require_text "$supervision" '`OCTOPLAN_ACTION <stable-key>`'
require_text "$supervision" 'retry only when absence is proved'
require_text "$supervision" 'one fresh retry on the same task'
require_text "$supervision" 'A reviewer may expose risk but cannot enlarge `Done when`.'
require_text "$supervision" 'absent from the reviewed plan is a material plan change, not a verification detail.'
require_text "$supervision" 'Share the two-route verification-recovery budget across the supervisor, workers, and reviewers.'
require_text "$supervision" 'After two comparable work/review cycles'
require_text "$supervision" 'Use native blocked only after the same real impasse persists for three consecutive Goal turns'
require_text "$supervision" 'record a quiescence receipt'
require_text "$supervision" 'The predecessor Goal remains historical and is never claimed transferred'
require_text "$supervision" 'no task or dispatch remains active, and no ambiguous effect is unresolved'
require_text "$supervision" 'only after its call returns or the authoritative target confirms it'
require_text "$supervision" 'one compact supervisor comment that references existing receipts'
require_text "$supervision" 'require the exact strings and surface'
require_text "$supervision" 'without changing its reviewed specification'
require_text "$supervision" 'if its owner started or closed, replan instead.'

for retired in OCTOPLAN_STATE_BEGIN manifest_hash task_generation active_actors pending_actions supervisor_epoch creation_key binding_hash artifact_refs; do
  if grep -Fq "$retired" "$main" "$planning" "$runtime" "$supervision"; then
    fail "retired universal control field remains active: $retired"
  fi
done

require_text "$agent_manifest" 'allow_implicit_invocation: false'
plugin_prompt=$(node -p 'require(process.argv[1]).interface.defaultPrompt[0]' "$manifest")
agent_prompt=$(sed -n 's/^  default_prompt: "\(.*\)"$/\1/p' "$agent_manifest")
[ -n "$plugin_prompt" ] && [ "${#plugin_prompt}" -le 128 ] || fail 'plugin default prompt exceeds 128 characters'
[ "$plugin_prompt" = "$agent_prompt" ] || fail 'plugin and agent default prompts differ'

private_material_pattern="/""Users/|[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY"
for file in "$main" "$planning" "$runtime" "$supervision" "$manifest" "$agent_manifest"; do
  if sed 's/support@octopad\.ai//g' "$file" | grep -E "$private_material_pattern" >/dev/null 2>&1; then
    fail "private or identifying material appears in public file: ${file#$root/}"
  fi
done

node <<'NODE'
const assert = require('assert');
const crypto = require('crypto');

function routeDecision(role, model, effort, observed = true, available = true) {
  const automatic = (model === 'gpt-5.6-luna' && effort === 'max') ||
    (model === 'gpt-5.6-sol' && ['high', 'xhigh', 'max'].includes(effort));
  const roleAdmitted = role === 'worker' ? automatic :
    role === 'planner' ? model === 'gpt-5.6-sol' && ['xhigh', 'max'].includes(effort) :
    ['plan-reviewer', 'supervisor', 'delivery-reviewer'].includes(role) ?
      model === 'gpt-5.6-sol' && ['high', 'xhigh', 'max'].includes(effort) : false;
  return automatic && roleAdmitted && observed && available ? 'USE_EXACT' : 'PAUSE_NO_SUBSTITUTION';
}

assert.strictEqual(routeDecision('worker', 'gpt-5.6-luna', 'max'), 'USE_EXACT');
assert.strictEqual(routeDecision('planner', 'gpt-5.6-sol', 'xhigh'), 'USE_EXACT');
assert.strictEqual(routeDecision('plan-reviewer', 'gpt-5.6-sol', 'high'), 'USE_EXACT');
assert.strictEqual(routeDecision('supervisor', 'gpt-5.6-sol', 'max'), 'USE_EXACT');
assert.strictEqual(routeDecision('planner', 'gpt-5.6-sol', 'high'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('plan-reviewer', 'gpt-5.6-luna', 'max'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('worker', 'gpt-5.6-luna', 'high'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('worker', 'gpt-5.6-terra', 'max'), 'PAUSE_NO_SUBSTITUTION');
assert.strictEqual(routeDecision('supervisor', 'gpt-5.6-sol', 'high', false), 'PAUSE_NO_SUBSTITUTION');
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

function reviewedPacketFromDraft(draft) {
  return {
    ...draft,
    tasks: [...draft.tasks].sort((a, b) => a.ref.localeCompare(b.ref)),
    edges: [...draft.edges].sort((a, b) => `${a.from}:${a.to}`.localeCompare(`${b.from}:${b.to}`)),
  };
}

function reviewedPacketFromPersisted(persisted) {
  const refs = persisted.tasks.map(task => task.ref);
  if (refs.some(ref => !ref) || new Set(refs).size !== refs.length) return null;
  const byId = new Map(persisted.tasks.map(task => [task.id, task.ref]));
  const edges = persisted.edges.map(edge => ({
    from: byId.get(edge.fromId), to: byId.get(edge.toId), rationale: edge.rationale,
  }));
  if (edges.some(edge => !edge.from || !edge.to)) return null;
  return reviewedPacketFromDraft({
    brief: persisted.brief,
    tasks: persisted.tasks.map(({ref, title, description}) => ({ref, title, description})),
    edges,
    rules: persisted.rules,
  });
}

function reviewAdmitted(packet, receipt) {
  return receipt.verdict === 'PASS' && receipt.fingerprint === fingerprint(packet) &&
    receipt.reviewerTaskId !== receipt.plannerTaskId && receipt.sourceRulesSnapshot &&
    receipt.checks.length > 0 && routeDecision('plan-reviewer', receipt.model, receipt.effort,
      receipt.observed, true) === 'USE_EXACT';
}

const draft = reviewedPacketFromDraft({
  brief: 'integrated result',
  tasks: [
    {ref: 'E02', title: 'Integrate', description: '**Plan ref**\nE02'},
    {ref: 'E01', title: 'Build', description: '**Plan ref**\nE01'},
  ],
  edges: [{from: 'E01', to: 'E02', rationale: 'integration needs build'}],
  rules: 'rules@a1',
});
const persisted = {
  brief: draft.brief,
  tasks: [
    {id: 'generated-b', ref: 'E02', title: 'Integrate', description: '**Plan ref**\nE02', status: 'todo'},
    {id: 'generated-a', ref: 'E01', title: 'Build', description: '**Plan ref**\nE01', status: 'todo'},
  ],
  edges: [{fromId: 'generated-a', toId: 'generated-b', rationale: 'integration needs build'}],
  rules: draft.rules,
};
const packet = reviewedPacketFromPersisted(persisted);
assert.deepStrictEqual(packet, draft);
assert.strictEqual(fingerprint(packet), fingerprint(draft));
assert.notStrictEqual(fingerprint({...draft, tasks: persisted.tasks}), fingerprint(draft));
assert.strictEqual(reviewedPacketFromPersisted({...persisted, tasks: [...persisted.tasks, {...persisted.tasks[0], id: 'generated-c'}]}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, tasks: persisted.tasks.map(task => ({...task, ref: undefined}))}), null);
assert.strictEqual(reviewedPacketFromPersisted({...persisted, edges: [{fromId: 'unknown', toId: 'generated-b', rationale: 'bad'}]}), null);
const review = {
  verdict: 'PASS', fingerprint: fingerprint(packet), plannerTaskId: 'plan-1', reviewerTaskId: 'review-1',
  sourceRulesSnapshot: 'rules@a1', checks: ['scope', 'proof'], model: 'gpt-5.6-sol', effort: 'high', observed: true,
};
assert.strictEqual(reviewAdmitted(packet, review), true);
assert.strictEqual(reviewAdmitted({...packet, rules: 'rules@b2'}, review), false);
assert.strictEqual(reviewAdmitted(packet, {...review, reviewerTaskId: 'plan-1'}), false);
assert.strictEqual(reviewAdmitted(packet, {...review, observed: false}), false);

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
  if (inReviewedPlan) return 'USE_REVIEWED_PLAN';
  return requiredByRule || requiredByOutcome ? 'REPLAN_BEFORE_BUILD' : 'REJECT_SCOPE_EXPANSION';
}

assert.strictEqual(persistentVerifierDecision({}), 'REJECT_SCOPE_EXPANSION'); // A new generic CI harness.
assert.strictEqual(persistentVerifierDecision({requiredByRule: true}), 'REPLAN_BEFORE_BUILD');

function verificationRecovery(failedRoutes) {
  return failedRoutes.length >= 2 ? 'HANDOFF_EVIDENCE_GAP' : 'TRY_NEXT_SAFE_ROUTE';
}

assert.strictEqual(verificationRecovery([{actor: 'worker', route: 'local-postgres'}]), 'TRY_NEXT_SAFE_ROUTE');
assert.strictEqual(verificationRecovery([
  {actor: 'worker', route: 'local-postgres'}, {actor: 'reviewer', route: 'container-postgres'},
]), 'HANDOFF_EVIDENCE_GAP');

function specInstruction({hasOutcome, hasConstraint, prescribesTechnique = false,
  verifiedTrap = false, namesPrecedent = false, precedentFits = false}) {
  if (!hasOutcome || !hasConstraint) return 'REVISE';
  if (prescribesTechnique && !verifiedTrap) return 'REVISE';
  if (namesPrecedent && !precedentFits) return 'REVISE';
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

function verificationPlacement({requiresLogin = false, requiresThirdPartySeat = false,
  requiresUndrivableUi = false, accessAvailable = true}) {
  return !accessAvailable && (requiresLogin || requiresThirdPartySeat || requiresUndrivableUi) ?
    'PROTECTED_CHECKPOINT' : 'VERIFY';
}

assert.strictEqual(verificationPlacement({requiresLogin: true, accessAvailable: false}), 'PROTECTED_CHECKPOINT');
assert.strictEqual(verificationPlacement({requiresThirdPartySeat: true, accessAvailable: false}), 'PROTECTED_CHECKPOINT');
assert.strictEqual(verificationPlacement({requiresUndrivableUi: true, accessAvailable: false}), 'PROTECTED_CHECKPOINT');
assert.strictEqual(verificationPlacement({requiresLogin: true, accessAvailable: true}), 'VERIFY');

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
  if (!hasOwner || ownerStarted || ownerClosed) return 'REPLAN';
  return 'COMMENT_ON_OWNER';
}

assert.strictEqual(routeMintedWording({hasOwner: true, ownerStarted: false}), 'COMMENT_ON_OWNER');
assert.strictEqual(routeMintedWording({hasOwner: true, ownerStarted: true}), 'REPLAN');
assert.strictEqual(routeMintedWording({hasOwner: true, ownerClosed: true}), 'REPLAN');
assert.strictEqual(routeMintedWording({hasOwner: false, ownerStarted: false}), 'REPLAN');

function supervisorCloseEvidence({callReturned = false, authoritativeConfirmation = false,
  identity, checks, outcome, retriesRecorded = true}) {
  return (callReturned || authoritativeConfirmation) && identity && checks.length > 0 && outcome && retriesRecorded ?
    'CLOSE_EVIDENCED' : 'KEEP_OPEN';
}

assert.strictEqual(supervisorCloseEvidence({callReturned: false, identity: null,
  checks: ['test'], outcome: 'PASS'}), 'KEEP_OPEN');
assert.strictEqual(supervisorCloseEvidence({callReturned: true, identity: 'review-1',
  checks: ['test'], outcome: 'PASS'}), 'CLOSE_EVIDENCED');
assert.strictEqual(supervisorCloseEvidence({authoritativeConfirmation: true, identity: 'review-1',
  checks: ['test'], outcome: 'PASS'}), 'CLOSE_EVIDENCED');

function clearanceValid(checkpoint, artifact) {
  return checkpoint.subject === artifact.subject && checkpoint.version === artifact.version &&
    checkpoint.owner === artifact.owner && checkpoint.evidence && checkpoint.invalidated !== true;
}

const clearance = {subject: 'pr', version: 'sha-a', owner: 'alex', evidence: 'approval-1', invalidated: false};
assert.strictEqual(clearanceValid(clearance, {subject: 'pr', version: 'sha-a', owner: 'alex'}), true);
assert.strictEqual(clearanceValid(clearance, {subject: 'pr', version: 'sha-b', owner: 'alex'}), false);
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

function replacementAllowed(dispatch, evidence) {
  return dispatch.state === 'terminal' && evidence.predecessorStopped && evidence.effectsQuiescent;
}

const prepared = prepareDispatch({key: 'd-1', role: 'worker', octopadTaskId: 'E01', nativeTarget: 'project-a', route: 'luna-max'});
const ambiguous = createOnce(prepared, {});
assert.strictEqual(ambiguous.decision, 'RECONCILE_NATIVE_READ');
assert.strictEqual(createOnce(ambiguous, {taskId: 'native-2'}).decision, 'PAUSE_DUPLICATE_CREATE');
const created = createOnce(prepared, {taskId: 'native-1'});
assert.strictEqual(bindDispatch(created, {taskId: 'native-1', nativeTarget: 'project-b', octopadTaskId: 'E01', route: 'luna-max'}).decision, 'PAUSE_BINDING_MISMATCH');
const bound = bindDispatch(created, {taskId: 'native-1', nativeTarget: 'project-a', octopadTaskId: 'E01', route: 'luna-max'});
assert.strictEqual(bound.state, 'bound');
assert.strictEqual(replacementAllowed({...bound, state: 'terminal'}, {predecessorStopped: true, effectsQuiescent: true}), true);
assert.strictEqual(replacementAllowed({...bound, state: 'terminal'}, {predecessorStopped: false, effectsQuiescent: true}), false);
assert.strictEqual(replacementAllowed(bound, {predecessorStopped: true, effectsQuiescent: true}), false);

function rotateLease(current, expectedUpdatedAt, successorTaskId, evidence) {
  if (current.updatedAt !== expectedUpdatedAt) return {decision: 'CAS_CONFLICT'};
  if (!evidence.safeBoundary || !evidence.effectsQuiescent) return {decision: 'PAUSE_NOT_QUIESCENT'};
  return {
    ownerTaskId: successorTaskId, generation: current.generation + 1, goalId: null,
    status: 'acquired-no-goal', updatedAt: `${current.updatedAt}-next`, predecessorFenced: true,
  };
}

const lease = {ownerTaskId: 'sup-1', generation: 3, goalId: 'goal-old', updatedAt: 't1'};
assert.strictEqual(rotateLease(lease, 'stale', 'sup-2', {safeBoundary: true, effectsQuiescent: true}).decision, 'CAS_CONFLICT');
assert.strictEqual(rotateLease(lease, 't1', 'sup-2', {safeBoundary: true, effectsQuiescent: false}).decision, 'PAUSE_NOT_QUIESCENT');
const rotated = rotateLease(lease, 't1', 'sup-2', {safeBoundary: true, effectsQuiescent: true});
assert.strictEqual(rotated.ownerTaskId, 'sup-2');
assert.strictEqual(rotated.generation, 4);
assert.strictEqual(rotated.goalId, null);
assert.strictEqual(rotateLease(rotated, 't1', 'sup-3', {safeBoundary: true, effectsQuiescent: true}).decision, 'CAS_CONFLICT');

function ambiguousEffect(evidence) {
  if (!evidence.authoritative) return 'PAUSE_AFFECTED_BRANCH';
  if (evidence.observed === 'present') return 'RECORD_RECEIPT';
  if (evidence.observed === 'absent' && evidence.sameKeyRetryAvailable) return 'RETRY_SAME_KEY_ONCE';
  return 'PAUSE_AFFECTED_BRANCH';
}

assert.strictEqual(ambiguousEffect({authoritative: true, observed: 'present'}), 'RECORD_RECEIPT');
assert.strictEqual(ambiguousEffect({authoritative: true, observed: 'absent', sameKeyRetryAvailable: true}), 'RETRY_SAME_KEY_ONCE');
assert.strictEqual(ambiguousEffect({authoritative: false, observed: 'absent', sameKeyRetryAvailable: true}), 'PAUSE_AFFECTED_BRANCH');
assert.strictEqual(ambiguousEffect({authoritative: true, observed: 'unknown'}), 'PAUSE_AFFECTED_BRANCH');

function completionAllowed(state) {
  return state.integratedProof && state.planFingerprintMatches && state.versionBoundGatesValid &&
    state.activeTasks === 0 && state.activeDispatches === 0 && state.unresolvedActions === 0 &&
    state.leaseOwnerMatches && state.goalObjectiveAchieved;
}

const complete = {integratedProof: true, planFingerprintMatches: true, versionBoundGatesValid: true,
  activeTasks: 0, activeDispatches: 0, unresolvedActions: 0, leaseOwnerMatches: true, goalObjectiveAchieved: true};
assert.strictEqual(completionAllowed(complete), true);
for (const field of ['integratedProof', 'planFingerprintMatches', 'versionBoundGatesValid', 'leaseOwnerMatches', 'goalObjectiveAchieved']) {
  assert.strictEqual(completionAllowed({...complete, [field]: false}), false);
}
for (const field of ['activeTasks', 'activeDispatches', 'unresolvedActions']) {
  assert.strictEqual(completionAllowed({...complete, [field]: 1}), false);
}

function reviewSession({materialChange, stableFindings}) {
  if (materialChange) return 'ONE_NEW_FRESH_REVIEW';
  return stableFindings ? 'SAME_REVIEWER_TARGETED_RECHECK' : 'NO_EXTRA_REVIEW';
}
assert.strictEqual(reviewSession({materialChange: false, stableFindings: true}), 'SAME_REVIEWER_TARGETED_RECHECK');
assert.strictEqual(reviewSession({materialChange: true, stableFindings: true}), 'ONE_NEW_FRESH_REVIEW');

function supervisorRoute({heavyPlanning, contextThinning, unrelatedGoal}) {
  return heavyPlanning || contextThinning || unrelatedGoal ? 'FRESH_SUPERVISOR' : 'CURRENT_TASK';
}
assert.strictEqual(supervisorRoute({heavyPlanning: false, contextThinning: false, unrelatedGoal: false}), 'CURRENT_TASK');
assert.strictEqual(supervisorRoute({heavyPlanning: true, contextThinning: false, unrelatedGoal: false}), 'FRESH_SUPERVISOR');
assert.strictEqual(supervisorRoute({heavyPlanning: false, contextThinning: true, unrelatedGoal: false}), 'FRESH_SUPERVISOR');

console.log('PASS: Octoplan 17 adversarial routing, graph, review, proof recovery, gate, dispatch, lease, effect, and completion fixtures');
NODE

latest_changelog=$(awk '/^## octoplan-codex$/ { found=1; next } found && /^### / { sub(/^### /, ""); sub(/ — .*/, ""); print; exit }' "$root/CHANGELOG.md")
[ "$latest_changelog" = "$skill_version" ] || fail 'latest Codex changelog version differs from the skill'

printf 'PASS: Octoplan Codex 17.2.0 lean contract\n'
