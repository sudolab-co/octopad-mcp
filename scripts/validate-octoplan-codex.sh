#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill="$root/plugins/octoplan-codex/skills/octoplan"
runtime="$skill/references/codex-runtime.md"
planning="$skill/references/planning.md"
supervision="$skill/references/codex-supervision.md"
supervision_rel="plugins/octoplan-codex/skills/octoplan/references/codex-supervision.md"
manifest="$root/plugins/octoplan-codex/.codex-plugin/plugin.json"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

grep -q '^Version: 3\.0\.1$' "$skill/SKILL.md" || fail 'SKILL.md is not 3.0.1'
grep -q '"version": "3\.0\.1"' "$manifest" || fail 'plugin manifest is not 3.0.1'
grep -q '^  allow_implicit_invocation: false$' "$skill/agents/openai.yaml" || fail 'implicit invocation remains enabled'
grep -Fq 'Use only when a Codex user explicitly invokes $octoplan' "$skill/SKILL.md" || fail 'explicit invocation boundary is missing'
grep -Fq 'Do not use for general Octopad actions, organization connection, onboarding' "$skill/SKILL.md" || fail 'non-Octoplan exclusions are missing'
[ -f "$supervision" ] || fail 'conditional-supervision runtime is missing'
git -C "$root" ls-files --error-unmatch "$supervision_rel" >/dev/null 2>&1 || fail 'conditional-supervision runtime is not tracked'
[ ! -e "$skill/references/codex-relay.md" ] || fail 'legacy direct-relay runtime remains'

if grep -R -n 'Review: skip\|review is skipped\|review is skipped\|reviewer or directly' \
  "$skill/SKILL.md" "$planning" "$runtime" "$supervision" >/dev/null; then
  fail 'an active review-skip path remains'
fi

if grep -q 'durable completion or required review' "$planning"; then
  fail 'parallel continuation can bypass review'
fi

grep -q 'one fresh independent review' "$runtime" || fail 'mandatory fresh review is missing'
grep -q 'one reviewer by default' "$runtime" || fail 'single-review default is missing'
grep -q 'orthogonal' "$runtime" || fail 'orthogonal second-review gate is missing'
grep -q 'Specialist review route' "$planning" || fail 'task template lacks specialist review route'
grep -q 'Specialist review route' "$supervision" || fail 'supervision lacks specialist review support'
grep -q 'detection difficulty' "$runtime" || fail 'review routing is not detection-based'
grep -q 'immutable artifact revision' "$supervision" || fail 'review PASS is not revision-bound'
grep -q 'fresh recovery executor and full reviewer set' "$supervision" || fail 'dead executor recovery has no reviewable path'
grep -q 'why this route;.*mandate' "$planning" || fail 'review routes lack saved rationale and mandate'
grep -q '^Plan review:$' "$planning" || fail 'plan-review routing record is undefined'
grep -q 'Spawn exactly the saved lead and specialist' "$planning" || fail 'plan-review routing record is not read back'
grep -q 'Every PASS is persisted on the ledger and names the exact plan hash' "$planning" || fail 'plan-review PASS is not fingerprint-bound'

grep -q 'octoplan-supervision-v1' "$planning" || fail 'supervision contract schema is not planned'
grep -q '^Supervision contract:$' "$planning" || fail 'tracker supervision contract is undefined'
grep -q '^\*\*Fallback: ' "$planning" || fail 'task template lacks bounded fallback routing'
grep -q 'Default recovery:' "$planning" || fail 'contract lacks same-route recovery default'
grep -q 'Default lineage:' "$planning" || fail 'contract lacks immutable lineage default'
grep -q 'at least 2 required observations and exact count' "$planning" || fail 'fallback lacks auditable repeated evidence'
grep -q 'tracker stores only' "$planning" || fail 'supervision contract is copied into trackers'
grep -q '^## Fingerprint$' "$planning" || fail 'pre-consent fingerprint protocol is missing'
grep -q 'conditional supervision policy' "$runtime" || fail 'execution consent omits conditional supervision'
grep -q 'saved fallback' "$runtime" || fail 'execution consent omits saved fallback routes'

