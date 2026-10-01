# Design-system source of truth

Use the project's existing token files, theme configuration, `DESIGN.md`, or master/page overrides. Create a new document only when the task needs a reusable handoff; do not create parallel token authorities for a small component fix.

For a substantial new system, separate raw primitives from semantic roles. Add component aliases when they clarify state or variant behavior:

```css
:root {
  --blue-600: #2563eb;
  --action-bg: var(--blue-600);
  --action-fg: #ffffff;
  --button-primary-bg: var(--action-bg);
}
```

Map semantic roles for canvas, surfaces, text levels, borders, actions, focus, and feedback. Define actual on-color pairs and verify contrast. Include a deliberate typography/spacing/radius/elevation scale, breakpoint or container behavior, and motion preferences. Theme support follows the brief; do not require a second theme the product does not support.

Specify component states where relevant: default, hover, focus, pressed, selected, expanded, disabled, loading, empty, error, success. Tokens alone do not guarantee accessible behavior. Use the installed styling framework's supported token mechanism, checking its version before editing configuration.

## `DESIGN.md` handoff

Taste's Stitch workflow contributes a useful semantic format. A handoff can contain:

1. **Intent and atmosphere:** audience, main action, density, composition, and why.
2. **Palette and roles:** descriptive names, exact approved values, on-color pairs, themes.
3. **Typography:** available families, roles, weights, scale, line-height, text reflow.
4. **Components and states:** geometry, hierarchy, forms, navigation, feedback.
5. **Layout:** containers, grid/spacing rules, responsive changes, media proportions.
6. **Interaction:** motion purpose, timing tokens, keyboard/touch, reduced motion.
7. **Project constraints:** observed decisions and specific patterns to avoid.

Explain meaning as well as values. This is a portable Markdown handoff and does not require a Google Stitch account. Only operate Stitch or export into it when requested and available.

Third-party brand analyses are inspiration; do not paste an entire analysis over an established project specification. Extract selected ideas, adapt them to the user's identity, and record the resulting decisions.
