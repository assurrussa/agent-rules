# Go Project Rules

Global Codex skills and rules for Go repositories.

## What Is Here

- `skills/go-project-rules/SKILL.md` — reusable Go project baseline for
  architecture, boundaries, config, context, constructors, lifecycle, testing,
  generated code, and documentation upkeep.

Project-specific repositories should keep their own `AGENTS.md` or docs overlay
for concrete commands, module paths, DI frameworks, generated paths, release
gates, and deployment contracts.

## Install Locally

```sh
sh scripts/install.sh
```

The script syncs `skills/go-project-rules` into:

```text
~/.agents/skills/go-project-rules
```

## Update Flow

1. Edit the skill in this repository.
2. Run `sh scripts/install.sh`.
3. Open a new Codex session or reload skills if the client supports it.

Keep this repository free of project-specific rules. Local projects should
reference this skill as the global baseline and keep only their overlays in the
project repo.
