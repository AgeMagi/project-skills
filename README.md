# Reusable project skills

Clone this library, then copy only the skills you need from each use case’s `main/` folder into your project. Each skill is a complete directory containing `SKILL.md` and any metadata, references, scripts, data or licenses it needs.

## Clone the main skills

Requires Git and Python 3.9+ for the copy helper. This sparse clone checks out both `main/` directories, the helper and root documentation:

```sh
git clone --filter=blob:none --sparse https://github.com/AgeMagi/project-skills.git project-skills
cd project-skills
git sparse-checkout set scripts ui-ux/main engineering/main
```

For one use case, select only its `main/` path. For example:

```sh
git sparse-checkout set scripts engineering/main
```

Keep `scripts` for the copy helper. Root files such as `catalog.json` and this README are included automatically. To check out the full tracked library later, run `git sparse-checkout disable`.

## Install into a project

Install individual skill directories into `.claude/skills/` and keep that as the only real copy. Codex reads the same files through a symlink, so there is no mirror to sync:

```text
.claude/skills/                       ← real skills (edit here)
.agents/skills → ../.claude/skills    ← Codex
CLAUDE.md                             ← real instructions
AGENTS.md → CLAUDE.md
```

Create the links once from the project root:

```sh
mkdir -p .agents && ln -s ../.claude/skills .agents/skills && ln -s CLAUDE.md AGENTS.md
```

**Install the directories inside `main/`, including their contents; do not install the use-case or `main` wrapper.** Alternatives and upstream source libraries are not needed.

From the cloned library, preview the selected use cases:

```sh
python3 scripts/copy_skills.py --project /absolute/path/my-project --use-cases engineering
```

Apply the same selection:

```sh
python3 scripts/copy_skills.py --project /absolute/path/my-project --use-cases engineering --apply
```

The destination project must already exist. The helper checks conflicts before copying, skips identical skills and refuses to overwrite differing ones. It copies only cataloged skills under `main/` and does not install dependencies.

**Make the skills load without being named.** Add `--instructions` to also write each selected use case's routing section (from `<use-case>/main/instructions.md`) into the project's `CLAUDE.md`, or `AGENTS.md` when that is the only one. A missing file is created. Each section sits between `<!-- project-skills:<use-case>:start/end -->` markers and is appended after your own text, which is never changed. A section that is already identical is kept; one you edited is reported as a conflict and nothing is written, so later installs never undo your edits:

```sh
python3 scripts/copy_skills.py --project /absolute/path/my-project --instructions --apply
```

Without `--instructions` the helper never touches project instructions.

- Skills go to `.claude/skills/` by default; add `--target agents` for a Codex-only project without the symlink.
- Omit `--use-cases` to install all 18 skills; both `main/` directories must be checked out.
- Available use cases: `engineering`, `ui-ux`.

For a single skill, copy its complete directory. This example installs only the primary UI skill and refuses an existing destination:

```sh
python3 -c 'import shutil; shutil.copytree("ui-ux/main/ui-ux-design", "/absolute/path/my-project/.claude/skills/ui-ux-design")'
```

The installed layout should look like this:

```text
my-project/.claude/skills/
├── review-fix-pr-frontend/
│   ├── SKILL.md
│   ├── agents/
│   └── references/
├── review-fix-pr-backend/
└── linear-task-workflow/
```

If an older project still keeps separate `.agents/skills/` and `.claude/skills/` copies, replace the mirror with the symlink above rather than syncing two copies.

## Choose skills by use case

