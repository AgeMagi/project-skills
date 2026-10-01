# Art direction and visual judgment

Adapted from Taste's frontend, minimalist, soft, industrial, and redesign guidance. These are contextual design choices, not universal prohibitions.

## Composition

Make the main action and information hierarchy apparent. Plan headline scale, container width, imagery, and CTA placement together. Keep the opening view useful on a small laptop and phone, while allowing content to reflow at zoom and larger text sizes. A desktop two-line heading can be a useful composition target; never clip copy or force fixed breaks to preserve it.

Give each marketing section a purpose: introduce, demonstrate, provide evidence, explain, or convert. Vary composition where content supports it. Centered type, image backgrounds, editorial grids, asymmetric splits, lists, and product demonstrations are all available. Avoid repeating the same split layout simply to fill a page. Product interfaces should favor predictable navigation and stable scan patterns over decorative novelty.

Use cards when they identify a group, interaction, or surface. Use spacing or dividers when a box adds no meaning. For an asymmetric grid, ensure every content item has an intentional place at every breakpoint. Preserve logical reading order; dense grid packing must not create a misleading visual order relative to keyboard and screen-reader order.

## Typography, surfaces, and assets

Choose available, properly licensed fonts that support the brand, content, and language. Existing Inter, system fonts, or serif typography can be correct. Differentiate through a deliberate hierarchy rather than font replacement alone. Body measure around 60–70 characters is a useful starting point for long prose. Use tabular figures for aligned numeric comparisons. Check descenders and actual font metrics before setting tight display line heights.

Use semantic palette roles, coherent neutral families, and predictable shape/elevation rules. Accent color serves hierarchy; success, warning, error, and chart series may need distinct semantic colors. Measure contrast against the composed background, especially translucent surfaces and image overlays. Alternating light/dark sections can be intentional when the reference and hierarchy support it.

Use real supplied assets or clearly identified concept assets. Keep media proportions stable and reserve layout space. Do not manufacture apparent proof with fictional customer logos, endorsements, reviews, or precise business metrics. Icons should share a compatible visual language and semantics; use the project's established family when suitable.

## Optional style directions

| Direction | Useful visual language | Adaptation limits |
|---|---|---|
| Minimal / editorial | Quiet surfaces, clear type contrast, generous measure, sparse borders, restrained accents | Avoid turning every control into tiny gray text; preserve visible states |
| Soft / dimensional | Diffuse elevation, layered surfaces, concentric nested radii, calm motion | Use layering selectively; excessive nested boxes and blur reduce clarity |
| Swiss industrial | Visible grid, square geometry, strong sans hierarchy, functional dividers | Keep reading text comfortable; large uppercase type is for selected display roles |
| Tactical / terminal | Dark substrate, technical type, restrained telemetry cues | Use genuine data and states; avoid invented revision codes, tiny labels, or distracting scanlines |
| Expressive marketing | Strong imagery, varied composition, deliberate typography, one narrative spine | Keep navigation, touch behavior, and primary actions straightforward |

Select one direction and adapt it across the requested surfaces. Do not stack multiple entire style protocols.

## Motion

Motion should explain feedback, hierarchy, continuity, or storytelling. Stable instant updates are appropriate for some interactions; nothing requires every element to animate. Prefer lightweight CSS for simple states. Use the existing motion library for more complex sequences and GSAP only where its timeline/scroll model fits.

Avoid blanket scroll hijacking and perpetual movement. Provide reduced-motion equivalents, pause/stop behavior where applicable, and access to content if animation fails. Keep critical content visible without waiting through a reveal. Use transform/opacity where suitable, profile expensive blur and filters, and limit `will-change` to active elements. Clean up observers, listeners, timelines, and animation contexts.

Fixed decorative layers must not obscure content or capture pointers. High-variance desktop layouts need an explicit narrow-screen layout, not a global `overflow-x: hidden` patch that hides broken content or focus rings.
