# Flutter review

- Keep `build` free of I/O, subscriptions and state mutations. Check unidirectional state updates, immutable models and null safety within the existing architecture.
- Check `mounted` after asynchronous gaps before accessing widget state or context. Dispose controllers, focus nodes, timers, streams, listeners and animations.
- Use stable keys for reordered or anchored collections. Limit expensive rebuilds and synchronous work on the UI isolate; use lazy builders for large collections.
- Bound image decode/cache sizes where large media creates memory pressure, without changing required content or aspect ratios.
- Inspect repository-owned device/theme fixtures and golden registration. Cover affected user-facing variants and long-content pressure; make sure the subject is inside the rendered frame.
- Add direct assertions for the property a golden protects, such as order, alignment or exclusion, when that property is central to the change.
- Discover the project's Flutter quality script. If none exists, use appropriate analyzer, formatter and focused widget/unit tests. Simulator evidence is separate from widget tests; state when it was unavailable.
