---
name: docs-project-rules
description: Write, review, and edit project documentation for human readability, precise contracts, verified claims, durable project context, and conclusion-first reports.
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

## Human Readability

Write for the reader's task. A runbook should help someone act; a design note
should explain a decision and its trade-offs. Choose detail and structure
accordingly.

- Lead with the answer or purpose and give the context needed to understand it.
  Use connected paragraphs for explanations, numbered steps for sequences, and
  lists or tables when readers need to scan or compare.
- Name the actor, action, condition, and observable result when they matter.
  Prefer concrete verbs to noun-heavy abstractions. Split sentences when
  ownership or cause becomes unclear.
- Remove inflated significance, promotional adjectives, empty transitions,
  generic disclaimers, and repeated conclusions when they add no information.
  Keep useful summaries, necessary warnings, and specific limitations.
- Use the same term for the same concept. Explain necessary jargon for the
  intended reader; do not rotate technical terms just for variety.
- Use headings and emphasis to aid navigation. Avoid turning every sentence
  into a labelled bullet. Match the destination's markup and document language.
- Treat stock contrasts, ornamental triplets, and excessive punctuation as
  review cues, not automatic defects. Do not use word blacklists or AI-detector
  scores as acceptance criteria, or add mistakes to sound human.

For example, given only the verified fact that a client retries a timed-out
request once, replace "The client provides seamless, reliable recovery" with
"The client retries a timed-out request once." Do not add a retry delay,
backoff policy, or promise of eventual success without evidence.

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
- In a style-only rewrite, preserve requirement strength, negations, exceptions,
  identifiers, commands, numbers, units, and ordering constraints. Flag
  ambiguity rather than silently choosing a new contract.
- Make claims only as specific as the evidence allows. Do not invent metrics,
  causal explanations, or references to improve the prose. Label illustrative
  examples and unresolved gaps.
- Check that each new or changed citation supports its associated claim; a
  working URL alone is insufficient. Use precise attribution rather than
  unnamed expert consensus.

Before handing off, read the changed passage without the chat context: can the
intended reader understand the behavior, decision, or next action? Compare its
technical meaning with the original and the evidence, including limitations
and distinctions between planned, implemented, tested, and deployed behavior.

Editorial reference: [Wikipedia: Signs of AI-generated text (Russian)](https://ru.wikipedia.org/wiki/Википедия:Признаки_сгенерированности_текста).
Use the essay as a source of editing cues, adapted to project documentation;
its observations do not establish authorship or replace local style rules.
