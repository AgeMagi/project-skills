# Local design search

Resolve `SKILL_DIR` to this skill's directory, then run `python3 "${SKILL_DIR}/scripts/search.py"`. Queries should express one dominant intent in roughly 2–5 meaningful terms. The engine ranks local CSV records; it is retrieval and deterministic reasoning, not a live research service.

## Query modes

| Need | Argument | Example query |
|---|---|---|
| Coherent new direction | `--design-system` | `health appointment booking calm` |
| Product patterns | `--domain product` | `internal analytics dashboard` |
| Style options | `--domain style` | `industrial editorial` |
| Palette candidates | `--domain color` | `finance trustworthy` |
| Font pairs | `--domain typography` | `editorial readable` |
| Individual font catalog | `--domain google-fonts` | `sans variable` |
| Charts | `--domain chart` | `time series comparison` |
| UX outcome | `--domain ux` | `focus not obscured` |
| Landing structure | `--domain landing` | `hero social proof` |
| Icon semantics | `--domain icons` | `decorative icon aria hidden` |
| Motion examples | `--domain gsap` | `scroll reveal stagger` |
| React performance | `--domain react` | `rerender memo list` |
| App interface guidance | `--domain web` | `touch safe areas` |
| Stack implementation | `--stack <stack>` | `chip badge overflow nowrap` |

`web` is the upstream name for the app-interface domain. Use explicit domains when vocabulary could match multiple catalogs. For a text/layout issue, search its semantic UX outcome first, then the detected stack's implementation guidance.

Supported stacks: `react`, `nextjs`, `vue`, `svelte`, `astro`, `nuxtjs`, `nuxt-ui`, `angular`, `laravel`, `swiftui`, `react-native`, `flutter`, `jetpack-compose`, `html-tailwind`, `shadcn`, `threejs`, `javafx`, `wpf`, `winui`, `avalonia`, `uno`, `uwp`. Detect the stack from the project; do not silently choose React or Tailwind. Verify version-sensitive recommendations against installed packages and official docs when needed.

`--stack` is ignored in design-system mode; run a separate stack query. `--json` preserves structured results, `--full` preserves long fields in domain text output, and `-n 1` through `-n 20` sets the result count. System output supports `-f markdown` or the default ASCII format.

The aggregated system always includes a landing-pattern recommendation. For a dashboard or native app, that part can be off-topic even when the product/style/palette match is good. Discard irrelevant hero, logo-wall, pricing, and sales-CTA structure; use applicable product, app-interface, chart, UX, and stack guidance for the actual screen. Check each returned section rather than accepting or persisting the whole result because its category matches.

## Dials

`--variance`, `--motion`, and `--density` accept 1–10 in design-system mode. Variance biases style selection, motion attaches a GSAP example, and density changes recommended spacing tokens. These are optional recommendation controls, not proof of implementation quality. Leave motion unset when a GSAP example is irrelevant. Use high density for efficient product UI only when readability and target sizes remain appropriate.

## Persistence

Preview and assess a generated system before saving it. Integrate accepted choices into the existing source of truth rather than creating a competing design document. When the project needs the upstream master/override structure:

```bash
python3 "${SKILL_DIR}/scripts/search.py" "appointment booking calm" \
  --design-system -p "Project Name" --persist --output-dir "/absolute/project/root"
```

This writes `design-system/<project-slug>/MASTER.md`. `--page <name>` creates a page override under `pages/`. Read the existing master and relevant override first. Existing files are skipped unless `--force` is supplied; inspect the returned persistence status. Use `--force` only when replacement is within the user's requested change and the existing content has been reviewed. Never infer authorization from an elapsed wait or from a catalog recommendation.

The tool writes generated recommendations, not the final adjudicated design. Edit any persisted recommendation that conflicts with accepted project decisions. Do not persist an off-topic match. Ordinary targeted fixes need no new master file.

## Catalog integrity

`python3 "${SKILL_DIR}/scripts/validate_data.py"` checks the bundled data in `data/`. Search already handles deprecated style records. Never load the CSVs into context.
