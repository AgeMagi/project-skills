"""Exercise cleanup with disposable repositories; no live GitHub access."""
import contextlib
import io
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import clean_worktrees as cleanup


class CleanupTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='skill-worktree-test-')
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.remote = self.root / 'remote.git'
        self.repo = self.root / 'repo'
        self.git('init', '--bare', str(self.remote), cwd=self.root)
        self.git('init', '-b', 'main', str(self.repo), cwd=self.root)
        self.git('config', 'user.name', 'Test')
        self.git('config', 'user.email', 'test@example.invalid')
        self.git('config', 'commit.gpgsign', 'false')
        self.git('config', 'core.hooksPath', str(self.root / 'empty-hooks'))
        (self.repo / 'file.txt').write_text('base')
        self.git('add', '.')
        self.git('commit', '-m', 'base')
        self.initial = self.git('rev-parse', 'HEAD')
        self.git('remote', 'add', 'origin', str(self.remote))
        self.git('push', 'origin', 'main')
        self.git('symbolic-ref', 'refs/remotes/origin/HEAD', 'refs/remotes/origin/main')

    def git(self, *args, cwd=None):
        return subprocess.check_output(['git', *args], cwd=cwd or self.repo,
                                       text=True, stderr=subprocess.DEVNULL).strip()

    def candidate(self, name, branch=None, revision='HEAD'):
        path = self.root / name
        options = ['-b', branch] if branch else ['--detach']
        self.git('worktree', 'add', *options, str(path), revision)
        return path

    def invoke(self, *args, fake_run=None):
        original_run = cleanup.run

        def in_repository(*command):
            if fake_run:
                result = fake_run(command)
                if result is not None:
                    return result
            return subprocess.check_output(command, cwd=self.repo, text=True,
                                           stderr=subprocess.DEVNULL).strip()

        def in_repository_process(command, **kwargs):
            kwargs.setdefault('cwd', self.repo)
            return original_process(command, **kwargs)

        original_process = subprocess.run
        output = io.StringIO()
        with patch.object(sys, 'argv', ['clean_worktrees.py', *args]), \
                patch.object(cleanup, 'run', side_effect=in_repository), \
                patch.object(cleanup.subprocess, 'run', side_effect=in_repository_process), \
                contextlib.redirect_stdout(output):
            cleanup.main()
        self.assertIs(cleanup.run, original_run)
        return output.getvalue()

    def test_apply_preserves_commit_excluded_from_fresh_base(self):
        (self.repo / 'file.txt').write_text('later')
        self.git('commit', '-am', 'later')
        self.git('push', 'origin', 'main')
        path = self.candidate('candidate')
        self.git('update-ref', 'refs/heads/main', self.initial, cwd=self.remote)
        self.git('config', 'remote.origin.fetch', '+refs/heads/other:refs/remotes/origin/other')
        output = self.invoke('--apply')
        self.assertTrue(path.is_dir())
        self.assertIn('HEAD not integrated', output)

    def test_apply_uses_fresh_integration_with_custom_fetch_mapping(self):
        (self.repo / 'file.txt').write_text('later')
        self.git('commit', '-am', 'later')
        path = self.candidate('candidate')
        self.git('push', 'origin', 'main')
        self.git('update-ref', 'refs/remotes/origin/main', self.initial)
        self.git('config', 'remote.origin.fetch', '+refs/heads/other:refs/remotes/origin/other')
        self.invoke('--apply')
        self.assertFalse(path.exists())
        self.assertTrue(self.repo.is_dir())

    def test_preview_queries_selected_repository_and_preserves_branch(self):
        path = self.candidate('candidate', branch='finished')
        self.git('remote', 'add', 'upstream', str(self.remote))
        self.git('update-ref', 'refs/remotes/upstream/main', self.initial)
        queries = []

        def fake(command):
            if command == ('git', 'remote', 'get-url', 'upstream'):
                return 'git@github.example:owner/target.git'
            if command[0] == 'gh':
                self.assertIn('--repo', command)
                self.assertEqual(command[command.index('--repo') + 1], 'github.example/owner/target')
                queries.append(command)
                return '[{"number": 1}]' if 'merged' in command else '[]'
            return None

        output = self.invoke('--remote', 'upstream', '--base', 'main', fake_run=fake)
        self.assertEqual(len(queries), 2)
        self.assertIn('ELIGIBLE', output)
        self.assertTrue(path.is_dir())
        self.assertEqual(self.git('rev-parse', 'finished'), self.initial)

    def test_api_failure_prevents_all_removal(self):
        first = self.candidate('detached')
        second = self.candidate('branched', branch='finished')

        def fake(command):
            if command == ('git', 'remote', 'get-url', 'origin'):
                return 'https://github.com/owner/target.git'
            if command[0] == 'gh':
                raise subprocess.CalledProcessError(1, ['gh', 'pr', 'list'])
            return None

        with self.assertRaises(subprocess.CalledProcessError):
            self.invoke('--apply', fake_run=fake)
        self.assertTrue(first.is_dir())
        self.assertTrue(second.is_dir())

    def test_apply_preserves_ignored_files(self):
        (self.repo / '.gitignore').write_text('private.txt\n')
        self.git('add', '.gitignore')
        self.git('commit', '-m', 'ignore private files')
        self.git('push', 'origin', 'main')
        path = self.candidate('candidate')
        (path / 'private.txt').write_text('retain this file')
        output = self.invoke('--apply')
        self.assertEqual((path / 'private.txt').read_text(), 'retain this file')
        self.assertIn('uncommitted or ignored files', output)


if __name__ == '__main__':
    unittest.main()
