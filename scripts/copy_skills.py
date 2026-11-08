#!/usr/bin/env python3
"""Copy cataloged skill bundles into a project; preview by default, never overwrite.

With --instructions, also append each selected use case's skill-routing section to the
project's CLAUDE.md (or AGENTS.md), wrapped in markers. Existing sections are kept when
identical and reported as conflicts when they differ; other text is never changed.
"""
import argparse
import json
from pathlib import Path
import shutil
import sys


def identical(source, target):
    if target.is_symlink() or not target.is_dir():
        return False
    left = {p.relative_to(source): p for p in source.rglob('*') if p.is_file()}
    right = {p.relative_to(target): p for p in target.rglob('*') if p.is_file()}
    if left.keys() != right.keys() or any(p.is_symlink() for p in target.rglob('*')):
        return False
    return all(p.read_bytes() == right[name].read_bytes() for name, p in left.items())


def instructions_target(project, target):
    """Existing CLAUDE.md/AGENTS.md (resolved inside the project), else the file to create."""
    names = ['AGENTS.md', 'CLAUDE.md'] if target == 'agents' else ['CLAUDE.md', 'AGENTS.md']
    for name in names:
        path = project / name
        if path.exists() or path.is_symlink():
            real = path.resolve()
            if not real.is_relative_to(project) or not real.is_file():
                raise ValueError(f'{path} must be a regular file inside the project')
            return path, real
    return project / names[0], project / names[0]


def plan_instructions(library, categories, real):
    """Return (sections to append, kept categories, conflicts) for the marked skill sections."""
    text = real.read_text() if real.exists() else ''
    append, keep, conflicts = [], [], []
    for category in categories:
        body = library / category / 'main' / 'instructions.md'
        if not body.is_file():
            continue
        start, end = f'<!-- project-skills:{category}:start -->', f'<!-- project-skills:{category}:end -->'
        block = f'{start}\n{body.read_text().strip()}\n{end}'
        if start not in text and end not in text:
            append.append((category, block))
        elif text.count(start) == 1 and text.count(end) == 1 and text.index(start) < text.index(end):
            current = text[text.index(start):text.index(end) + len(end)]
            (keep if current == block else conflicts).append(category)
        else:
            conflicts.append(category)
    return text, append, keep, conflicts


def main():
    library = Path(__file__).resolve().parent.parent
    catalog = json.loads((library / 'catalog.json').read_text())['skills']
    categories = sorted({entry['category'] for entry in catalog})
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', required=True, type=Path, help='existing destination project')
    parser.add_argument('--use-cases', nargs='+', choices=categories, help='default: all cataloged use cases')
    parser.add_argument('--target', choices=['claude', 'agents'], default='claude',
                        help='claude: .claude/skills (default); agents: .agents/skills')
    parser.add_argument('--instructions', action='store_true',
                        help="also add each use case's skill-routing section to CLAUDE.md (or AGENTS.md)")
    parser.add_argument('--apply', action='store_true', help='copy after a successful conflict check')
    args = parser.parse_args()
    project = args.project.expanduser().resolve()
    if not project.is_dir():
        parser.error('destination project directory must already exist')
    if project == library or project.is_relative_to(library):
        parser.error('destination must be outside the library')
    destination = project / ('.agents' if args.target == 'agents' else '.claude') / 'skills'
    if not destination.resolve().is_relative_to(project):
        parser.error('destination skills directory resolves outside the target project')
    selected = [e for e in catalog if not args.use_cases or e['category'] in args.use_cases]
    plans, conflicts = [], []
    for entry in selected:
        source = library / entry['path']
        target = destination / entry['name']
        if not (source / 'SKILL.md').is_file() or any(p.is_symlink() for p in source.rglob('*')):
            parser.error(f'invalid or symlinked source: {source}')
        if target.exists() or target.is_symlink():
            if identical(source, target):
                plans.append(('KEEP', source, target))
            else:
                conflicts.append(target)
        else:
            plans.append(('COPY', source, target))
    instructions = None
    if args.instructions:
        shown, real = instructions_target(project, args.target)
        chosen = sorted({e['category'] for e in selected})
        text, append, keep, section_conflicts = plan_instructions(library, chosen, real)
        instructions = (shown, real, text, append, keep)
        conflicts += [f'{shown} ({category} section)' for category in section_conflicts]
    if conflicts:
        for target in conflicts:
            print(f'CONFLICT {target}: existing contents differ; nothing copied', file=sys.stderr)
        return 1
    for action, source, target in plans:
        if action == 'COPY' and args.apply:
            shutil.copytree(source, target)
            print(f'COPIED {target}')
        else:
            print(f'{action} {target}' + (' (preview)' if action == 'COPY' else ' (identical)'))
    if instructions:
        shown, real, text, append, keep = instructions
        for category in keep:
            print(f'KEEP {shown} ({category} section, identical)')
        if append:
            verb = 'ADDED' if args.apply else 'ADD'
            for category, _ in append:
                print(f'{verb} {shown} ({category} section)' + ('' if args.apply else ' (preview)'))
            if args.apply:
                blocks = '\n\n'.join(block for _, block in append)
                real.write_text((text.rstrip('\n') + '\n\n' if text.strip() else '') + blocks + '\n')
    if not args.apply:
        print('Preview only. Add --apply to copy. Existing differing skills are never overwritten.')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError) as exc:
        print(f'Copy stopped: {exc}', file=sys.stderr)
        sys.exit(1)
