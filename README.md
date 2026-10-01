# Reusable project skills

Clone this library, then copy only the skills you need from each use case’s `main/` folder into your project. Each skill is a complete directory containing `SKILL.md` and any metadata, references, scripts, data or licenses it needs.

## Clone the main skills

Requires Git and Python 3.9+ for the copy helper. This sparse clone checks out all five `main/` directories, the helper and root documentation:

```sh
git clone --filter=blob:none --sparse https://github.com/AgeMagi/project-skills.git project-skills
cd project-skills
git sparse-checkout set scripts ui-ux/main review/main project-workflow/main mobile/main release/main
```

For fewer use cases, select only their `main/` paths. For example:

```sh
git sparse-checkout set scripts review/main project-workflow/main
```

Keep `scripts` for the copy helper. Root files such as `catalog.json` and this README are included automatically. To check out the full tracked library later, run `git sparse-checkout disable`.

## Install into a project

For Codex, install individual skill directories into `.agents/skills/`. For Claude Code, use `.claude/skills/`. **Install the directories inside `main/`, including their contents; do not install the use-case or `main` wrapper.** Alternatives and upstream source libraries are not needed.

From the cloned library, preview the selected use cases:

```sh
python3 scripts/copy_skills.py --project /absolute/path/my-project --use-cases review project-workflow
```

Apply the same selection:

```sh
python3 scripts/copy_skills.py --project /absolute/path/my-project --use-cases review project-workflow --apply
```

The destination project must already exist. The helper checks conflicts before copying, skips identical skills and refuses to overwrite differing ones. It copies only cataloged skills under `main/`; it does not install dependencies or modify project instructions.

- Add `--target claude` for `.claude/skills/`.
- Omit `--use-cases` to install all 12 skills; all five `main/` directories must be checked out.
- Available use cases: `ui-ux`, `review`, `project-workflow`, `mobile`, `release`.

For a single skill, copy its complete directory. This example installs only the primary UI skill and refuses an existing destination:

```sh
python3 -c 'import shutil; shutil.copytree("ui-ux/main/ui-ux-design", "/absolute/path/my-project/.agents/skills/ui-ux-design")'
```

The installed layout should look like this:

```text
my-project/.agents/skills/
├── review-fix-pr-frontend/
│   ├── SKILL.md
│   ├── agents/
│   └── references/
├── review-fix-pr-backend/
└── project-workflow/
```

If your project generates Claude mirrors from `.agents/skills/`, install there and use its existing sync procedure.

## Choose skills by use case

| Use case | Skill | Use when |
| --- | --- | --- |
| UI/UX | [ui-ux-design](ui-ux/main/ui-ux-design/SKILL.md) | Primary interface design, implementation and redesign |
| UI/UX | [research-ui-ux](ui-ux/main/research-ui-ux/SKILL.md) | Research conventions and produce an evidence-backed brief |
| UI/UX | [match-ui-reference](ui-ux/main/match-ui-reference/SKILL.md) | Implement supplied references and compare real runtime captures |
| UI/UX | [ui-ux-visual-reference](ui-ux/main/ui-ux-visual-reference/SKILL.md) | Generate UI concepts and hand off their designs |
| UI/UX | [brand-identity](ui-ux/main/brand-identity/SKILL.md) | Create logos, identity, brand boards and campaign assets |
| Review | [review-fix-pr-frontend](review/main/review-fix-pr-frontend/SKILL.md) | Review web/Flutter changes and fix authorized defects |
| Review | [review-fix-pr-backend](review/main/review-fix-pr-backend/SKILL.md) | Review API, auth, data, jobs and reliability changes |
| Project workflow | [project-workflow](project-workflow/main/project-workflow/SKILL.md) | General scoped implementation, verification and delivery |
| Project workflow | [linear-task-workflow](project-workflow/main/linear-task-workflow/SKILL.md) | Deliver work tracked in Linear |
| Project workflow | [clean-worktrees](project-workflow/main/clean-worktrees/SKILL.md) | Preview or clean integrated worktrees on request |
| Mobile | [add-simulated-app](mobile/main/add-simulated-app/SKILL.md) | Add a preview format to an existing simulation product |
| Release | [firebase-distribution](release/main/firebase-distribution/SKILL.md) | Build and upload a requested Firebase tester release |

Choose one delivery workflow: `linear-task-workflow` for Linear, otherwise `project-workflow`. For ordinary UI work, start with `ui-ux-design` and add specialists when their deliverable is needed. Mobile simulation and Firebase distribution are specialized; install them only for relevant projects.

Example: “Use $review-fix-pr-frontend to review and fix this diff” or “Use $linear-task-workflow to deliver this issue.”

## Project setup and updates

Keep project-specific facts in the destination’s `AGENTS.md` and owning docs: stack, product contracts, design system, commands/checks, tracker, branch/PR conventions and release configuration. The skills discover those settings rather than importing another project’s configuration.

Local design searches require only Python’s standard library. Bundled image comparison requires macOS/Xcode; live iOS capture additionally requires iOS Simulator. Other platforms use project tooling. Worktree PR checks require GitHub CLI access. Firebase builds/uploads use destination-owned tools and credentials.

Update the library with:

```sh
git pull --ff-only
```

Preview copying again before applying. If an installed skill differs, review and reconcile it explicitly; the helper does not overwrite it automatically.

`catalog.json` records the 12 installable skills and their origins. UI/UX resources are curated snapshots with bundled licenses; upstream checkouts are unnecessary. See [UI/UX review](ui-ux/main/REVIEW.md) and [provenance](ui-ux/main/provenance.json) for source versions and maintenance details.