grep -q 'owner token' "$supervision" || fail 'supervisor owner token is missing'
grep -q 'supervisor epoch' "$supervision" || fail 'supervisor epoch is missing'
grep -q 'intent.*pending.*ready.*activated.*failed' "$supervision" || fail 'creation state machine is incomplete'
grep -q 'wait_threads' "$supervision" || fail 'native monitoring is missing'
grep -q 'Only the current fenced supervisor launches successors' "$skill/SKILL.md" || fail 'successor authority is not exclusive'
grep -q 'never launches a successor' "$supervision" || fail 'lead reviewer can still relay'
grep -q 'current supervision mode.*excluded' "$planning" || fail 'runtime mode would invalidate the plan fingerprint'
grep -q 'Plan manifest' "$supervision" || fail 'multi-stream recovery source is missing'
grep -q 'context, access, environment, and verifier' "$supervision" || fail 'fallback can misdiagnose non-capability failures'
grep -q 'never retry while creation is ambiguous' "$supervision" || fail 'uncertain creation can duplicate sessions'
grep -q 'Every supervisor, executor, reviewer, and recovery creation' "$supervision" || fail 'safe creation does not cover every role'
grep -q 'title and prompt with that full key and token' "$supervision" || fail 'native child identity is not recoverable'
grep -q 'reviewer verifies its activated creation record' "$supervision" || fail 'reviewers can work before activation'
grep -q 'Before work, after every wake, and before any write, PASS, or completion' "$supervision" || fail 'reviewers can write after supersession'
grep -q 'supervisor epoch 1' "$supervision" || fail 'fresh runs lack initialized ownership'
grep -q 'Every changed fingerprint, including hygiene' "$supervision" || fail 'plan changes can reuse stale consent'
grep -q 'at least four delivery tasks remain' "$supervision" || fail 'dedicated-parent size gate is missing'
grep -q 'unserialized frontier' "$supervision" || fail 'unsaved parallel work can launch'
grep -q 'activate the whole group in one guarded transition' "$supervision" || fail 'parallel children can start before group readiness'
grep -q 'actual model and effort equal the saved inline route' "$supervision" || fail 'resume can substitute a supervisor route'
grep -q 'dedicated-replacement bound' "$supervision" || fail 'dedicated-parent recovery is unbounded'
grep -q 'spawn_agent.*never user-owned threads' "$runtime" || fail 'plan review creates unapproved user threads'

review_section=$(sed -n '/^## Review routing$/,/^## Execution consent$/p' "$runtime")
printf '%s\n' "$review_section" | grep -q 'gpt-5\.6-luna · effort high' || fail 'Luna high is unreachable for review'
printf '%s\n' "$review_section" | grep -q 'gpt-5\.6-luna · effort xhigh' || fail 'Luna xhigh is unreachable for review'
printf '%s\n' "$review_section" | grep -q 'gpt-5\.6-terra · effort high' || fail 'Terra high is unreachable for review'
printf '%s\n' "$review_section" | grep -q 'gpt-5\.6-terra · effort xhigh' || fail 'Terra xhigh is unreachable for review'

terra_max_count=$(grep -c 'gpt-5\.6-terra · effort max' "$runtime" || true)
[ "$terra_max_count" -ge 2 ] || fail 'Terra max is not reachable for execution and review'

grep -q 'executor or reviewer' "$runtime" || fail 'Sol reviewer lacks a cheaper-route inadequacy gate'
grep -Fq 'combines objectively specified implementation with qualitative product, UX, editorial, semantic, or cross-domain acceptance' "$runtime" || fail 'mixed-task routing has no observable trigger'
grep -Fq 'Route execution through the full rubric using only choices the executor must originate' "$runtime" || fail 'mixed-task execution and review are conflated'
grep -Fq 'distinguishes choices the executor must originate from review-only judgment' "$planning" || fail 'mixed-task rationale is not auditable'

printf 'PASS: octoplan-codex routing contract\n'
