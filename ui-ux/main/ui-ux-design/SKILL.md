---
name: ui-ux-design
description: Design, build, review or improve web, mobile and desktop interfaces: pages, components, interaction, accessibility and design systems. Use ui-ux-visual-reference for image comps and brand-identity for logos or brand kits.
license: MIT; upstream notices in licenses/
---

# UI/UX Design

The primary interface skill. Load only the references the task needs.

## 1. Read the context

Read the brief, project instructions, existing UI, dependencies, brand assets, and any `DESIGN.md` or design-system files. Identify the surface, audience, main action, platform and stack. Keep the project's conventions unless the request changes them.

The brief and the project's accepted design beat catalogs and presets. Search results are candidates, not decisions. There are no blanket bans on fonts, colors or layouts, but accessibility and working interactions are always required.

For a new visual direction, state a short design read first: mood, hierarchy, layout, density, motion. Dashboards want stable structure and efficient density; marketing pages can vary more. Don't add cinematic motion or image generation to routine fixes.

## 2. Pick the mode

| Task | Read |
|---|---|
| New interface or new visual direction | [search-guide.md](references/search-guide.md), then [art-direction.md](references/art-direction.md) |
| Focused interaction, accessibility or layout issue | One domain search, plus a stack search if needed |
| Redesign of an existing interface | [redesign.md](references/redesign.md) |
| Named brand as inspiration | [brand-library.md](references/brand-library.md), then only that brand's file |
| Tokens or a `DESIGN.md` handoff | [design-system.md](references/design-system.md) |
| Delivery or review | [verification.md](references/verification.md) |

Styles such as minimalist, soft, editorial or industrial are choices inside this skill. Pick one.

## 3. Search

`SKILL_DIR` is the absolute directory of this file. Run from anywhere with Python 3 (standard library only):

```bash
python3 "${SKILL_DIR}/scripts/search.py" "analytics dashboard operational" --design-system --json
python3 "${SKILL_DIR}/scripts/search.py" "error summary validation" --domain ux --json
python3 "${SKILL_DIR}/scripts/search.py" "dialog focus restore" --stack react --json
```

Check that the category, product and platform of the top result fit. If not, retry once with a narrower query; then fall back to your own judgment and say so. Catalog contrast claims don't replace checking the rendered UI.

## 4. Build and verify

- Reuse existing components, tokens, icons and dependencies. Check installed versions before adding packages.
- Keep copy editable and controls working. Cover loading, empty, error, disabled and success states.
- Sample data must look like sample data; never fake testimonials, customers or metrics.
- Respect framework boundaries, clean up listeners and animations, and keep continuous animation out of broad re-renders. Use CSS or the project's motion library; GSAP is optional.
- Check representative widths, keyboard use and reduced motion, using [verification.md](references/verification.md).

Report what was built, what was checked and what wasn't. Never claim accessibility conformance, performance scores or exact fidelity from a checklist alone.
