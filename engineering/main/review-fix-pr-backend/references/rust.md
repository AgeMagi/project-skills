# Rust backend review

Read Cargo manifests, the pinned toolchain and repository service instructions before choosing commands. Keep the existing architecture unless the requested behavior requires a change.

Inspect panic/unwrap paths on untrusted data, error conversion, ownership and lifetimes, cancellation, blocking work in asynchronous tasks, and bounded connection pools. For PostgreSQL work, inspect constraints and transaction behavior under duplicate or concurrent operations and use an isolated database for migrations/integration tests.

Prefer the service quality script. Otherwise use the project's formatter and Clippy settings (warnings denied when required), focused Cargo tests and affected database checks. Do not treat absent database access as a successful integration run. Keep credentials outside git and logs.
