---
name: go-project-rules
description: Global Go project rules for architecture, package boundaries, dependency direction, configuration, context, constructors, lifecycle, testing, generated code, and documentation upkeep. Use when orienting in a Go repository, drafting or reviewing Go architecture rules, extracting repo-specific rules into reusable guidance, or deciding which Go project practices should be global versus local overlays.
---

# Go Project Rules

Use these rules as a global baseline for Go repositories. Local project
instructions always win: read `AGENTS.md`, `README.md`, `go.mod`, `go.work`,
`Taskfile.yml`, `Makefile`, CI workflows, and module-local docs before applying
or changing code.

## Source Of Truth Order

1. User request and current task scope.
2. Local project rules such as `AGENTS.md` and module docs.
3. Existing code patterns and tests in the package being changed.
4. These global Go rules.

Do not import project-specific assumptions from another repository. Treat
dependency injection frameworks, folder names, task commands, generated paths,
release gates, deployment topology, coverage thresholds, and environment key
names as local overlays.

## Repository Orientation

- Detect whether the checkout has a root `go.mod`, a `go.work`, or multiple
  independent Go modules.
- Run Go commands from the owning module directory unless the project provides a
  wrapper task.
- Prefer repository-provided commands for format, lint, test, code generation,
  and integration checks.
- If a command writes caches or temp files, use the repo's existing cache/tmp
  pattern instead of inventing a new one.
- A local module replacement, workspace file, or in-repository fixture proves
  checkout-level compatibility only. It does not prove that another project can
  consume a released module.

## Layering

- Keep process bootstrapping, configuration loading, and lifecycle setup out of
  domain logic.
- Keep transport adapters such as HTTP, CLI, cron, queue consumers, and event
  handlers at the boundary.
- Keep business rules in domain or application packages that do not depend on
  concrete transport packages.
- Keep infrastructure packages focused on concrete technical adapters such as
  SQL, Redis, storage, mail, metrics, and external clients.
- Generated code is output. Do not edit it by hand; change its source contract
  and regenerate.
- Reusable packages should expose intentional public facades. Do not make
  callers import unstable internals just because those internals are convenient
  inside the source repository.

## Dependency Direction

- Domain and use case code should depend on narrow contracts and plain data,
  not on concrete infrastructure, delivery, or framework packages.
- Define interfaces on the consuming side by default.
- Keep interfaces small and behavior-focused; avoid producer-owned interfaces
  that mirror a full concrete type.
- Inject cross-cutting collaborators explicitly instead of reaching into global
  state or package-level service locators.
- Avoid import cycles by moving shared contracts or DTOs toward the consumer
  boundary, not by adding generic utility packages.
- When one package embeds or extends another, keep the embedding boundary small:
  configuration mapping, concrete clients, and project-specific features belong
  to the host; reusable behavior belongs behind the reusable package facade.

## Application Wiring

- Keep application wiring in the composition layer. It may know about concrete
  implementations, module order, lifecycle registration, and process config.
- Do not let business packages depend on the composition container, service
  locator, or framework-specific registration APIs.
- Named, grouped, or keyed registrations are local wiring details. Document
  them in the project overlay when they affect extension points or tests.
- Stable extension points should be ordinary Go contracts or public facade
  types, not implicit knowledge of the composition container.

## Configuration And Environment

- Read environment variables and config files in one configuration layer.
- Downstream packages should receive typed config values or narrower option
  structs, not call `os.Getenv` directly.
- Keep public config keys and wire contracts documented when they are consumed
  outside one package.
- Do not silently change environment variable meaning or default paths; treat
  that as a contract change.
- Path defaults, service addresses, feature flags, and credentials are
  process-level inputs. Map them at the boundary and pass typed values inward.

## Constructors And Lifecycle

- Constructors should validate inputs and build values.
- Constructors should not start background loops, open long-lived processes, or
  hide lifecycle side effects.
- Long-lived work should be registered through the project's lifecycle runner,
  supervisor, worker group, or explicit `Start`/`Stop` API.
- Prefer defaults-first option handling: apply defaults, validate, then build.
- Required dependencies should be obvious from constructor parameters or a small
  required config struct.
