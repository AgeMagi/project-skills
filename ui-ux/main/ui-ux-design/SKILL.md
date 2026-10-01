---
name: ui-ux-design
description: Design, implement, review, and improve web, mobile, and desktop interfaces. Combines searchable UX and stack guidance with intentional art direction, design tokens, and preservation-aware redesign. Use for pages, components, interaction, accessibility, and interface design systems; use a visual-reference skill for raster comps and a brand-identity skill for creating logos or brand kits.
license: MIT; upstream notices in licenses/
---

# UI/UX Design

Use this as the primary interface skill. It combines UI UX Pro Max's local search engine, Taste's visual and redesign judgment, and selected Awesome DESIGN.md analyses. Load supporting material only for the current task.

## Establish the direction

Read the brief, relevant project instructions, existing UI, dependencies, brand assets, and any `DESIGN.md` or design-system master/page overrides. Identify the surface, audience, main action, platform, and implementation stack. Preserve the project's established conventions unless the requested change requires otherwise.

The user's brief and accepted project design take precedence over catalogs and aesthetic presets. Treat all retrieved recommendations as candidates. Accessibility and working interactions remain requirements when adapting a reference. A brand-inspired surface can use its requested colors, fonts, centered layouts, and contrasting sections; there are no blanket bans on those choices.

For a new visual direction, state a short design read: mood, hierarchy, layout, density, and motion. Optional variance/motion/density dials run from 1–10; infer them from the task rather than applying a universal high-motion preset. Product dashboards usually need stable structure and efficient density; marketing pages can support more composition variety. Do not add cinematic motion or image generation to routine component fixes.

## Choose the relevant mode

| Task | Load and use |
|---|---|
| New interface or substantial visual direction | [search-guide.md](references/search-guide.md), then [art-direction.md](references/art-direction.md) |
| Focused interaction, accessibility, or layout issue | One relevant domain search; a separate detected-stack search if needed |
| Existing interface redesign | [redesign.md](references/redesign.md); apply art direction to the requested surfaces |
| Named brand inspiration | [brand-library.md](references/brand-library.md); read the selected analysis only |
| Tokens or `DESIGN.md` handoff | [design-system.md](references/design-system.md) |
| Delivery or review | [verification.md](references/verification.md) |

Style variants such as minimalist, soft, editorial, and industrial are choices within this skill, not additional skills to activate together. The search catalog supplies further styles and platform guidance.

## Search from the skill's own directory

Resolve `SKILL_DIR` to the absolute directory containing this `SKILL.md`. Use the full script path, independent of the target project's working directory:

```bash
python3 "${SKILL_DIR}/scripts/search.py" "analytics dashboard operational" --design-system --json
python3 "${SKILL_DIR}/scripts/search.py" "error summary validation" --domain ux --json
python3 "${SKILL_DIR}/scripts/search.py" "dialog focus restore" --stack react --json
```

Requires Python 3 and the standard library. Do not install the upstream CLI or configure a provider just to use local search. Use the smallest appropriate query mode; detailed domains, persistence behavior, and dials are in the search guide.

Check the returned category, product, platform, and top result before applying it. Retry an empty or mismatched search once with a narrower query. If still unsuitable, label general judgment as a fallback. Generated systems and catalog contrast claims do not replace inspecting the rendered interface.

## Implement and verify

Use existing components, tokens, icon families, and dependencies where they fit. Verify imports and installed versions before adding packages. Keep visible copy editable, assets appropriate, and controls functional. Implement applicable loading, empty, error, disabled, and success states. Mock data must be recognizable as sample data; do not fabricate customer endorsements or product claims for realism.

Keep a coherent token and component system. Match framework boundaries: isolate browser-only interaction where required, clean up animation/listener lifecycles, and keep continuous animation outside broad render-state updates. Choose CSS or a supported existing motion library according to the interaction; GSAP snippets are optional references, not a requirement to install GSAP.

Inspect the result at representative widths and with keyboard/reduced-motion behavior. Apply the verification reference to the actual surface. Report what was implemented, what was checked, and any unverified behavior. Do not claim accessibility conformance, performance scores, or exact visual fidelity based only on a checklist.
