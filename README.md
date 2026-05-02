# Agent Rules

Global Codex skills and rules shared across local repositories.

## What Is Here

- `skills/go-project-rules/SKILL.md` — reusable Go project baseline for
  architecture, boundaries, config, context, constructors, lifecycle, testing,
  generated code, and documentation upkeep.

Project-specific repositories should keep their own `AGENTS.md` or docs overlay
for concrete commands, module paths, frameworks, generated paths, release gates,
and deployment contracts.

## Install Locally

```sh
sh scripts/install.sh
```

The script syncs every skill under `skills/*` into:

```text
~/.agents/skills/<skill-name>
```

## Update Flow

1. Edit or add skills under `skills/`.
2. Run `sh scripts/install.sh`.
3. Open a new Codex session or reload skills if the client supports it.

Keep this repository free of project-specific overlays. Local projects should
reference these skills as global baselines and keep only their concrete
commands, paths, frameworks, and release/runtime contracts in the project repo.
