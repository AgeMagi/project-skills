---
name: brand-identity
description: Create or refine brand identities, logo concepts, brand guidelines, brand-kit boards, and standalone branded campaign assets such as banners. Combines local logo and corporate-identity catalogs with cohesive visual-board direction. Use for identity or branded asset deliverables; ordinary interface styling and UI screen comps belong to their interface skills.
license: MIT; upstream notices in licenses/
---

# Brand Identity

Combines Taste's brand-kit art direction with UI UX Pro Max's brand, logo, corporate identity, and banner workflows. Identity strategy, reusable rules, and identity applications are this skill's outputs; it does not prescribe a frontend framework or slide generator.

## Establish or preserve identity

Read supplied logos, guidelines, palette, typography, reference materials, and the requested deliverables. For a new identity, infer category, audience, promise, personality, and a meaningful visual metaphor. For a campaign asset or consistency review, reuse the existing identity instead of inventing a new logo.

Specify only useful rules: approved color roles and values, available/licensed font roles, logo variants/clear space, imagery, voice, and representative applications. Separate proposed concepts from accepted identity. Do not overwrite an established brand simply because a catalog suggests another palette.

## Local logo and identity search

Resolve `SKILL_DIR` to the absolute directory containing this file. The bundled read-only searches require Python 3 and the standard library:

```bash
python3 "${SKILL_DIR}/scripts/logo/search.py" "technology precise modern" --design-brief -p "Brand Name"
python3 "${SKILL_DIR}/scripts/logo/search.py" "negative space minimal" --domain style
python3 "${SKILL_DIR}/scripts/cip/search.py" "business card letterhead" --domain deliverable --json
python3 "${SKILL_DIR}/scripts/cip/search.py" "consulting professional" --cip-brief -b "Brand Name" --json
```

Logo domains: `style`, `color`, `industry`. Corporate identity domains: `deliverable`, `style`, `industry`, `mockup`. Use relevant matches as candidates, not automatic brand decisions. Narrow an empty/mismatched query once; identify general judgment as fallback if no applicable match remains. Catalog formats/dimensions are starting points and need verification for current publishing or production requirements.

## Choose the artifact

| Deliverable | Guidance |
|---|---|
| Logo direction | Develop a simple meaningful mark: monogram, product action, metaphor fusion, negative space, or construction geometry. Reduce complexity and inspect small-size/monochrome behavior. |
| Guidelines | Document identity and voice in the requested format, with actual approved values and examples; reuse project documentation conventions. |
| Brand-kit overview image | Read [brand-boards.md](references/brand-boards.md). |
| Stationery, packaging, identity applications | Search the requested deliverables; carry one identity across them. A mockup depicts an application, not a production file. |
| Standalone banner/social asset | Read [campaign-assets.md](references/campaign-assets.md); do not create a full brand program unless requested. |

Use the runtime's image-generation capability when a bitmap concept is needed. Use appropriate vector/code tools when the requested deliverable is an editable SVG or another code-native artifact. A raster concept is not a vector master; do not claim vector quality or production readiness from a generated board.

## Verify and deliver

Check logo consistency, legibility, contrast, palette, type availability, and coherent application. Use supplied identity assets without distortion. Do not imitate a reference brand's exact mark or pretend concept applications demonstrate real customers.

For exported assets, inspect actual dimensions, cropping, font loading, and the final file. Distinguish generated concepts, editable source, and production output. Deliver the requested formats and identify missing exports honestly. Use the project's file conventions rather than requiring a universal `assets/design-tokens.json` or provider-specific setup.
