---
name: rules-selector
description: Analyze a repository and recommend which shared agent-rules skills to install from catalog/skills.tsv through skillhub. Use when choosing rules for a project, onboarding a host machine, listing applicable skills, or preparing an install command. It must recommend commands and avoid installing unless explicitly asked.
---

# Rules Selector

Use this skill to recommend a minimal shared rules set for a project. The source
catalog is `catalog/skills.tsv` in the `agent-rules` repository. Use `skillhub`
for search and installation; this source repository should not own installer
UX.

## Workflow

1. Inspect project signals before recommending:
   - `AGENTS.md`, `README.md`, docs indexes, task files
   - `go.mod`, `go.work`
   - `package.json`, frontend framework config
   - `composer.json`, `pyproject.toml`, `Cargo.toml`
   - public schemas, OpenAPI/protobuf files, release docs
2. Read or search `catalog/skills.tsv` from the shared rules repo.
3. Recommend the smallest skill set that fits the current project.
4. Output the exact `skillhub` install command.
5. Do not run install commands or mutate `$HOME` unless the user explicitly
   asks you to install.

## Selection Rules

- Always consider `project-workflow-rules` for non-trivial repositories.
- Select `go-project-rules` when the project has `go.mod`, `go.work`, Go test
  commands, Go services, or Go library work.
- Select `reusable-module-rules` when the project publishes or embeds modules,
  has public package surfaces, uses local replacements for library checks, or
  has external consumer fixtures.
- Select `docs-project-rules` when the task involves docs, onboarding, audits,
  architecture notes, task notes, debug reports, or project overlays.
- Keep project-specific rules in the project repo. Do not recommend moving
  concrete task names, env keys, private module names, or deployment paths into
  shared skills.

## Output Shape

Start with a short verdict, then list recommended skills and the command:

```text
Recommended shared rules:
- project-workflow-rules: non-trivial repo workflow baseline
- go-project-rules: Go module detected via go.mod

Install:
sh /path/to/skillhub/scripts/skills.sh install project-workflow-rules go-project-rules
```

If no install is needed, say why and point to the local project overlay that
already owns the relevant rules.
