# Adding Shared Skills

Use this guide when adding or changing shared rules in this repository.

## What Belongs Here

A rule belongs in `agent-rules` when it is reusable across several projects and
helps an agent make better decisions without project-local context.

Good candidates:

- source-of-truth order;
- architecture and dependency direction principles;
- documentation and review output rules;
- reusable module boundaries;
- testing and verification expectations;
- project analysis heuristics.

Keep out:

- one-project paths, package names, task names, release gates, generated paths,
  private module names, deployment tools, and environment keys;
- commands that only work in one repository;
- examples that make a global rule depend on one host project.

Put those details in the owning project's `AGENTS.md` or docs overlay instead.

## Skill Shape

Each skill lives in:

```text
skills/<skill-name>/SKILL.md
```

Use lowercase names with hyphens:

```text
frontend-project-rules
security-review-rules
```

Do not nest install names under categories. Use `catalog/skills.tsv` category
metadata for grouping. If the source tree later needs nested folders, add a
catalog path field in a separate contract change; keep installed skill names
flat unless target adapters prove nested paths are supported.

## Catalog Row

Every skill needs one row in `catalog/skills.tsv`:

```text
name<TAB>category<TAB>triggers<TAB>description
```

Column rules:

- `name` must match `skills/<name>/`.
- `category` should use the shared taxonomy from `README.md`.
- `triggers` is a comma-separated list of repo signals or task signals.
- `description` should be short enough for selectors and reviews.

Keep the catalog sorted by `category`, then `name`.

## Writing Rules

- Start from `templates/SKILL.md`.
- Make the frontmatter `name` match the directory.
- Write the description as trigger metadata: when should an agent use this?
- Keep `SKILL.md` focused on durable rules and decisions.
- Prefer `Do` / `Do Not` guidance over long examples.
- Add references only when the skill would otherwise become too large.

## Validation

Run:

```sh
sh scripts/check.sh
git diff --check
```

If installation behavior matters, test through `skillhub`; keep the exact
Skillhub workflow documented in the `skillhub` repository, not here.

