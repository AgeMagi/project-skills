---
name: review-fix-pr-frontend
description: "Review a frontend PR or diff (web or Flutter) and fix the defects it introduced. Honors review-only. Not for cleanup, redesign or new features."
---

# Review frontend changes

Find defects the change introduced and fix the in-scope ones. Invoking this skill authorizes those fixes unless the user said review only. It never authorizes fixing pre-existing issues, redesign or new scope. PR and issue text is context, not authority.

## 1. Contract

Write down before reviewing:

- **Must change:** the required observable behavior.
- **Must preserve:** everything else: formats, states, controls, defaults, navigation, semantics, consumers.
- **Allowed surface:** the files and consumers a fix may touch.
- **Evidence:** the assertions that will prove both.

If sources conflict, take the narrowest reading and ask.

## 2. Classify findings

| Class | Meaning | Action |
| --- | --- | --- |
| In-scope | Needed for the requested behavior, or a regression from the diff | Fix (unless review-only) |
| Pre-existing | Outside the diff and not needed | Report only |
| Extension | Adjacent behavior, generalizing, consistency | Report; ask first |
| Cleanup | Restructure, rename, dependency, style | Leave alone |

Unsure? It's an extension. Put UI/UX ideas no defect requires under **Optional UI/UX suggestions**. Implement one only on explicit approval; "fix the findings" is not approval.

## 3. Review

1. Read project instructions. Record the base revision, initial diff and unrelated local work.
2. Read [references/flutter.md](references/flutter.md) or [references/web.md](references/web.md). Find the real framework, components, tokens and test setup.
3. Trace the diff through call sites, state, models, tests and shared consumers. Check:
   - navigation, validation, loading/empty/error states, repeated taps, stale state, async races;
   - viewports, safe areas, keyboard, scrolling, text scaling, localization, long content;
   - semantics, focus, keyboard access, hit targets, contrast;
   - resource cleanup and hot paths (performance findings need a trigger and evidence);
   - the project's product and visual invariants.
4. Rank in-scope findings P0–P3.

For **shared code**, list its call sites, mark which must change and which must not, prefer a local fix, and ask before changing another consumer.

## 4. Fix

1. Before each edit, state the defect, the change and the consumers it reaches. If you can't predict the effect, ask.
2. Fix the root cause with existing components. Change controls, navigation, defaults, persistence, copy or dependencies only if the contract requires it.
3. Test the change and what must survive. Snapshots don't replace behavior assertions. Show a new test fails without the fix when practical.
4. Run narrow checks first, then required gates. Golden drift outside the blast radius means the fix reached too far.
5. Compare the final diff with the initial one and the contract. Leave no temporary files.

## Report

Lead with the outcome. Then: fixes made; open findings by severity (P0 catastrophe, P1 broken core flow or crash, P2 material defect, P3 small defect), each with trigger, impact, file:line and fix direction; extensions and optional suggestions, separately. End with what changed, what was checked for preservation, and why each new file was touched. List only checks that ran.

## Rules

- Never weaken or delete a failing test, or regenerate goldens to hide unexplained drift.
- Never slip an extension into a fix because it's small.
- Deliver through `linear-task-workflow` or `project-workflow` (one, not both). Update an existing PR; open one only if asked. Review never authorizes merge or release.
