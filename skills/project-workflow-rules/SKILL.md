---
name: project-workflow-rules
description: Global project workflow rules for scoped repo work, source-of-truth order, dirty worktrees, evidence-first answers, contract-change escalation, verification, and practical agent collaboration across codebases.
---

# Project Workflow Rules

Use these rules as the default workflow baseline for any repository. Local
`AGENTS.md`, project docs, and direct user instructions always win.

## Source Of Truth

1. User request and current task scope.
2. Local project instructions such as `AGENTS.md`, `README.md`, and docs.
3. Actual code, tests, schemas, generated contracts, logs, and task files.
4. These shared workflow rules.

Do not infer project behavior from names alone. Inspect the relevant files,
contracts, or runtime evidence before giving a repo-specific answer.

## Scope Control

- Keep changes inside the requested behavioral surface.
- Treat public APIs, schemas, CLI flags, config keys, routes, migrations, and
  persisted data semantics as contracts. Raise contract changes explicitly
  instead of sliding them into cleanup.
- Do not mix unrelated refactors, formatting churn, dependency upgrades, or
  repo-wide cleanup into a narrow fix.
- If the user marks a task as docs-only, keep code/config/wiring untouched.
- Prefer the simplest implementation that preserves required functionality;
  moving complexity out of sight is not simplification. Do not add speculative
  legacy compatibility. Before removing existing behavior, check actual use,
  contracts, and migration needs, and obtain any required approval.

## Preflight And Ownership

- Before expensive work, verify the current target branch, relevant dependency
  versions, required checks, and resource limits; check browser and safe fixture
  database availability when needed. Confirm authorization for the intended actions; do not use
  unverified database targets or external services as test fixtures.
- Use one integration owner. Give workers disjoint changes and explicit
  acceptance checks; check their status before waiting on dependent work.
- On resource-constrained environments, serialize memory-heavy build/test
  pipelines and limit worker concurrency instead of running competing stacks.
- Reuse authorization within its granted scope; do not ask the same permission
  again. New scope and actions requiring separate approval still need it.

## Working Tree Safety

- A dirty worktree may contain user work. Never revert, delete, or overwrite
  changes you did not make unless the user explicitly asks.
- If unrelated dirty files exist, leave them alone and mention only the files
  relevant to your work.
- If existing changes touch the same file, read them carefully and build on
  them instead of restoring the file.

## Evidence First

- For reviews, lead with concrete findings grounded in file/line references,
  logs, contracts, or test output.
- For debugging, state the current observed symptom, gather evidence, identify
  the failing boundary, then patch the smallest confirmed cause.
- For command output, report the meaningful lines or verdict. Do not assume the
  user can see terminal output.
- For broad orientation, answer from code and public contracts first, then docs.

## Verification

- Run the narrowest check that proves the change while iterating. Plan one
  full final validation pass after integration rather than repeating it for
  every intermediate edit. Always run explicitly required repository gates.
- After a later narrow edit, rerun affected tests/build and behavior checks;
  rerun broader gates when their inputs changed or repository rules require
  them. Earlier passing output is not proof for changed behavior.
- For UI changes, use a real browser to verify the whole affected user journey,
  including relevant mobile widths, errors, recovery, and repeated actions.
  Unit tests and a successful build do not prove visual or interaction quality.
- Before claiming completion, read final check output. State what passed,
  failed, or did not run and the remaining risk; do not hide unrelated failures
  with broad suppressions or describe focused checks as a full pass.

## External Operations

- Keep request payloads and status reads scoped to the needed files or fields;
  use bounded requests and a clear completion condition for long operations.
- If a write times out or its outcome is unknown, reconcile the remote state
  read-only before retrying. Never assume a missing response means no change.
- Retry only with evidence that the action did not execute and the retry
  addresses the cause. Honor denials; report the exact target, action, reason,
  and known state instead of bypassing restrictions or issuing blind retries.

## Progress Notes

- For large or interruptible work, keep a concise task note in the project's
  preferred task/docs location when the repo asks for one.
- Progress notes should preserve requirements, decisions, completed steps,
  current blockers, and next validation commands. Keep them short enough to
  stay useful.
