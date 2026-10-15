# Main UI/UX skills

Use **`ui-ux-design` as the main skill**. It combines UI UX Pro Max's searchable design/UX knowledge with Taste's useful art direction and redesign guidance. Awesome DESIGN.md supplies brand inspiration on demand.

| Skill | Role | When to use |
|---|---|---|
| [ui-ux-design](ui-ux-design/SKILL.md) | Primary | Build, improve, or review actual interfaces and their design systems |
| [ui-ux-visual-reference](ui-ux-visual-reference/SKILL.md) | Supporting | Generate website/mobile comps and hand off their design for implementation |
| [brand-identity](brand-identity/SKILL.md) | Supporting | Create identity, logos, brand-kit boards, or standalone branded campaign assets |
| [research-ui-ux](research-ui-ux/SKILL.md) | Existing specialist | Research conventions and produce an evidence-backed brief |
| [match-ui-reference](match-ui-reference/SKILL.md) | Existing specialist | Implement supplied references and compare actual runtime captures |

Ordinary UI work uses only the primary skill. Activate a supporting skill when that artifact is part of the request. Minimalist, soft, brutalist, redesign, and Stitch handoff modes live inside the primary skill's references rather than competing as separate skills.

## Why this combination

- **UI UX Pro Max** is the strongest broad foundation here: local search, product/palette reasoning, UX guidance, charts, and 22 implementation stacks. Its generated recommendations still need judgment.
- **Taste** adds useful visual composition, typography, responsive layout, state coverage, and preservation-aware redesign. Its overlapping variants have conflicting defaults, so their strongest ideas have been normalized into conditional guidance.
- **Awesome DESIGN.md** is a library rather than a skill. All 74 analyses are available on demand in the primary skill, without loading the entire collection as instructions.

The main set keeps one canonical UI catalog and script bundle. UI screen imagery and identity artifacts remain distinct because they produce different deliverables. Provider-specific generators, duplicated CLI distributions, generic output enforcement, and unrelated presentation tooling are not part of the main set.

Each skill folder is self-contained and can be copied on its own. Local search needs only Python 3's standard library. Older overlapping skills (`design-taste-frontend`, `redesign-existing-projects`, `ui-ux-pro-max`) are kept under `ui-ux/alternatives/` and are not part of the main set. Upstream clones are gitignored local checkouts used only for maintenance.

## Use from this workspace

Ask the agent to use the desired `SKILL.md` by path, for example:

> Use `ui-ux/main/ui-ux-design/SKILL.md` to improve this dashboard.

Once installed, invoke them as `$ui-ux-design`, `$ui-ux-visual-reference` and `$brand-identity`. Install only these curated skills, not the alternatives or upstream variants, so agents don't load competing instructions.

The root `catalog.json` and copy helper include all five main UI/UX skills. From the workspace root, preview with `python3 scripts/copy_skills.py --project /absolute/project --use-cases ui-ux`, then add `--apply` when ready to copy into that project.

Example local lookup, from the workspace root:

```bash
python3 ui-ux/main/ui-ux-design/scripts/search.py "error summary validation" --domain ux --json
```

## Review and maintenance

See [REVIEW.md](REVIEW.md) for the per-skill decisions and conflict resolutions. [provenance.json](provenance.json) records the source commits and original entrypoint hashes. Each skill includes the relevant MIT notices under `licenses/`.

`main` contains curated snapshots. Updating a source clone does not update `main`: compare changed upstream entrypoints, refresh the relevant canonical resources, recheck local paths/licenses, and run skill/data validation before adopting an update. Avoid replacing the curated instructions wholesale with upstream variants.
