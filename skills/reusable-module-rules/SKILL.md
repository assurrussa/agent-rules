---
name: reusable-module-rules
description: Global reusable-module and library-boundary rules for public facades, supported import surfaces, host integration, clean consumer probes, release readiness, and avoiding local replace-based false confidence.
---

# Reusable Module Rules

Use these rules when extracting, publishing, embedding, or validating a module
that should be reused outside its source repository. Local release docs and
module-specific contracts always win.

## Public Surface

- Define the supported public surface deliberately: package paths, facade types,
  schemas, config keys, feature registries, CLI flags, and documented extension
  points are contracts.
- Prefer a stable facade for embedding and extension instead of asking callers
  to import internal packages.
- If an internal behavior becomes necessary for external callers, expose a
  narrow public contract rather than widening import allowances.
- Keep generated outputs synchronized with their source contracts.

## Host And Library Ownership

- The reusable module should own reusable behavior, invariants, migrations or
  contract sources that belong to the module, and its built-in runtime flows.
- The host project should own process wiring, concrete infrastructure clients,
  environment mapping, deployment topology, and project-specific features.
- Host adapters should map local config/dependencies into the public facade.
  They should not reimplement module internals.
- Keep identifier roles distinct across host and module boundaries.

## Compatibility Checks

- Local workspace files, path replacements, and in-repo fixtures prove
  checkout-level compatibility only.
- External readiness requires a clean consumer that resolves the intended
  published version without local path overrides.
- Prefer machine-checkable surfaces: manifest files, import-policy checks,
  public-surface smoke tests, or external consumer probes.
- Use project-local release gates when they exist, but do not present them as
  proof of publication unless they test a clean published dependency.

## Migration And Fallbacks

- Make compatibility reads, fallback writes, and dual ownership temporary and
  explicit. Tie them to a migration plan or remove them.
- Do not hide fallback reads inside repositories or adapters if they affect the
  public contract or ownership model.
- Operations that must keep canonical data and host projections in sync should
  share one explicit transaction boundary when the storage layer supports it.

## Documentation

- Document supported imports, host responsibilities, required dependencies, and
  release/readiness gates.
- Keep one-host paths, task names, env keys, and deployment details in the host
  overlay, not in global reusable-module rules.
