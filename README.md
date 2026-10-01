# Reusable project skills

Copy skills by use case into a new project. Each cataloged skill is a complete folder with `SKILL.md`, UI metadata and any references, scripts or licensed data it needs. The originals in Autoon, alternate-universe and the existing UI library checkouts were left intact.

```text
skills/
├── ui-ux/main/
│   ├── research-ui-ux/
│   ├── match-ui-reference/
│   ├── ui-ux-design/
│   ├── ui-ux-visual-reference/
│   └── brand-identity/
├── review/main/
│   ├── review-fix-pr-frontend/
│   └── review-fix-pr-backend/
├── project-workflow/main/
│   ├── project-workflow/
│   ├── linear-task-workflow/
│   └── clean-worktrees/
├── mobile/main/add-simulated-app/
└── release/main/firebase-distribution/
```

The tree lists this package's 12 cataloged skills. `catalog.json` records exactly what it installs and where each skill came from. The UI/UX set has been consolidated; overlapping previous copies are preserved under `ui-ux/alternatives/`, outside the copy helper's active catalog. See [the UI/UX review](ui-ux/main/REVIEW.md).

## Copy into a project

For Codex, copy the individual skill folders **inside** each chosen `main/` into the new project's `.agents/skills/`. Do not copy the use-case or `main` wrapper folders into the discovery directory. For Claude Code, use `.claude/skills/` instead. Copy the whole skill folder, including its references, scripts, data and license; copying only `SKILL.md` breaks skills with resources.

Example installed layout:

```text
new-project/.agents/skills/
├── review-fix-pr-frontend/SKILL.md
├── review-fix-pr-backend/SKILL.md
├── project-workflow/SKILL.md
└── ...other selected skill folders
```

From this library directory, preview a copy:

```sh
python3 scripts/copy_skills.py --project /absolute/path/new-project --use-cases ui-ux review project-workflow
```

Add `--apply` to copy. Omit `--use-cases` to select all 12 cataloged skills. Add `--target claude` to copy into `.claude/skills/`. The target project must already exist. The helper checks all conflicts before copying, skips byte-identical installed skills, and refuses to overwrite differing skills. It does not install dependencies, edit project instructions or run copied skills.

If a project generates Claude mirrors from `.agents/skills/`, install into `.agents/skills/` and use that project's sync procedure. Keep one canonical source rather than editing both copies independently.

## Choose the relevant skills

| Skill | Use when |
| --- | --- |
| `research-ui-ux` | Research conventions or turn references into an evidence-backed brief |
| `match-ui-reference` | Implement or inspect against a supplied image and measure the real runtime result |
| `ui-ux-design` | Primary interface design, implementation and redesign; combined Taste/Pro Max guidance with brand references |
| `ui-ux-visual-reference` | Generate web/mobile UI concepts and hand off generated designs |
| `brand-identity` | Create identity, logo concepts, brand-kit boards and standalone branded campaign assets |
| `review-fix-pr-frontend` | Review frontend changes, or fix authorized findings; Flutter and web references |
| `review-fix-pr-backend` | Review API, auth, data, job and reliability changes; optional Rust reference |
| `project-workflow` | Deliver a scoped project change using the project's actual tools and tracker |
| `linear-task-workflow` | Keep Linear scope/status, branch, worktree and PR aligned in a Linear project |
| `clean-worktrees` | A requested preview or conservative cleanup of integrated local worktrees |
| `add-simulated-app` | Add a simulated preview format to an existing simulation product |
| `firebase-distribution` | A requested manual Firebase tester release for the destination project's app |

Start with `review` and `project-workflow`, then add UI skills as useful. Mobile simulation and Firebase distribution are specialized; install them only for projects that need them. `project-workflow` provides general delivery; `linear-task-workflow` supplies the Linear-specific procedure rather than a second backlog. Design/redesign skills do not turn routine defect review into a redesign.

Example requests: “Use $review-fix-pr-frontend to review and fix this diff”; “Use $review-fix-pr-backend to review this API change, feedback only”; “Use $match-ui-reference to implement the attached screen”; “Use $linear-task-workflow to deliver this issue.”

## New-project context

Put project facts in the destination project's `AGENTS.md` and existing durable docs: stack and directory layout, product invariants, design tokens/brand, API contracts, commands and gates, tracker team/project, branch/PR conventions, and release configuration when applicable. The portable skills discover those facts rather than carrying Autoon or Mockstory settings into a new app. For tools without native discovery, route relevant requests to the installed `SKILL.md` from the project's instruction file.

Frontend review is generalized from both projects with Flutter details preserved separately. Backend review is newly authored using Autoon's backend guidance. Linear delivery does not require either project's `tool/task.sh`. UI capture helpers require macOS/Xcode for the bundled Swift comparator and iOS Simulator for live iPhone capture; other targets use their existing runtime tooling. Firebase distribution uses destination-owned scripts/configuration, which are not bundled here. Worktree cleanup requires git and GitHub CLI access for branched candidates and defaults to preview.

Existing `ui-ux/taste-skill`, `ui-ux/ui-ux-pro-max-skill` and `ui-ux/awesome-design-md` remain source libraries. The main UI/UX skills retain the relevant MIT notices and their own resources, so the original checkouts are not needed after copying. Source versions and consolidation decisions are recorded in `ui-ux/main/`. Updating a checkout does not automatically update the curated snapshots.

## Repository contents

Git tracks the copyable skill packages, alternatives, catalog, helper and documentation. The local upstream checkouts listed above are ignored; a clone of this repository already contains the resources needed by its packaged skills. Source attribution and versions are recorded in `ui-ux/main/provenance.json` and the bundled license notices.
