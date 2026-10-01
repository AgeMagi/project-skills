# Skill review and consolidation

Reviewed 2026-10-01. Source commits are pinned in [provenance.json](provenance.json). The three repositories were cloned with full Git history and left intact.

## Recommendation

Primary: **ui-ux-design**, a curated combination led by UI UX Pro Max. Supporting: **ui-ux-visual-reference** and **brand-identity**, activated for their different outputs. This avoids multiple broad frontend skills competing on every request.

The concurrently completed reusable-project package supplied two independent skills that remain in main: `research-ui-ux` for evidence-backed research and `match-ui-reference` for supplied-reference implementation with real capture/comparison helpers. Its overlapping `design-taste-frontend`, `redesign-existing-projects`, and `ui-ux-pro-max` copies are preserved under `ui-ux/alternatives/`. The root catalog selects their three curated replacements. No unrelated use-case folders were changed.

UI UX Pro Max provides the widest usable foundation: local retrieval, industry/product reasoning, UX guidance, and implementation-stack coverage. Taste's default v2 is experimental and marketing-oriented; it explicitly excludes several dense product and native surfaces. Taste's variants supply useful visual ideas but should not become a universal product-design policy. Awesome DESIGN.md supplies concrete inspiration rather than a workflow.

## Entry-point inventory and decisions

All 13 Taste entrypoints and all 7 canonical UI UX Pro Max entrypoints were reviewed for scope, workflow, dependencies, and overlap. Six UI UX Pro Max auxiliary entrypoints are byte-identical in `cli/assets/skills` and `.claude/skills`; they count once. The core skill also has platform-generation templates rather than an additional independent capability.

| Source skill | Decision in main | Reason |
|---|---|---|
| Taste `design-taste-frontend` (v2) | Merge into primary art direction, redesign, handoff | Strong brief inference and visual guidance; large, experimental, marketing-specific, and overly prescriptive as a universal default |
| Taste `design-taste-frontend-v1` | Keep original only | Legacy alternative, largely overlapping; not an additional skill |
| Taste `gpt-taste` | Keep original only; retain useful composition ideas | Overlapping frontend variant; simulated randomization and mandatory cinematic GSAP are unsuitable general defaults |
| Taste `redesign-existing-projects` | Merge into primary redesign mode | Audit and improve existing projects is useful but belongs in the same interface workflow |
| Taste `high-end-visual-design` | Merge as optional soft direction | A style choice; mandatory layered cards and motion conflict with other variants |
| Taste `minimalist-ui` | Merge as optional minimal/editorial direction | A style choice; font, color, and component prescriptions should follow the brief |
| Taste `industrial-brutalist-ui` | Merge as optional industrial/terminal direction | Distinct aesthetic but shared implementation workflow; avoid tiny text and fictional telemetry |
| Taste `stitch-design-taste` | Merge `DESIGN.md` handoff format | Portable design documentation is useful; no Stitch account/tool dependency for the handoff |
| Taste `full-output-enforcement` | Exclude from active set | Generic output behavior, not independent UI/UX expertise; completeness remains expected |
| Taste `image-to-code` | Merge into visual-reference mode | Shares image workflow with the web/mobile skills; preserve reference analysis without forcing fresh generation for every UI task |
| Taste `imagegen-frontend-web` | Merge into visual-reference web mode | Separate image deliverable; readable section frames and consistent visual language |
| Taste `imagegen-frontend-mobile` | Merge into visual-reference mobile mode | Same image workflow, different platform/flow reference; avoid another broad entrypoint |
| Taste `brandkit` | Merge into brand identity board mode | Identity boards are distinct from UI screen comps; overlap with Pro Max brand/logo/CIP |
| Pro Max `ui-ux-pro-max` | Foundation of primary; vendor canonical local engine/data | Broadest UX/platform coverage and useful executable retrieval |
| Pro Max `ui-styling` | Merge interface/theme/component ideas into primary | Overlaps with core interface work and assumes shadcn/Tailwind; detect the real stack |
| Pro Max `design-system` | Merge token architecture and component specs into primary | Interface design systems belong with the interface workflow; slide branch is independent and outside this main set |
| Pro Max `brand` | Merge into brand identity | Identity, voice, guidelines, and consistency support brand deliverables |
| Pro Max `design` | Split relevant parts into primary and brand identity | Broad router duplicates sibling skills; retain logo/CIP local retrieval but omit provider-specific generators and unrelated slide workflows |
| Pro Max `banner-design` | Merge as standalone campaign-asset mode in brand identity | Similar identity/asset pipeline; does not need a second banner workflow loaded simultaneously |
| Pro Max `slides` | Keep original only | Independent HTML presentation capability outside the requested UI/UX core; retains access in the clone |
| Awesome DESIGN.md, 74 analyses | Vendor as on-demand reference library in primary | Reference content, not 74 active skills or official brand documentation |

