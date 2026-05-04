# Agent Rules

Global Codex skills and rules shared across local repositories.

## What Is Here

- `catalog/skills.tsv` — machine-readable catalog consumed by `skillhub` and
  selector guidance.
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

Project-specific repositories should keep their own `AGENTS.md` or docs overlay
for concrete commands, module paths, frameworks, generated paths, release gates,
and deployment contracts.

## Use With Skillhub

This repository is the source of truth for shared rules. Use `skillhub` for
search and installation:

```sh
git clone git@github.com:assurrussa/skillhub.git
cd skillhub
sh install.sh
skillhub list
skillhub search go
skillhub install rules-selector go-project-rules
```

## Update Flow

1. Edit or add skills under `skills/`.
2. Update `catalog/skills.tsv`.
3. Run `sh scripts/check.sh`.
4. Use `skillhub` to install or refresh skills when needed.
5. Open a new Codex session or reload skills if the client supports it.

Keep this repository free of project-specific overlays. Local projects should
reference these skills as global baselines and keep only their concrete
commands, paths, frameworks, and release/runtime contracts in the project repo.