| Use case | Skill | Use when |
| --- | --- | --- |
| Engineering | [grilling](engineering/main/grilling/SKILL.md) | Stress-test a plan or decision through rounds of questions |
| Engineering | [grill-with-docs](engineering/main/grill-with-docs/SKILL.md) | Grill a plan while writing its glossary and ADRs |
| Engineering | [domain-modeling](engineering/main/domain-modeling/SKILL.md) | Sharpen terminology and record the glossary and ADRs |
| Engineering | [research](engineering/main/research/SKILL.md) | Research primary sources and save cited notes |
| Engineering | [prototype](engineering/main/prototype/SKILL.md) | Build throwaway code to answer a design question |
| Engineering | [to-tickets](engineering/main/to-tickets/SKILL.md) | Split a plan or spec into vertical-slice tickets with blockers |
| Engineering | [tdd](engineering/main/tdd/SKILL.md) | Build or fix test-first at agreed seams |
| Engineering | [codebase-design](engineering/main/codebase-design/SKILL.md) | Vocabulary for module depth, seams and interfaces |
| Engineering | [diagnosing-bugs](engineering/main/diagnosing-bugs/SKILL.md) | Debug hard bugs and regressions from a failing loop |
| Engineering | [review-standards-and-spec](engineering/main/review-standards-and-spec/SKILL.md) | Review a diff against the project's standards and its issue |
| Engineering | [review-fix-pr-frontend](engineering/main/review-fix-pr-frontend/SKILL.md) | Review web/Flutter changes and fix authorized defects |
| Engineering | [review-fix-pr-backend](engineering/main/review-fix-pr-backend/SKILL.md) | Review API, auth, data, jobs and reliability changes |
| Engineering | [linear-task-workflow](engineering/main/linear-task-workflow/SKILL.md) | Deliver work tracked in Linear: branch, PR and status |
| UI/UX | [ui-ux-design](ui-ux/main/ui-ux-design/SKILL.md) | Primary interface design, implementation and redesign |
| UI/UX | [research-ui-ux](ui-ux/main/research-ui-ux/SKILL.md) | Research conventions and produce an evidence-backed brief |
| UI/UX | [match-ui-reference](ui-ux/main/match-ui-reference/SKILL.md) | Implement supplied references and compare real runtime captures |
| UI/UX | [ui-ux-visual-reference](ui-ux/main/ui-ux-visual-reference/SKILL.md) | Generate UI concepts and hand off their designs |
| UI/UX | [brand-identity](ui-ux/main/brand-identity/SKILL.md) | Create logos, identity, brand boards and campaign assets |

Install the whole `engineering` use case: its skills point at each other (`grill-with-docs` needs `grilling` and `domain-modeling`; `to-tickets` and the review skills hand delivery to the project's workflow, which is `linear-task-workflow` for Linear projects). A typical flow is `grill-with-docs` to settle a design, `to-tickets` to split it, then `linear-task-workflow` (or the project's own delivery process) to deliver each ticket, with `tdd`, `diagnosing-bugs` and the review skills along the way. The old general `project-workflow` skill is archived in `engineering/archive/`. For ordinary UI work, start with `ui-ux-design` and add specialists when their deliverable is needed.

Example: “Use $review-fix-pr-frontend to review and fix this diff” or “Use $linear-task-workflow to deliver this issue.”

## Project setup and updates

Keep project-specific facts in the destination’s `AGENTS.md` and owning docs: stack, product contracts, design system, commands/checks, tracker and branch/PR conventions. The skills discover those settings rather than importing another project’s configuration.

Local design searches require only Python’s standard library. Bundled image comparison requires macOS/Xcode; live iOS capture additionally requires iOS Simulator. Other platforms use project tooling.

Update the library with:

```sh
git pull --ff-only
```

Preview copying again before applying. If an installed skill differs, review and reconcile it explicitly; the helper does not overwrite it automatically.

`catalog.json` records the 17 installable skills and their origins. UI/UX resources are curated snapshots with bundled licenses; upstream checkouts are unnecessary. See [UI/UX review](ui-ux/main/REVIEW.md) and [provenance](ui-ux/main/provenance.json) for source versions and maintenance details. Engineering skills are adapted from mattpocock/skills (MIT); see [engineering/main/README.md](engineering/main/README.md) for the source commit and local changes.
