---
name: example-rules
description: Use when an agent needs reusable guidance for a specific class of project work; mention the project signals, task types, and decisions this skill should influence.
---

# Example Rules

Use this skill when the current task matches the frontmatter description.
Local repository rules and direct user instructions always win.

## Source Of Truth

- User request and explicit task scope.
- Local `AGENTS.md`, project docs, contracts, and tests.
- Current repository code and generated artifacts.
- This shared skill as a fallback for reusable guidance.

## Use When

- The same rule applies across several projects.
- The guidance affects agent decisions, review output, implementation shape, or
  verification.
- The rule can be written without naming one private project or host-specific
  command.

## Rules

- State durable principles and invariants.
- Prefer concrete decision rules over broad advice.
- Keep examples generic unless a real project example is essential and safe to
  generalize.

## Do Not

- Do not include one-project paths, task names, private package names,
  deployment tools, environment keys, generated paths, or release gates.
- Do not duplicate project overlays that belong in local `AGENTS.md`.
- Do not add install, sync, search, or TUI instructions here.

## Validation

- Check that the skill name matches the folder and catalog row.
- Check that the catalog triggers describe when the skill should be suggested.
- Run the repository validation script before publishing.

