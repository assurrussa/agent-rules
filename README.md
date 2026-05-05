# Agent Rules

Shared agent skills and reusable project rules. This repository is the content
source for rules; installation, search, sync, target selection, and TUI UX live
in `skillhub`.

## What Is Here

- `AGENTS.md` — instructions for agents editing this repository.
- `catalog/skills.tsv` — machine-readable index of the skills in this repo.
- `docs/adding-skill.md` — contribution guide for adding shared skills.
- `skills/project-workflow-rules/SKILL.md` — reusable workflow baseline for
  scoped changes, source-of-truth order, verification, and dirty worktrees.
- `skills/go-project-rules/SKILL.md` — reusable Go project baseline for
  architecture, boundaries, config, context, constructors, lifecycle, testing,
  generated code, and documentation upkeep.
- `skills/reusable-module-rules/SKILL.md` — reusable module and host/library
  boundary baseline.
- `skills/docs-project-rules/SKILL.md` — durable documentation and project
  overlay baseline.
- `skills/rules-selector/SKILL.md` — project analyzer that recommends which
  shared skills to install.
- `scripts/check.sh` — repository validation for skill folders, frontmatter,
  and catalog consistency.
- `templates/SKILL.md` — starter template for new shared skills.

Project-specific repositories should keep their own `AGENTS.md` or docs overlay
for concrete commands, module paths, frameworks, generated paths, release gates,
and deployment contracts.

## How Agents Should Use This Repo

- Treat `skills/*/SKILL.md` as the source of truth for reusable guidance.
- Treat installed copies under assistant-specific directories as generated
  outputs, not editable source.
- Use `catalog/skills.tsv` to discover available skills, categories, triggers,
  and descriptions without scanning every skill body.
- Keep global skills generic. Do not add one-project paths, command names,
  environment keys, deployment tools, generated file paths, or private module
  names.
- Put concrete project workflow details in that project's `AGENTS.md` or docs
  overlay instead.

## Why The Catalog Exists

`catalog/skills.tsv` is the stable machine-readable contract for tools and
agents. It answers:

- which skills exist;
- which category each skill belongs to;
- which project signals should trigger a recommendation;
- what short description can be shown in selectors and reviews.

The catalog is intentionally small. It should point to skill directories; it
should not become a second copy of the skill instructions.

Current catalog columns:

```text
name    category    triggers    description
```

`name` must match `skills/<name>/`. `category`, `triggers`, and `description`
are for discovery and recommendation.

Current category taxonomy:

- `architecture`
- `backend`
- `data`
- `documentation`
- `frontend`
- `go`
- `security`
- `testing`
- `tooling`
- `workflow`

## Why The Script Exists

`scripts/check.sh` is the local quality gate for this content repository. It
keeps the catalog and skill folders in sync and catches basic structural drift
before the repo is consumed by tools.

Run it after editing skills or catalog rows:

```sh
sh scripts/check.sh
```

## Update Flow

1. Edit or add skills under `skills/`.
2. Update `catalog/skills.tsv`.
3. Follow `docs/adding-skill.md` and start from `templates/SKILL.md` for new
   skills.
4. Run `sh scripts/check.sh`.
5. Run `git diff --check`.
6. If install behavior matters, verify it through `skillhub`; keep the detailed
   Skillhub workflow in the `skillhub` repository.

Keep this repository free of project-specific overlays. Local projects should
reference these skills as global baselines and keep only their concrete
commands, paths, frameworks, and release/runtime contracts in the project repo.

## Skillhub Boundary

`skillhub` may consume this repository as a source, but this repository should
not duplicate Skillhub's command documentation. Keep Skillhub usage, update
flow, target adapters, install metadata, and TUI behavior documented in the
`skillhub` repository.
