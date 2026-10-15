---
name: add-simulated-app
description: "Add a simulated app preview/output format to an existing simulation product with researched layout, original rendering and fidelity evidence. Not for general mobile app creation or features inside an existing simulated surface."
---

# Add a simulated app format

Add a believable, original preview without changing existing previews or copying another product's assets or trade dress.

## 1. Contract

Confirm the new format is authorized. Read the destination's preview, model, persistence, export and disclosure contracts, then record:

- **Must change:** the new output and its model/rendering path.
- **Must preserve:** existing formats, export sizes, stored-draft compatibility, disclosure defaults and app chrome.
- **Allowed surface:** only the files the integration needs; don't refactor neighboring renderers.
- **Evidence:** focused behavior and layout checks, plus any requested visual or simulator evidence.

A platform variant of an app already simulated (for example Android of an iOS app) is a second surface in that app's existing contract, not a new app.

## 2. Research and document

Research public, observable evidence; use installed `research-ui-ux` for substantial research. Document the layout contract in the project's established location and routing docs. Include:

- a research record: sources, access dates, platform/version, states observed; published fact versus observation versus inference;
- whether it shares an existing data model or is an independent scene, and why;
- canvas, density, safe areas, header, content region, bottom controls and disclosure/export clearance;
- typography, spacing, color tokens and dark mode owned by the renderer;
- every metadata item (time, status, attachment, caption, reactions, separators) with one placement lane, an overflow policy and a long-content state;
- a maintenance note requiring same-change updates when the renderer contract changes.

Borrow conventions only. Widgets, icons, copy, colors and composition are original; never proprietary logos, assets or a competitor screen as a template.

## 3. Implement

Integrate through the existing path, not a parallel one: dispatch, draft model/codec/controller, editor, preview, deterministic fixtures and export. Keep tokens and geometry local to the new renderer unless shared behavior changes. Map shared data deliberately; another app's display rules don't carry over. Preserve stored drafts and unrelated renderers.

## 4. Prove

- Assert dispatch, persistence and drift-prone geometry (for example a time lane clear of a long attachment title).
- Add preservation coverage for any shared code you touched.
- Use goldens for intentional visual changes and installed `match-ui-reference` when supplied screenshots define acceptance.
- Update the contract with its source, token and test owners in the same change.

Report supported states, evidence and fidelity gaps.
