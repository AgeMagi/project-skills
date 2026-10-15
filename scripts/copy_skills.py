#!/usr/bin/env python3
"""Copy cataloged skill bundles into a project; preview by default, never overwrite."""
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


def main():
    library = Path(__file__).resolve().parent.parent
    catalog = json.loads((library / 'catalog.json').read_text())['skills']
    categories = sorted({entry['category'] for entry in catalog})
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', required=True, type=Path, help='existing destination project')
    parser.add_argument('--use-cases', nargs='+', choices=categories, help='default: all cataloged use cases')
    parser.add_argument('--target', choices=['claude', 'agents'], default='claude',
                        help='claude: .claude/skills (default); agents: .agents/skills')
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
    if not args.apply:
        print('Preview only. Add --apply to copy. Existing differing skills are never overwritten.')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError) as exc:
        print(f'Copy stopped: {exc}', file=sys.stderr)
        sys.exit(1)
