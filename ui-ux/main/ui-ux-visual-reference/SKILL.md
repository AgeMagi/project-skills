---
name: ui-ux-visual-reference
description: Generate raster website comps or mobile screen concepts and extract generated designs for implementation handoff. Use when the requested deliverable includes new UI reference imagery. Supplied-reference implementation and runtime comparison belong to match-ui-reference; ordinary interface fixes need no image generation, and identity boards belong to brand identity.
license: MIT; upstream notice in licenses/
---

# UI/UX Visual Reference

Consolidates Taste's web image, mobile image, and generated-image-to-code workflows. Choose the deliverable before generating anything: images only, generated-design handoff, or a requested implementation from the generated concepts.

## Start from the requested artifact

Read the supplied brief and references. Identify product purpose, audience, platform, required sections/screens, intended aspect ratio, and any established design system. Reuse an existing reference when it already expresses the user's intent. Do not regenerate a supplied screenshot to make it easier to analyze.

For image creation, use the runtime's image-generation capability and its applicable instructions. If unavailable, provide the achievable analysis or prompt/handoff and identify the missing image output. Do not install a provider or ask for an API key solely because upstream scripts mention one.

## Generate a coherent set

Lock a compact shared specification: palette, type roles, spacing, shapes, imagery, icon language, surface treatments, and navigation. Each section/screen should have a purpose. Carry this specification and relevant prior images into subsequent generations so the set retains one identity.

Read [web-comps.md](references/web-comps.md) for website frames or [mobile-screens.md](references/mobile-screens.md) for app concepts. Use separate readable frames when multiple sections or screens need individual inspection. Follow the requested count. When no count is given, choose enough frames to explain the requested concept rather than automatically expanding it into a six- or eight-image project.

Generate details or revisions only when a concrete ambiguity or defect justifies them. A regenerated close-up may change the design; preserve the original reference and distinguish intentional revisions from observed detail. Never claim to have recovered exact text or measurements through fresh generation.

Keep text sparse enough to render legibly, copy specific, and evidence honest. Avoid tiny fictional dashboards, fabricated customer proof, meaningless badges, repeated filler layouts, and nested containers without purpose. User-chosen centered heroes, fonts, purple palettes, and visual styles remain valid.

## Inspect and deliver

Actually inspect each image before delivery: readability, hierarchy, spacing, control clarity, crop, palette, and continuity. Fix visible defects within the requested scope. Present images with their screen/section purpose and clearly identify them as concepts rather than implemented interfaces.

For implementation from generated concepts, read [image-to-code.md](references/image-to-code.md). Extract visible structure and distinguish observed details from inferred behavior. Implement only when code is part of the request; images-only requests finish with images. Do not embed a whole UI comp as an image in place of working controls. For supplied-reference acceptance and measured runtime comparison, use the project's existing matching workflow rather than generating a competing reference.
