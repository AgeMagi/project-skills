# Main engineering skills

Skills for planning, designing, building, debugging, reviewing and delivering code. In Linear projects `linear-task-workflow` delivers each piece of work and the rest feed into it; other projects deliver through their own documented process.

| Skill | Use when | Invoked |
|---|---|---|
| [linear-task-workflow](linear-task-workflow/SKILL.md) | Deliver a Linear issue end to end: branch, PR and status from Todo to Done | Automatically or by name |
| [grilling](grilling/SKILL.md) | Stress-test a plan, decision or idea through rounds of questions with recommended answers | Automatically or by name |
| [grill-with-docs](grill-with-docs/SKILL.md) | Grill a plan and write its glossary and ADRs as you go | By name only |
| [domain-modeling](domain-modeling/SKILL.md) | Sharpen project terminology and record `GLOSSARY.md` entries and ADRs | Automatically or by name |
| [research](research/SKILL.md) | Delegate research on primary sources to a background agent and save cited notes in the repo | Automatically or by name |
| [prototype](prototype/SKILL.md) | Build throwaway code (a logic demo or UI variants) to answer a design question | Automatically or by name |
| [to-tickets](to-tickets/SKILL.md) | Split a plan or spec into vertical-slice tickets with blocking links | By name only |
| [tdd](tdd/SKILL.md) | Build or fix test-first at agreed seams | Automatically or by name |
| [codebase-design](codebase-design/SKILL.md) | Shared vocabulary for module depth, seams and interfaces | Automatically or by name |
| [diagnosing-bugs](diagnosing-bugs/SKILL.md) | Debug hard bugs and performance regressions: build a failing loop first, then reproduce, hypothesise, fix | Automatically or by name |
| [review-standards-and-spec](review-standards-and-spec/SKILL.md) | Review a diff on two separate axes: the project's documented standards (plus a baseline of code smells) and the issue it came from | Automatically or by name |
| [start-pr-discussion](start-pr-discussion/SKILL.md) | Talk a PR through before changing it: its own commits, what it changes and the user flow, and a standards-and-spec review, with nothing fixed | Automatically or by name |
| [review-fix-pr-frontend](review-fix-pr-frontend/SKILL.md) | Review a web or Flutter PR or diff and fix the defects it introduced | Automatically or by name |
| [review-fix-pr-backend](review-fix-pr-backend/SKILL.md) | Review a backend PR or diff and fix API, auth, data, job or reliability defects | Automatically or by name |

`grill-with-docs` needs `grilling` and `domain-modeling` installed beside it; `tdd` uses `codebase-design` when present; `start-pr-discussion` runs `review-standards-and-spec`. Install the whole use case to keep these links working.

## Provenance

`linear-task-workflow`, `review-fix-pr-frontend` and `review-fix-pr-backend` are this library's own skills, moved here from the former `project-workflow` and `review` use cases. `start-pr-discussion` is also this library's own, written for tellback on 2026-11-14. The rest were copied from [mattpocock/skills](https://github.com/mattpocock/skills) at commit `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d` (MIT; the license is bundled in each skill's `licenses/`). The first six matched the copies installed in tellback; `diagnosing-bugs`, `prototype` and `research` were added from the same commit unchanged.

Local changes, so the skills work in any project rather than only after upstream's `setup-matt-pocock-skills`:

- `to-tickets`: finds the tracker from the project's `AGENTS.md` / `CLAUDE.md` instead of the setup skill, drops the `ready-for-agent` triage label, and leaves delivery to the project's workflow (for example `linear-task-workflow`).
- `tdd`: refactoring no longer points at an upstream `code-review` skill; `codebase-design` is referenced by name rather than through Claude's Skill tool.
- `grill-with-docs`: describes how to combine the two skills instead of calling Claude's Skill tool, so it also reads correctly in Codex.
- `review-standards-and-spec` (upstream `code-review`, added 2026-11-11 for tellback): renamed so it doesn't shadow Claude Code's built-in `/code-review`, which hunts bugs while this one checks standards and spec; finds the tracker from `AGENTS.md` / `CLAUDE.md` instead of the setup skill; reads issue ids from the PR body and branch name too (Linear `HAB-123`); and counts `AGENTS.md` and `CLAUDE.md` as standards sources.

Not taken from upstream: `implement`, `implement-spec` and `to-spec` (overlap `linear-task-workflow` and need the setup skill), `triage` (built on GitHub triage labels), `wayfinder` (heavy; revisit now that `research` and `prototype` are here), `setup-matt-pocock-skills` and `ask-matt` (project facts belong in each project's own `AGENTS.md`), personal productivity skills, and the frozen `misc/` and unfinished `in-progress/` buckets.
