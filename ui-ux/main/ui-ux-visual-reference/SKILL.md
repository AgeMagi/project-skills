---
name: ui-ux-visual-reference
description: Generate website or mobile UI concept images and turn generated designs into an implementation handoff. Use only when new UI imagery is requested; use match-ui-reference for supplied references and brand-identity for identity boards.
license: MIT; upstream notice in licenses/
---

# UI/UX Visual Reference

Decide the deliverable before generating: images only, a handoff, or code built from the concepts.

## 1. Start from the request

Read the brief and references. Note product purpose, audience, platform, required sections or screens, aspect ratio and any existing design system. Reuse a supplied reference when it already shows the intent; never regenerate it just to analyze it.

Use the runtime's image generation. If there is none, deliver the analysis or prompts and say images are missing. Don't install a provider or ask for API keys.

## 2. Generate a coherent set

Lock a short shared spec first: palette, type roles, spacing, shapes, imagery, icons, surfaces, navigation. Pass it, and earlier images, into each generation so the set looks like one product.

Read [web-comps.md](references/web-comps.md) for websites or [mobile-screens.md](references/mobile-screens.md) for apps. Give each section or screen its own readable frame. Make the number requested; if none, make only as many as the concept needs.

Regenerate only to fix a concrete defect. A regenerated close-up is a new design, not a zoom; never claim it recovered exact text or measurements.

Keep text sparse and legible, copy specific and claims honest. No tiny fake dashboards, invented customer proof, meaningless badges or filler layouts. The user's style choices stand.

## 3. Inspect and deliver

Look at every image before delivering: readability, hierarchy, spacing, controls, crop, palette, continuity. Fix visible defects. Label each image with its purpose and as a concept, not a built interface.

To build from the concepts, read [image-to-code.md](references/image-to-code.md). Separate what's visible from what's inferred. Write code only when it was requested, and never ship a whole comp as an image in place of working controls. Measured comparison against supplied references belongs to `match-ui-reference`.
