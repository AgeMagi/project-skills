---
name: match-ui-reference
description: "Implement or check UI against supplied reference images using real runtime captures and scoped measurements. Web and mobile; the bundled helpers need macOS and iOS Simulator."
---

# Match a UI reference

Written requirements and supplied images are the acceptance criteria. A screenshot never authorizes invented behavior. Honor review-only requests and keep surrounding behavior and shared consumers intact.

## 1. Define acceptance

Record the required screens, states and regions; what may differ; what must be preserved; and capture conditions: device or viewport, OS/browser, density, theme, orientation, locale, text scale, route, fixtures, keyboard and scroll position. Choose RGB or geometry as the pass signal before measuring.

## 2. Capture the real target

Read the implementation and tokens. Run the real app or page from the right checkout in a deterministic state, using the project's fixture or direct-entry path; test fixtures never bypass production authorization. Use the available browser or simulator tools; iOS is not assumed.

## 3. Compare and fix

Capture, compare the same region, look at the images and metrics, and classify each difference: required, allowed, dynamic or unexplained. Make the smallest authorized fix and repeat.

- Mask only regions that are irrelevant or dynamic. Never hide a required feature or loosen thresholds to pass.
- Where media under an overlay is meant to differ, measure the overlay's geometry and treat RGB as diagnostic.
- A high overall score doesn't prove a small icon is right.

For bundled measurements, crops, masks, color samples or feature geometry, read [references/comparison.md](references/comparison.md). On macOS with Xcode, [scripts/compare_simulator.sh](scripts/compare_simulator.sh) captures a booted iPhone and runs [scripts/compare_ui.swift](scripts/compare_ui.swift); the comparator also accepts browser or Android screenshots. Run the scripts from the installed skill folder. Elsewhere, use the project's own capture tools and report missing evidence.

Run focused behavior and preservation checks. Goldens catch regressions but don't replace the reference or live captures; explain intended visual changes before regenerating them.

## Report

Pass/fail per requirement, capture setup, reference and output paths, measured region, tolerances, resizing and masks, actual metrics, remaining mismatches and checks run. Don't say pixel-perfect when any difference was tolerated or excluded.
