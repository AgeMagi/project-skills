# Web frontend review

- Inspect framework lifecycle and state rules: hook dependencies, stale closures, effect cleanup, reactive subscription disposal, hydration and server/client boundaries where relevant.
- Trace request cancellation, duplicate submissions, error recovery, cache invalidation and optimistic updates. Enforce access on the server; hidden controls alone are insufficient.
- Check HTML semantics, labels, focus restoration, keyboard interaction, reduced motion and screen-reader updates in affected flows.
- Inspect layout under narrow/wide viewports, zoom, long translations and content pressure. Use the current design system and browser test harness.
- Check list identity, expensive renders, image sizing, code loading and network waterfalls only when the changed flow supports a concrete performance concern.
- Discover scripts and package-manager lockfile before choosing commands. Run relevant type, lint, component or end-to-end checks; do not invent tooling or run unrelated suites.
