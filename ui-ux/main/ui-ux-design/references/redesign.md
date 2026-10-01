# Improve an existing interface

Start from the existing product. Inspect representative screens, routes, shared components, tokens, styles, interaction states, assets, and dependencies. If rendering is available, establish a visual baseline before editing.

Describe concrete findings with their effects: unclear primary action, inconsistent spacing, clipped labels, unreadable text, broken keyboard flow, dead destinations, layout drift, missing states, or repeated components with incompatible styling. Distinguish defects from intentional brand choices. Do not classify an established font or purple palette as a defect merely because a style preset dislikes it.

Use the smallest change that meets the brief. Typography hierarchy, spacing rhythm, contrast, and shared component states often give the highest return with limited disruption. Recompose a hero or replace structural blocks when the problem calls for it. A visual refresh is not automatically a framework migration, new motion engine, information-architecture rewrite, or copy rewrite.

Preserve functioning behavior, data contracts, route slugs, navigation meaning, form identifiers, analytics hooks, accessibility behavior, and supplied identity unless the requested change includes them. For a request that legitimately changes these, account for downstream behavior rather than silently treating it as cosmetic.

Audit shared components before patching individual screens. Align repeated card titles, pricing features, numeric values, and actions where comparison benefits from alignment. Keep product content and business evidence accurate; do not invent more realistic dates or metrics.

Re-render at the baseline sizes and inspect the affected flow. Verify that responsive layout, focus, form handling, and states remain usable. Report the problems fixed and any areas that could not be exercised. A before/after screenshot comparison is useful when the environment supports it.
