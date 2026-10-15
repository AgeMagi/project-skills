---
name: brand-identity
description: Create or refine brand identities, logos, brand guidelines, brand-kit boards and standalone campaign assets such as banners. Not for interface styling or UI screen comps.
license: MIT; upstream notices in licenses/
---

# Brand Identity

## 1. Establish or keep the identity

Read supplied logos, guidelines, palette, fonts, references and the requested deliverables. For a new identity, define category, audience, promise, personality and a visual metaphor. For a campaign asset or consistency review, reuse the existing identity; don't invent a new logo.

Specify only useful rules: color roles and values, licensed font roles, logo variants and clear space, imagery, voice, sample applications. Keep proposals separate from the accepted identity. Never override an established brand because a catalog suggests something else.

## 2. Search the local catalogs

`SKILL_DIR` is the absolute directory of this file. Python 3, standard library only:

```bash
python3 "${SKILL_DIR}/scripts/logo/search.py" "technology precise modern" --design-brief -p "Brand Name"
python3 "${SKILL_DIR}/scripts/logo/search.py" "negative space minimal" --domain style
python3 "${SKILL_DIR}/scripts/cip/search.py" "business card letterhead" --domain deliverable --json
python3 "${SKILL_DIR}/scripts/cip/search.py" "consulting professional" --cip-brief -b "Brand Name" --json
```

Logo domains: `style`, `color`, `industry`. Identity domains: `deliverable`, `style`, `industry`, `mockup`. Results are candidates. Retry a poor query once, narrower; then use your own judgment and say so. Check catalog formats and sizes against current requirements.

## 3. Make the deliverable

| Deliverable | Do |
|---|---|
| Logo | One simple, meaningful idea: monogram, product action, metaphor, negative space or construction geometry. Check it small and in one color. |
| Guidelines | Document identity and voice with real values and examples, in the project's doc format. |
| Brand-kit board | Read [brand-boards.md](references/brand-boards.md). |
| Stationery, packaging, applications | Search the deliverables and carry one identity across them. A mockup is not a production file. |
| Banner or social asset | Read [campaign-assets.md](references/campaign-assets.md). Don't build a whole brand program unless asked. |

Use the runtime's image generation for bitmap concepts and vector/code tools for editable SVG or code assets. A raster concept is not a vector master or production-ready.

## 4. Verify and deliver

Check logo consistency, legibility, contrast, palette, font availability and coherent application. Never distort supplied assets, copy a reference brand's mark, or imply concept mockups show real customers.

For exports, check actual dimensions, crop, font loading and the final file. Label each output as concept, editable source or production file, and name any missing formats. Follow the project's file conventions.
