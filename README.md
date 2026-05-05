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

This repository is a recommended Skillhub source. `skillhub` owns discovery,
search, TUI selection, installation targets, and updates; this repository owns
only the shared skill content and catalog.

Install `skillhub` first:

```sh
curl -fsSL https://raw.githubusercontent.com/assurrussa/skillhub/main/install.sh | sh
```

Fresh Skillhub installs start with no active sources. Add this repository from
the recommended defaults, then search or install skills:

```sh
skillhub sources defaults list
skillhub sources defaults add agent-rules
skillhub search go
skillhub install rules-selector go-project-rules
```

Open the interactive selector:

```sh
skillhub tui
```

Install into a project instead of the global Codex-compatible skills directory:

```sh
skillhub install rules-selector go-project-rules --target codex --scope project --project /path/to/project
```

Inspect installed skills:

```sh
skillhub installed list
skillhub targets detect --project /path/to/project
```

Update Skillhub itself without modifying installed skills:

```sh
skillhub update
skillhub version
```

## Local Skillhub Checks

When testing this checkout before publishing, point Skillhub at the local
`agent-rules` directory instead of cloning from GitHub:

```sh
tmp=$(mktemp -d)
SKILLHUB_CONFIG_DIR="$tmp/config" \
SKILLHUB_AGENT_RULES_PATH="$PWD" \
skillhub sources defaults add agent-rules

SKILLHUB_CONFIG_DIR="$tmp/config" \
SKILLHUB_AGENT_RULES_PATH="$PWD" \
skillhub search go

SKILLHUB_CONFIG_DIR="$tmp/config" \
SKILLHUB_AGENT_RULES_PATH="$PWD" \
AGENT_SKILLS_DIR="$tmp/skills" \
skillhub install rules-selector
```

## Update Flow

1. Edit or add skills under `skills/`.
2. Update `catalog/skills.tsv`.
3. Run `sh scripts/check.sh`.
4. Use the local Skillhub check above when install behavior matters.
5. Use `skillhub update` on host machines to refresh the Skillhub tool.
6. Use `skillhub install ...` or `skillhub tui` to refresh installed skills.
7. Open a new Codex session or reload skills if the client supports it.

Keep this repository free of project-specific overlays. Local projects should
reference these skills as global baselines and keep only their concrete
commands, paths, frameworks, and release/runtime contracts in the project repo.
