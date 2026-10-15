---
name: add-simulated-app
description: "Add a new simulated app preview format to an existing simulation product, with researched layout, original rendering and fidelity checks. Not for general app building or features inside an existing simulated app."
---

# Add a simulated app format

Add a believable, original preview without changing existing previews or copying another product's assets or trade dress.

## 1. Contract

Confirm the new format is authorized. Read the project's preview, model, persistence, export and disclosure contracts. Write down:

- **Must change:** the new output and its model/rendering path.
- **Must preserve:** existing formats, export sizes, stored drafts, disclosure defaults, app chrome.
- **Allowed surface:** only the files the integration needs. Don't refactor neighboring renderers.
- **Evidence:** behavior and layout checks, plus any requested visual or simulator evidence.

A platform variant of an app already simulated (Android of an iOS app) is a new surface in that app's existing contract, not a new app.

## 2. Research and document

Research public, observable evidence; use `research-ui-ux` for anything substantial. Write the layout contract where the project keeps them and add it to the routing docs. It covers:

- research record: sources, access dates, platform/version, states seen; fact vs observation vs inference;
- shared data model or independent scene, and why;
- canvas, density, safe areas, header, content, bottom controls, disclosure/export clearance;
- type, spacing, color tokens and dark mode, owned by the renderer;
- each metadata item (time, status, attachment, caption, reactions, separators): one placement lane, an overflow rule, a long-content state;
- a note that renderer changes update the contract in the same change.

Borrow conventions only. Widgets, icons, copy, colors and composition are original; never proprietary logos, assets or a competitor screen as a template.

## 3. Implement

Integrate through the existing path: dispatch, draft model/codec/controller, editor, preview, fixtures and export. Keep tokens and geometry local to the new renderer. Map shared data deliberately; another app's display rules don't carry over. Stored drafts and other renderers must keep working.

## 4. Prove

- Assert dispatch, persistence and drift-prone geometry (for example, a time label clear of a long attachment title).
- Add preservation tests for any shared code you touched.
- Use goldens for intentional visual changes, and `match-ui-reference` when supplied screenshots define acceptance.
- Record source, token and test owners in the contract.

Report supported states, evidence and fidelity gaps.
