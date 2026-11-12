# Git and GitHub Study Guide: labs

Hands-on labs for the *Git / GitHub Study Guide* by Jey Singh. Each lab is a
work ticket: a script sets up a starting repo on your own GitHub account, you
do the work the way a team would, and a written solution shows one complete
answer.

## What you need

- A free GitHub account. Every lab uses **public** repos, so nothing needs a paid plan.
- Git (book Chapter 2) and the GitHub CLI `gh`, signed in with `gh auth login`.
- A bash shell: Terminal on macOS or Linux, Git Bash on Windows.

## How each lab works

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
| [P2-1](part2/P2-1-ready-for-contributors/TICKET.md) | Make this repo ready for contributors | 9, 10, 11 |
| [P2-2](part2/P2-2-run-a-sprint/TICKET.md) | Run a sprint | 12, 13, 14, 15 |
| [P2-3](part2/P2-3-publish-and-share/TICKET.md) | Publish and share | 16, 17, 18 |
| [P2-4](part2/P2-4-lock-it-down/TICKET.md) | Lock it down | 19, 20 |

## Safety

- Everything the labs create is public. Never put a password, key, token or personal detail in a lab repo or gist.
- `reset.sh` asks you to type `yes` and only deletes the repos, project, team, gists and codespaces that its own lab created.
- Read a script before you run it. They are short on purpose.

## License

MIT. See [LICENSE](LICENSE).
