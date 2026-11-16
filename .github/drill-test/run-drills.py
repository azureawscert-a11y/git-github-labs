"""Run every Part 1 drill end to end, the way a reader would.

For each drill and variant: setup, check that the unfinished ticket fails,
solve the ticket with ordinary Git commands, check that it passes, reset.
Runs on Linux, macOS and Windows (Git Bash). Used by .github/workflows/drills.yml.
Not part of the exercises: readers never need to run this.
"""
import os, sys, json, shutil, pathlib, subprocess, tempfile

REPO = pathlib.Path(__file__).resolve().parents[2]
WIN = os.name == 'nt'
BASH = shutil.which('bash')
assert BASH, 'bash not found'
if WIN and 'system32' in BASH.lower():
    sys.exit('Found the WSL bash, not Git Bash: ' + BASH)

def posix(p):
    """A path bash understands. On Windows, C:\\x\\y becomes /c/x/y."""
    p = pathlib.Path(p).resolve()
    if not WIN:
        return str(p)
    return subprocess.run(['cygpath', '-u', str(p)], capture_output=True, text=True, check=True).stdout.strip()

RUN = pathlib.Path(tempfile.mkdtemp(prefix='drills-'))
cfg = RUN / 'gitconfig'
cfg.write_bytes((
    '[user]\n name = Test Learner\n email = learner@example.invalid\n'
    '[init]\n defaultBranch = main\n[commit]\n gpgsign = false\n'
    '[pull]\n rebase = false\n'
    + ('[core]\n autocrlf = true\n' if WIN else '')).encode())
ENV = dict(os.environ, GIT_CONFIG_GLOBAL=str(cfg), GIT_CONFIG_NOSYSTEM='1',
           GIT_TERMINAL_PROMPT='0', GIT_EDITOR='true', GIT_PAGER='cat',
           LAB_HOME=posix(RUN) + '/part1')
LOG = []

