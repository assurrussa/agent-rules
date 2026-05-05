# Agent Rules Repository Instructions

This repository is the source of truth for shared Codex skills and reusable
agent rules. Keep it small, portable, and focused on rules content.

## Source Of Truth

1. User request and current task scope.
2. This `AGENTS.md`, `README.md`, and the actual files in this repository.
3. `skills/*/SKILL.md`, `catalog/skills.tsv`, and `scripts/check.sh`.
4. Installed copies under `~/.agents/skills` are outputs, not source.

Do not infer behavior from repository names alone. Inspect the relevant skill,
catalog row, script, or docs before changing rules.

## Repository Boundaries

- `skills/<name>/SKILL.md` holds reusable global guidance.
- `catalog/skills.tsv` is the machine-readable catalog consumed by `skillhub`.
- `docs/adding-skill.md` documents how to decide whether a new rule belongs
  here and how to add it.
- `scripts/check.sh` validates this source repository.
- `templates/SKILL.md` is the starting point for new shared skills.
- Search, list, sync, install, and future TUI UX belong in `skillhub`, not here.
- Do not add `install.sh`, `list.sh`, search scripts, cache management, or TUI
  code to this repository.
- Do not duplicate detailed `skillhub` usage in this repository. It is enough
  to document that `skillhub` consumes the catalog and owns installation.

Keep project-specific overlays out of shared skills. Concrete task names,
module paths, private package names, environment keys, generated file paths,
deployment tools, release gates, and host-specific conventions belong in the
project repository that owns them.

## Skill Editing Rules

- Keep existing skill identities stable unless the user explicitly asks for a
  rename.
- For a new skill, start from `templates/SKILL.md`.
- When adding or removing a skill, update `catalog/skills.tsv` in the same
  change.
- Keep `SKILL.md` frontmatter in sync with the directory name.
- Prefer durable principles and decision rules over one-project examples.
- If a lesson came from one project, include it only when it clearly applies to
  multiple projects; otherwise keep it local to that project.
- `rules-selector` may recommend exact `skillhub` commands, but it must not
  install anything unless the user explicitly asks.

## Validation

Run these before claiming a repository change is complete:

```sh
sh scripts/check.sh
git diff --check
```

When changing catalog or selector behavior, also verify through a local
`skillhub` checkout when it is available. Keep detailed smoke-test targets and
user-facing Skillhub commands in `skillhub`, not here.

## Context7

Use Context7 MCP to fetch current documentation whenever the user asks about a
library, framework, SDK, API, CLI tool, or cloud service. This includes API
syntax, configuration, version migration, library-specific debugging, setup
instructions, and CLI tool usage.

Do not use Context7 for refactoring, writing scripts from scratch, debugging
business logic, code review, or general programming concepts.
