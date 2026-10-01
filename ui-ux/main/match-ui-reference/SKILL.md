---
name: match-ui-reference
description: "Implement or compare UI against supplied visual references using real runtime captures and scoped measurements. Supports web and mobile; bundled capture/comparison helpers target macOS and iOS Simulator."
---

# Match a UI reference

Treat written requirements and supplied images as acceptance evidence. A screenshot does not authorize invented product behavior. Honor review-only requests and preserve surrounding behavior and shared consumers.

Record required screens/states/regions, what may differ, behavior to preserve, and capture conditions: device/viewport, OS/browser, density, theme, orientation, locale, text scale, route, fixtures, keyboard and scroll position. Choose an RGB or geometry acceptance signal before tuning measurements.

Inspect the actual implementation and design tokens. Launch the real app or page from the correct checkout in a deterministic state. Use the project's existing fixture/direct-entry path when available, keeping test fixtures separate from production authorization. Use available browser or simulator tools; do not assume iOS is the target for every project.

Capture the live target, compare the same region, inspect images and metrics, classify required/allowed/dynamic/unexplained differences, and iterate on the smallest authorized fix. Mask only explicitly irrelevant or dynamic regions; never hide a required feature or relax thresholds to manufacture a pass. For intentionally different media beneath an overlay, measure overlay geometry and use RGB diagnostically. A high aggregate score does not prove a small icon is correct.

Read [references/comparison.md](references/comparison.md) when using bundled image measurements, crops, masks, color samples or feature geometry. On macOS with Xcode, [scripts/compare_simulator.sh](scripts/compare_simulator.sh) captures a booted iPhone and invokes [scripts/compare_ui.swift](scripts/compare_ui.swift). Run helpers from their installed skill location; they resolve sibling files automatically. The Swift comparator also accepts already-captured browser/Android images. Other platforms use existing project capture/comparison tooling; report missing runtime evidence honestly.

Run focused behavior/preservation checks. Goldens are regression evidence, not a replacement for the user's reference or real runtime captures. Inspect and explain intended visual changes before regenerating them.

Report whether requirements passed, capture configuration, reference and artifact paths, measurement scope and tolerances, resizing/masks, actual metrics, remaining mismatches and checks run. Do not say pixel-perfect when differences were tolerated or excluded.