def run(args, cwd, expected=0, input=None, extra=None, label=None):
    env = dict(ENV, **(extra or {}))
    p = subprocess.run([str(a) for a in args], cwd=str(cwd), env=env,
                       input=input.encode() if input is not None else None,
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    out = p.stdout.decode('utf-8', 'replace')
    LOG.append({'label': label or ' '.join(map(str, args))[:120], 'exit': p.returncode, 'output': out})
    if expected is not None and p.returncode != expected:
        print(out)
        raise SystemExit(f'FAILED: {label or args} exited {p.returncode}, expected {expected}')
    return out

def git(cwd, *a, **k):
    return run(['git', *a], cwd, **k)

def bash(script, *a, **k):
    return run([BASH, posix(script), *a], **k)

def put(path, text):
    path.write_bytes(text.encode())          # always LF, like the drills' own files

def get(path):
    return path.read_bytes().decode().replace('\r\n', '\n')

# 1. Line endings: shell scripts must be LF on every platform.
bad = [str(p.relative_to(REPO)) for p in REPO.rglob('*.sh') if b'\r' in p.read_bytes()]
readme_crlf = b'\r\n' in (REPO / 'README.md').read_bytes()
print('Scripts with CRLF:', bad or 'none', '| README.md checked out with CRLF:', readme_crlf)
if bad:
    sys.exit('Shell scripts have Windows line endings. Check .gitattributes.')

editor = RUN / 'editor.py'
put(editor, '''import sys, os, pathlib
mode, p = sys.argv[1:]; f = pathlib.Path(p)
if mode == 'sequence':
    out, n = [], 0
    for line in f.read_bytes().decode().splitlines():
        if line.startswith('pick '):
            line = ['reword', 'fixup', 'fixup', 'reword', 'fixup'][n] + line[4:]; n += 1
        out.append(line)
    f.write_bytes(('\\n'.join(out) + '\\n').encode())
else:
    c = pathlib.Path(os.environ['DRILL_EDITOR_COUNT'])
    n = int(c.read_text()) if c.exists() else 0
    f.write_bytes((os.environ['DRILL_MESSAGES'].split('|')[n] + '\\n').encode())
    c.write_text(str(n + 1))
''')
PY = pathlib.Path(sys.executable).as_posix()

NAMES = {1: 'G1-split-the-commit', 2: 'G2-teammate-conflict',
         3: 'G3-clean-up-before-review', 4: 'G4-wrong-branch-urgent-fix'}
results = []
for n in range(1, 5):
    for v in ('a', 'b'):
        src = REPO / 'part1' / NAMES[n]
        args = [] if v == 'a' else ['b']
        tag = f'G{n}{v}'
        bash(src / 'setup.sh', *args, cwd=src, label=tag + ' setup')
        root = RUN / 'part1' / f'g{n}-{v}'
        cwd = root if n == 1 else root / 'you'
        bash(src / 'check.sh', *args, cwd=cwd, expected=1, label=tag + ' unfinished ticket is rejected')
        if n == 1:
            fname = 'menu.txt' if v == 'a' else 'hours.txt'
            git(cwd, 'add', '-p', input='y\nn\nn\n')
            git(cwd, 'commit', '-m', 'fix: update opening hours' if v == 'b' else 'fix: update latte price')
            git(cwd, 'add', '-p', input='n\ny\n')
            p = cwd / fname
            t = get(p)
            put(p, t.replace('Iced tea ....... 3.50', 'Iced tea ....... 3.75') if v == 'a'
                else t.replace('Civic Holday', 'Civic Holiday'))
            git(cwd, 'add', '-p', input='n\ny\n')
            git(cwd, 'commit', '-m', 'feat: add holiday closing' if v == 'b' else 'feat: add iced tea')
            git(cwd, 'restore', fname)
        elif n == 2:
            fname = 'party.txt' if v == 'a' else 'schedule.txt'
            p = cwd / fname; t = get(p)
            if v == 'a':
                yours = t.replace('Venue ....... The Lakeview Room', 'Venue ....... The Harbour Room').replace(
                    'Food ........ pizza', 'Food ........ pizza, plus a vegan option')
                final = yours.replace('Food ........ pizza, plus a vegan option',
                                      'Food ........ pizza and salad, plus a vegan option')
            else:
                yours = t.replace('Topic ....... Git and GitHub', 'Topic ....... Git branches and merges').replace(
                    'Room ........ 204, Building B', 'Room ........ 204, Building B (projector)')
                final = yours.replace('Room ........ 204, Building B (projector)',
                                      'Room ........ 310, Building B (projector)')
            put(p, yours); git(cwd, 'add', fname); git(cwd, 'commit', '-m', 'docs: update team requirements')
            git(cwd, 'push', expected=1, label=tag + ' push rejected, as the ticket expects')
            git(cwd, 'fetch'); git(cwd, 'merge', 'origin/main', expected=1, label=tag + ' conflict, as the ticket expects')
            put(p, final); git(cwd, 'add', fname); git(cwd, 'commit', '-m', 'merge: keep both requirements'); git(cwd, 'push')
            git(root / 'alex', 'pull')
        elif n == 3:
            git(cwd, 'fetch'); git(cwd, 'branch', 'backup-faq')
            msgs = ('docs: add FAQ with returns and shipping|docs: add payment question' if v == 'a'
                    else 'docs: add first-day setup steps|docs: add working from home section')
            extra = {'GIT_SEQUENCE_EDITOR': f'"{PY}" "{editor.as_posix()}" sequence',
                     'GIT_EDITOR': f'"{PY}" "{editor.as_posix()}" message',
                     'DRILL_EDITOR_COUNT': str(RUN / f'editor-{v}'), 'DRILL_MESSAGES': msgs}
            git(cwd, 'rebase', '-i', 'origin/main', extra=extra)
            git(cwd, 'push', expected=1, label=tag + ' plain push rejected, as the ticket expects')
            git(cwd, 'push', '--force-with-lease', '--force-if-includes')
        else:
            branch = 'feature/gift-wrap' if v == 'a' else 'feature/db-runbook'
            lost = 'experiment/banner' if v == 'a' else 'experiment/status-page'
            msg = 'feat: add holiday banner' if v == 'a' else 'docs: draft status page'
            fname = 'prices.txt' if v == 'a' else 'oncall.md'
            git(cwd, 'stash', 'push', '-m', 'unfinished feature')
            git(cwd, 'branch', branch); git(cwd, 'reset', '--hard', 'origin/main')
            p = cwd / fname; t = get(p)
            put(p, t.replace('129.00', '12.90') if v == 'a' else t.replace('555-9999', '555-0100'))
            git(cwd, 'add', fname); git(cwd, 'commit', '-m', 'fix: urgent correction'); git(cwd, 'push')
            git(cwd, 'switch', branch); git(cwd, 'stash', 'pop')
            reflog = git(cwd, 'reflog', '--format=%H%x09%gs')
            sha = next(l.split('\t')[0] for l in reflog.splitlines() if l.endswith('commit: ' + msg))
            git(cwd, 'branch', lost, sha)
        out = bash(src / 'check.sh', *args, cwd=cwd, expected=None, label=tag + ' finished ticket')
        ok = 'All checks passed. Ticket done.' in out
        if not ok:
            print(out)
        warn = sum('CRLF' in e['output'] for e in LOG)
        results.append((tag, ok, out.count('  PASS  ')))
        print(f'{tag}: {"PASS" if ok else "FAIL"} ({out.count("  PASS  ")} checks)')
        if ok:
            bash(src / 'reset.sh', *args, cwd=src, input='yes\n', label=tag + ' reset')
            assert not root.exists(), f'{tag}: reset left {root}'

crlf_warnings = sum('CRLF' in e['output'] for e in LOG)
print('Line-ending warnings shown to the learner:', crlf_warnings)
(RUN / 'log.json').write_bytes(json.dumps(LOG, indent=1).encode())
if not all(ok for _, ok, _ in results) or crlf_warnings:
    sys.exit('Some drills failed or printed line-ending warnings. Full log: ' + str(RUN / 'log.json'))
print('All 8 drill variants passed.')
