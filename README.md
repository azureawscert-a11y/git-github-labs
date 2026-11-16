# Git and GitHub Study Guide: labs

Hands-on labs for the *Git / GitHub Study Guide* by Jey Singh. Each lab is a
work ticket: a script sets up a starting repo, you do the work the way a team
would, a checker or a written solution shows whether you got there, and a reset
script lets you start over.

- **Part 1 drills** run on your own computer with Git only. No GitHub account, and no internet once you have cloned this repo.
- **Part 2 labs** use your own free GitHub account.

## Free sample and the book

[**Download the free sample (PDF, 18 pages)**](https://github.com/azureawscert-a11y/git-github-labs/raw/main/sample/Git-GitHub-FREE-SAMPLE.pdf): Start Here, the drills page, the pull request chapter opening, the troubleshooting chapter and the GH-900 objective map.

The full book has 151 pages: 30 chapters from your first terminal command to a team workflow, 145 quiz questions, these labs, a capstone and GH-900 exam prep. A separate Practice Pack adds two full 60-question practice exams.

**Get the book:** [jeysingh.com/git](https://www.jeysingh.com/git)

- [Complete Bundle: book, labs and Practice Pack](https://jeysingh.gumroad.com/l/git-github-complete-bundle)
- [Study Guide and labs only](https://jeysingh.gumroad.com/l/git-github-guide)
- [Practice Pack only](https://jeysingh.gumroad.com/l/git-github-practice-pack)
- [Study Guide on Leanpub](https://leanpub.com/git-github-guide)

Free guides on the site: [git push rejected (fetch first)](https://www.jeysingh.com/learn/git-push-rejected-fetch-first), [git reset vs revert vs restore](https://www.jeysingh.com/learn/git-reset-vs-revert-vs-restore), [GH-900 study plan](https://www.jeysingh.com/learn/gh-900-study-plan).

## Get the labs

```bash
mkdir -p ~/git-lab && cd ~/git-lab
git clone https://github.com/azureawscert-a11y/git-github-labs.git
cd git-github-labs
```

The labs repo is public, so cloning needs no sign-in.

## What you need

**Part 1:** Git and a bash shell (book: Start Here). That is all.

**Part 2:**

- A free GitHub account. Every lab uses **public** repos, so nothing needs a paid plan.
- Git (book Chapter 2) and the GitHub CLI `gh`, signed in with `gh auth login`.
- A bash shell: Terminal on macOS or Linux, Git Bash on Windows.
- Python 3 for P2-1 and P2-2, whose starter apps and tests are in Python. Check with `python3 --version` (on Windows, `python --version`).

## Before you start: keep your email private

Web commits, squash merges and "Apply suggestion" record your account's
**primary** email, even if your local Git uses the no-reply address. In
**Settings > Emails**, tick **Keep my email addresses private** and **Block
command line pushes that expose my email**. Then set your local Git email to the
no-reply address shown on that page (book Chapter 2).

## How each Part 1 drill works

```bash
cd part1/G1-split-the-commit
bash setup.sh     # creates a practice repo in ~/git-lab/part1
# run the cd line it prints, read TICKET.md and do the work there
cd ~/git-lab/git-github-labs/part1/G1-split-the-commit   # back to the drill folder
bash check.sh     # PASS or FAIL for each "Done when" item, with a hint
bash reset.sh     # deletes the practice repo so you can start over
```

`check.sh` and `reset.sh` live in the drill folder, not in the practice repo.
`setup.sh` also prints their full paths, which work from any folder.

Each drill has a second variant for a cold retry a few days later:
`bash setup.sh b`, `bash check.sh b`, `bash reset.sh b`.

## How each Part 2 lab works

```bash
cd part2/P2-1-ready-for-contributors
bash setup.sh     # creates the starting repo and a working folder
# read TICKET.md and do the work
bash reset.sh     # deletes what the lab created, so you can start over
```

Your working folders go in `~/git-lab/part2`. Set `LAB_HOME` to use another folder.

Some steps need extra `gh` permissions. The scripts check and tell you the
exact `gh auth refresh -s ...` command to run.

## Labs

| Lab | Ticket | Book chapters |
|---|---|---|
| [G1](part1/G1-split-the-commit/TICKET.md) | Split the commit: two changes and a debug line in one file | Start Here, 1, 3 |
| [G2](part1/G2-teammate-conflict/TICKET.md) | Your teammate pushed first: rejected push, fetch, merge conflict | 4, 5, 6 |
| [G3](part1/G3-clean-up-before-review/TICKET.md) | Clean up before review: interactive rebase onto new main, safe force push | 7 |
| [G4](part1/G4-wrong-branch-urgent-fix/TICKET.md) | Wrong branch, urgent fix: stash, move commits, hotfix, reflog rescue | 8 |
| [P2-1](part2/P2-1-ready-for-contributors/TICKET.md) | Make this repo ready for contributors | 9, 10, 11 |
| [P2-2](part2/P2-2-run-a-sprint/TICKET.md) | Run a sprint | 12, 13, 14, 15 |
| [P2-3](part2/P2-3-publish-and-share/TICKET.md) | Publish and share | 16, 17, 18 |
| [P2-4](part2/P2-4-lock-it-down/TICKET.md) | Lock it down | 19, 20 |

## Found a mistake?

Corrections to the book are listed in [ERRATA.md](ERRATA.md). Found one that is not there? Open an issue.

## Safety

- Everything the labs create is public. Never put a password, key, token or personal detail in a lab repo or gist.
- Part 1 `reset.sh` asks you to type `yes` and only deletes its own drill folder in `~/git-lab/part1`.
- Part 2 `reset.sh` asks you to type `yes` and only deletes the repos, project, team, gists and codespaces that its own lab created.
- Read a script before you run it. They are short on purpose.

## License

MIT. See [LICENSE](LICENSE).