The UI/UX scope is the selection criterion; independent presentation capabilities remain in the original repository. Nothing was deleted from upstream clones.

## Overlap and conflicts resolved

| Conflict or recurring risk | Curated behavior |
|---|---|
| Centered hero favored by GPT variant, banned by other variants | Choose composition from the brief and content |
| Minimalist/soft/industrial presets disagree about typography, borders, pills, and palettes | Choose one relevant style direction; no parallel universal protocols |
| Taste font/purple bans conflict with brand analyses using Inter/purple | User/brand/project decisions take precedence; measure actual readability |
| Soft variant requires pill buttons and nested enclosures; minimal/industrial reject them | Geometry follows the selected system and component purpose |
| Perpetual motion, GSAP, scroll choreography, and instant-change bans | Motion is optional and purposeful; reduced motion, accessibility, and responsive feedback govern behavior |
| Python randomization is described as simulated execution | Remove mock execution; no invented tool results or randomness as a substitute for judgment |
| Every visual task forced through multiple generated images | Image workflow activates for requested comps or screenshot-driven work; supplied references are reusable |
| Fresh generated closeups presented as detail recovery | Distinguish new design from source observation; do not invent OCR precision |
| Fake names, dates, customers, or messy metrics recommended for realism | Keep claims accurate and samples identifiable |
| Stack defaults and Claude-specific environment variables | Detect stack and resolve paths relative to each actual skill folder |
| Brand documents assume exact/licensed proprietary fonts and accessible colors | Analyses are candidates; verify fonts, assets, and composed contrast |
| Static banner dimensions, universal safe zones, historical Meta text penalty | Verify placement-specific requirements; no blanket stale policy |
| Provider setup and mutation scripts mixed into design guidance | Keep local read-only search; use available runtime media tools only when needed |

## Retained resources

The primary skill includes one copy of the five canonical Python search/validation modules and the full canonical UI data directory. Current data includes 192 product profiles/palettes/reasoning rows, 119 UX guidelines, 74 font pairings, 1,934 font catalog rows, 105 icons, 17 motion presets, 25 chart types, 34 landing patterns, 32 app-interface rows, 44 React-performance rows, and 22 stack catalogs.

The style CSV contains 88 records: **50 active, 29 supplemental, 9 deprecated**. The advertised 79 searchable styles counts active plus supplemental records; it is not the raw CSV row count. Awesome DESIGN.md's README badge says 73, while the cloned repository contains **74** `DESIGN.md` files. The curated inventory uses the actual files.

A smoke test for `internal analytics dashboard` correctly matched Analytics Dashboard/Data-Dense Dashboard but also returned an Enterprise Gateway marketing pattern. The search guide explicitly requires rejecting that irrelevant landing structure for product/native screens. The engine remains an upstream snapshot rather than a silently modified recommendation algorithm.

Brand identity keeps the canonical logo and corporate-identity CSVs plus their read-only search/core modules. It omits network image generators, provider credentials/setup, duplicated routers, and automatic token-sync/install scripts. Visual-reference guidance uses runtime image tools without vendoring another generation provider.

No hard links, symlinks, or runtime references to adjacent clones are required. Each curated skill carries its relevant original license notices. Source versions and original entrypoint hashes make later review reproducible.

## Validation scope

Packaging checks completed successfully:

- Skill-creator validation, folder names, UI metadata, local Markdown links, and absence of symlinks/build artifacts for all 12 cataloged project skills, including the five main UI/UX skills.
- Upstream data validator: 12 UI domain files, 22 stack files, and the reasoning contract.
- Copy-helper preview, apply, and repeat-copy behavior for all five main UI/UX skills into an isolated temporary project with spaces in its path.
- Relocated searches from an unrelated working directory: all 12 UI domains, representative guidance from all 22 stack catalogs, and all seven logo/corporate-identity search domains.
- Empty-query abstention, system generation, identity-brief generation, and preservation of edited existing master/page files on repeated persistence.
- Byte-for-byte integrity of the vendored engine, data, brand analyses, and original license notices; the three Git clones remain clean.

These checks validate usable packaging and retrieval; they do not prove that every design recommendation is current, every brand analysis is exact, or future generated interfaces meet accessibility/performance targets. The existing research/capture/comparison specialists were preserved; their runtime tools were not modified by this consolidation.
