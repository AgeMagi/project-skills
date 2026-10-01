#!/usr/bin/env python3
"""Conservative local worktree cleanup; GitHub state alone cannot prove safety."""
import argparse
import json
import re
from pathlib import Path
import subprocess
import sys
from urllib.parse import urlsplit


def run(*args):
    return subprocess.check_output(args, text=True).strip()


def github_repository(remote):
    remote_url = run('git', 'remote', 'get-url', remote)
    if '://' not in remote_url:
        match = re.fullmatch(r'(?:[^/@:]+@)?([^/:]+):(.+)', remote_url)
        if not match:
            raise RuntimeError('Selected remote has no verifiable GitHub repository URL')
        remote_url = f'ssh://{match[1]}/{match[2]}'
    parsed = urlsplit(remote_url)
    parts = parsed.path.strip('/').removesuffix('.git').split('/')
    if not parsed.hostname or len(parts) != 2 or not all(parts):
        raise RuntimeError('Selected remote has no verifiable GitHub repository URL')
    return f'{parsed.hostname}/{parts[0]}/{parts[1]}'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true', help='refresh then remove eligible worktrees')
    parser.add_argument('--remote', default='origin', help='remote to compare against')
    parser.add_argument('--base', help='explicit base branch if remote HEAD is unavailable')
    args = parser.parse_args()
    if not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9._-]*', args.remote):
        parser.error('remote must be a simple remote name')
    if args.base:
        subprocess.run(['git', 'check-ref-format', '--branch', args.base], check=True)
    current = Path(run('git', 'rev-parse', '--show-toplevel')).resolve()
    default = subprocess.run(['git', 'symbolic-ref', '--quiet', f'refs/remotes/{args.remote}/HEAD'],
                             capture_output=True, text=True)
    base = args.base or (default.stdout.strip().removeprefix(f'refs/remotes/{args.remote}/') if default.returncode == 0 else None)
    if not base:
        parser.error('remote default branch unavailable; pass --base explicitly')
    if args.apply:
        subprocess.run(['git', 'fetch', '--quiet', args.remote, f'refs/heads/{base}'], check=True)
        # Custom fetch mappings may leave the cached remote-tracking ref stale.
        base_sha = run('git', 'rev-parse', '--verify', 'FETCH_HEAD^{commit}')
    else:
        base_sha = run('git', 'rev-parse', '--verify', f'refs/remotes/{args.remote}/{base}^{{commit}}')
    records = run('git', 'worktree', 'list', '--porcelain', '-z').split('\0\0')
    decisions = []
    repository = None
    for index, record in enumerate(records):
        if not record.strip('\0'):
            continue
        fields = dict(field.partition(' ')[::2] for field in record.split('\0') if field)
        path = fields['worktree']
        branch = fields.get('branch', '').removeprefix('refs/heads/')
        reason = None
        if index == 0 or Path(path).resolve() == current:
            reason = 'primary or current checkout'
        elif 'locked' in fields:
            reason = 'locked'
        elif not Path(path).is_dir():
            reason = 'missing path; inspect registration manually'
        elif run('git', '-C', path, 'status', '--porcelain', '--untracked-files=all', '--ignored'):
            reason = 'uncommitted or ignored files'
        else:
            ancestry = subprocess.run(['git', 'merge-base', '--is-ancestor', fields['HEAD'], base_sha])
            if ancestry.returncode == 1:
                reason = f'HEAD not integrated into {args.remote}/{base}'
            elif ancestry.returncode != 0:
                raise RuntimeError('Unable to verify ancestry; stopping cleanup')
            elif branch:
                if repository is None:
                    repository = github_repository(args.remote)
                active = json.loads(run('gh', 'pr', 'list', '--repo', repository, '--head', branch, '--state', 'open', '--json', 'number'))
                merged = json.loads(run('gh', 'pr', 'list', '--repo', repository, '--head', branch, '--state', 'merged', '--limit', '1', '--json', 'number'))
                if active:
                    reason = 'open PR'
                elif not merged:
                    reason = 'no verified merged PR'
        decisions.append((path, fields['HEAD'], reason))
    # Resolve every remote query before deleting anything; API failures fail closed.
    for path, expected_head, reason in decisions:
        if reason:
            print(f'KEEP {path}: {reason}')
        elif not args.apply:
            print(f'ELIGIBLE {path}: integrated; preview only')
        else:
            if run('git', '-C', path, 'rev-parse', 'HEAD') != expected_head or run('git', '-C', path, 'status', '--porcelain', '--untracked-files=all', '--ignored'):
                raise RuntimeError(f'{path} changed during cleanup; stopping')
            subprocess.run(['git', 'worktree', 'remove', path], check=True)
            print(f'REMOVED {path}; branch retained')


if __name__ == '__main__':
    try:
        main()
    except (subprocess.CalledProcessError, RuntimeError, ValueError) as exc:
        print(f'Cleanup stopped: {exc}', file=sys.stderr)
        sys.exit(1)
