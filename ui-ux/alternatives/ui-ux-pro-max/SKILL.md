---
name: ui-ux-pro-max
description: "Search bundled UI/UX guidance, palettes, typography and stack rules, or generate a proposed design system. Use for interface design decisions across web and mobile; respect existing project tokens."
---

# UI/UX Pro Max

Use the bundled Python 3 scripts and data as design guidance. Establish the product, audience, requested surface, stack and existing tokens before searching. Search recommendations are proposals; existing approved design contracts and the user's scope take precedence. The dataset is bundled guidance, not verified current documentation.

Run from the installed skill directory or pass its actual absolute script path:

```sh
python3 scripts/search.py "dashboard accessible dense" --domain ux
python3 scripts/search.py "responsive keyboard layout" --stack flutter
python3 scripts/search.py "consumer reading app calm" --design-system -p "Project Name"
```

Use `--help` for available domains, stacks and output options. The engine uses the Python standard library and local CSV data. Read only the results relevant to the decision. When current library APIs or external facts matter, verify official documentation through available tools.

A generated design system is advisory. Do not replace existing tokens automatically. Persist only when the request calls for a durable design artifact: add `--persist --output-dir /absolute/project/root`, optionally `--page dashboard`. Inspect existing output before using overwrite options. Keep generated artifacts in the target project, not inside the installed skill.

Implement authorized changes using the actual project components and verify relevant states, layout and accessibility with its runtime/test tools. Report choices, tradeoffs and actual validation.
