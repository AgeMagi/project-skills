# Verify the actual interface

Use checks relevant to the changed surface. A static screenshot verifies appearance, not keyboard behavior, screen-reader output, or performance.

## Visual and responsive

Inspect a narrow phone, a medium layout, and the intended desktop size. Include zoom/larger text and long labels or identifiers. Check hierarchy, alignment, contrast, media crop, font loading, line wrapping, and fixed-element clearance. Labels and chip collections should reflow or offer an operable full-value disclosure. Avoid clipping meaningful text merely to preserve a preferred line count.

Confirm the interface uses accepted tokens and consistent component variants. Inspect each supported theme independently. Do not let sticky controls cover content or focused elements. Intentional horizontal regions, such as data tables, need clear scroll behavior and access to their contents.

## Interaction and accessibility

- Use native semantics and visible focus. Exercise the main path with a keyboard; focus order should match meaning and return appropriately from dialogs.
- Give controls accessible names and applicable state. Hide decorative icons from assistive technology; provide alternatives for meaningful images. Do not use color alone for status or chart series.
- Measure normal-text contrast at 4.5:1, large-text contrast at 3:1, and applicable non-text control/icon contrast at 3:1. Large-text thresholds depend on size and weight; do not label every 18px string as large text. Check composed/translucent backgrounds.
- Provide usable hit areas for the platform: iOS generally 44pt and Android 48dp. For web, assess the applicable target-size and spacing requirements; do not mechanically transplant native units into CSS.
- Forms need persistent labels, field errors, recovery, and preserved input. When applicable, provide a linked error summary after failed submission. Support password managers and paste.
- Exercise loading, empty, error, disabled, success, and rapid repeated actions where they exist. Cancelled animations must leave semantic state and focus correct.
- Check reduced motion, alternatives to drag/swipe-only actions, and pause/stop behavior for moving content where applicable. Information must remain available without animation.

For native UI, also inspect safe areas, system bars, gestures, Dynamic Type/text scaling, and portrait/landscape behavior. Use relevant UX and stack searches for a specific outcome rather than treating this list as a complete accessibility audit.

## Implementation and delivery

Check the affected build/type/lint path and relevant behavior tests according to the project. Validate links, imported packages, actual asset paths, and cleanup for effects/animation. Reserve image dimensions, avoid avoidable layout shifts, and inspect excessive render updates or costly effects when observed. Measure performance if making a quantitative claim.

Deliver the complete requested change, with accurate sample/production distinctions and no dead controls disguised as working features. State the verification performed and material limitations. A checklist does not establish WCAG conformance or Core Web Vitals scores.
