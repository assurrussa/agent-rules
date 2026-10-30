---
name: frontend-project-rules
description: Use when creating, changing, or reviewing application and website interfaces to keep them intuitive, simple, visually polished, accessible, and convenient without losing functionality.
---

# Frontend Project Rules

Apply these rules to interface work. Direct user instructions, local project
rules, and verified product contracts take precedence.

## Simplify The Experience, Not The Product

- Make interfaces intuitive, simple, visually polished, and convenient while
  preserving functionality, data integrity, accessibility, and security.
- Keep primary actions and the next useful step visible. Reveal noncritical
  technical details progressively; never hide critical warnings or safeguards.
- Explain choices in the user's task language. Do not make users understand
  internal versions, implementation states, or control flow to finish a task.
- Use clear hierarchy, readable spacing, and consistent visual treatment;
  remove clutter rather than adding decoration that competes with the task.

## Make Behavior Predictable

- Reuse shared components and conventions for buttons, menus, dialogs, forms,
  and notifications instead of creating one-off behavior for each screen.
- Give icon-only controls accessible names and helpful tooltips; do not rely
  on decorative icons, hover, or color alone to explain an action or state.
- Make menus dismiss on outside click, Escape, selection, and navigation.
  Keep dialog Close/Cancel predictable; protect unsaved work before dismissal.
- Put useful help beside fields and show clear, actionable errors and progress.
  Preserve entered data and manual work on failures; never imply guaranteed success.

## Verify The Whole Journey

- Test the affected task from entry to completion, not just an isolated screen:
  include repeated actions, loading, empty/error states, recovery, Cancel/Back,
  navigation, keyboard access, and relevant mobile layouts.
- Check that visual simplification preserves existing capabilities, critical
  warnings, product invariants, and user work. Report verification limits.
