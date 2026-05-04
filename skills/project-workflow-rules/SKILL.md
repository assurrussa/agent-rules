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

- Run the narrowest check that proves the change while iterating.
- Before claiming completion, run the validation command that matches the
  changed surface and read its output.
- If full verification is unavailable, say exactly what ran, what did not run,
  and what risk remains.
- Do not hide unrelated failures with broad suppressions; report them separately.

## Progress Notes

- For large or interruptible work, keep a concise task note in the project's
  preferred task/docs location when the repo asks for one.
- Progress notes should preserve requirements, decisions, completed steps,
  current blockers, and next validation commands. Keep them short enough to
  stay useful.
