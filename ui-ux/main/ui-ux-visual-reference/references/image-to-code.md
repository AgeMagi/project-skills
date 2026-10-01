# Translate a visual reference into an interface

Inspect supplied/generated references at useful resolution. Record the following where observable:

| Area | Extract |
|---|---|
| Structure | Section/screen order, grids, alignment, containers, reading order |
| Text | Readable headings, labels, CTAs, relative size/weight, line wrapping |
| Space | Outer gutters, padding, gaps, section rhythm, media proportions |
| Surfaces | Color roles, borders, radii, shadow/elevation, background treatment |
| Components | Button hierarchy, navigation, fields, lists, chips, visible state |
| Assets | Image crop, illustration language, icon family, real provided logos |

State uncertainty where exact fonts, colors, pixels, or text cannot be established. Approximate a coherent system from visible relationships. Do not invent OCR certainty, adopt garbled generated copy, or treat a newly generated detail as evidence about an older image. If the user supplied exact copy, preserve it unless a rewrite was requested.

Use semantic elements, editable text, actual assets, and functional components. Rebuild layout relationships, typography hierarchy, spacing, media frames, and section rhythm faithfully. Keep the established stack and dependencies unless the task requires changing them. Do not substitute a generic card template simply because it is convenient.

Static references do not specify hover, focus, loading, errors, or responsive behavior. Infer these from the product, existing system, and platform conventions, and identify material inference. For implementation, apply interface-specific checks through the runtime's applicable UI skill or the project's own workflow.

Render at the reference viewport and compare the actual result with the source. Inspect a narrow layout and the main interactive path as well. Correct meaningful visual drift rather than pursuing false pixel precision. Report observed fidelity and any missing assets or unverified interactions.