- Startup hooks should resolve dependencies, register work, and return. They
  should not bury process ownership inside domain or adapter constructors.

## Context

- Pass `context.Context` explicitly as the first parameter on call paths that
  can block, perform I/O, or observe cancellation.
- Do not store request-scoped contexts in structs.
- Do not pass `nil` contexts; use `context.TODO()` only while threading the real
  context through legacy code.
- Do not replace a caller's context with `context.Background()` inside reusable
  libraries or request handlers.
- Derived contexts must be canceled on every path.
- Detached work may use a fresh context only when the operation intentionally
  outlives the caller. Bound that context with a timeout or lifecycle owner.

## HTTP, APIs, And Contracts

- Treat OpenAPI, protobuf, GraphQL schemas, public DTOs, CLI flags, and config
  keys as contracts.
- Change contract sources first, regenerate outputs, then update handlers and
  tests.
- Keep transport handlers thin: parse/validate boundary input, call use cases,
  map domain errors to transport responses.
- Version public APIs deliberately. Do not mix future desired behavior with
  current documented behavior.
- Public package paths, public facade types, feature registries, and documented
  import surfaces are also contracts for reusable modules.

## Data Access And Transactions

- Keep SQL and storage-specific query logic in repositories or adapters, not in
  handlers.
- Make transaction ownership explicit. A use case that requires atomic behavior
  should run the whole operation inside one transaction boundary.
- Do not hide fallback reads or compatibility writes in repositories unless the
  migration plan explicitly calls for them.
- Keep identifier roles distinct; avoid collapsing local primary keys, public
  IDs, external IDs, and canonical identity keys without a contract decision.
- Projection or read-model writes that must stay in sync with canonical writes
  should share one transaction boundary when the storage layer supports it.

## Errors And Logging

- Return errors to the layer that can handle them; do not log and return the
  same error.
- Wrap errors with operation context at boundaries where it helps diagnosis.
- Use stable sentinels or typed errors only when callers need to branch on them.
- Keep error strings lowercase and without trailing punctuation.
- Prefer structured logging at ownership boundaries over ad hoc prints.

## Testing

- Choose the smallest test scope that proves the behavior: unit, adapter,
  integration, or end-to-end.
- Build production-like wiring in tests unless the test intentionally replaces a
  dependency.
- Use explicit replacements, fakes, or mocks; avoid ad hoc partial wiring that
  bypasses the behavior under test.
- Test contract and failure behavior when APIs, storage, transactions,
  permissions, or background work change.
- Keep generated mocks and generated clients synchronized with their source
  interfaces/contracts.
- For reusable modules, include at least one consumer-shaped check that imports
  only the documented public surface.

## Formatting, Linting, And Generation

- Use the repository's formatter, import sorter, linter, and generator commands.
- Do not introduce a parallel lint or format workflow when a local wrapper
  already exists.
- Prefer focused verification while iterating, then run the project-level gate
  before claiming completion.
- If lint failures are unrelated to the change, report them separately instead
  of hiding them with broad suppressions.
- When changing generated contracts, verify both the contract source and the
  generated output. Do not claim completion from source edits alone.

## Reusable Modules

- Keep the supported public surface machine-checkable when possible: a manifest,
  smoke test, import policy, or clean external consumer probe is better than
  prose alone.
- Prefer stable public facades for embedding, extension, and host integration.
  If callers need an internal behavior, expose a deliberate contract instead of
  widening imports to unstable packages.
- Local workspace or `replace` success is not release readiness. External reuse
  requires a clean consumer to resolve the intended version without local path
  overrides.
- Keep reusable packages free of project-owned process wiring, deployment
  assumptions, private environment names, and one-host feature decisions.

## Documentation Upkeep

- Update architecture docs when adding modules, lifecycle runners, public
  routes, generated contracts, config keys, background jobs, or reusable package
  boundaries.
- Document invariants, ownership, and caller-visible behavior instead of copying
  implementation details that will drift.
- Separate global rules from project overlays. A reusable rule should not name a
  specific repo, DI framework, folder path, deployment tool, or release process.
- If a lesson depends on one project's module layout, command catalog, generated
  paths, or release process, put it in that project's overlay rather than this
  global skill.
