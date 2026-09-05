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

Use `$find-docs` for version-sensitive library, framework, SDK, API and CLI
questions. It selects an available documentation tool, resolves the version and
owns query limits and fallback. Reuse applicable docs already fetched in this
task. Ordinary refactors, scripts, business logic and reviews need no lookup
unless an external API contract is the unresolved question.


## Shared Agent Context

Use `$project-context-router` for cross-project context after local grounding.
Resolve the shared root through `AGENT_CONTEXT_ROOT` or the skill resolver.
Local verified docs and code remain the source of truth.

When shared context is needed, follow `streams/AGENTS.md` and its query route.
Reuse already loaded root rules, PII policy and glossary. Open the known hub
and only the topic relevant to the task:

- `streams/wiki/platforms/agent-rules.md`

For integration work, open only the affected neighbour hub:

- `streams/wiki/platforms/skillhub.md`

Use `streams/wiki/index.md` only to locate an unknown area or answer an overview
question. This is a task router, not a mandatory list of wiki pages.


If the wiki disagrees with local evidence, report the drift. Update the shared
page only when documentation upkeep is in scope, after verification.
