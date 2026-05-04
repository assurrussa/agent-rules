---
name: docs-project-rules
description: Global documentation rules for durable project docs, architecture overlays, task notes, contract-focused wording, conclusion-first debug reports, and keeping project-specific details out of shared rules.
---

# Docs Project Rules

Use these rules when creating, reviewing, or updating project documentation.
Local doc style and direct user instructions always win.

## What To Document

- Document ownership, contracts, invariants, supported workflows, and caller-
  visible behavior.
- Update docs when adding or changing public routes, schemas, config keys,
  modules, lifecycle runners, background jobs, release gates, or reusable
  boundaries.
- Prefer durable explanations over implementation narration that will drift.
- Keep command catalogs and concrete paths in project docs, not global rules.

## Global Vs Project Overlay

- Shared docs rules should not name one repository, deployment tool, task name,
  environment key, generated path, or private module.
- Project overlays should hold concrete commands, module layout, generated
  paths, local framework conventions, release gates, and runtime contracts.
- When extracting a lesson from one repo, first decide whether it applies to at
  least two or three projects. If not, keep it local.

## Review And Audit Output

- Put the conclusion first, then evidence.
- For doc-set reviews, review each requested document separately when the user
  asks for per-document confidence.
- When a document is not sign-off ready, say what blocks sign-off and provide
  concrete replacement wording when useful.
- Avoid restating field lists from debug artifacts; explain what the artifact
  proves and what remains unknown.

## Task Notes

- Use task notes for large, interruptible work when the project requests them.
- Task notes should capture original requirements, decisions, current state,
  completed work, blockers, and exact next checks.
- Keep task notes concise. They are for recovery and coordination, not a second
  implementation.

## Editing Discipline

- Keep docs-only changes docs-only unless the user expands scope.
- Do not copy large code or generated output into docs when a stable contract or
  command reference is enough.
- If a doc claims something about runtime behavior, verify against code,
  contracts, config, or logs before treating it as current truth.
