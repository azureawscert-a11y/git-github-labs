# P2-1: Make this repo ready for contributors

Chapters 9, 10 and 11. About 40 minutes.

## The ticket

> **From:** your team lead
> **Repo:** `p2-1-pocket-budget`
>
> We are opening `pocket-budget` to outside contributors next week. Right now the
> README says "TODO" and there is no license, so legally nobody can reuse it.
> Please make it ready: people should know what it is, how to run it, how to
> help, and how to report a security problem. Every change should be reviewed
> by you by default. Then make it a template so the next team can start from it.

## Start

```bash
bash setup.sh
cd ~/git-lab/part2/p2-1-pocket-budget
```

## Done when

- [ ] `README.md` says what the tool does, how to run it, how to run the test, and links to CONTRIBUTING (Chapter 11 Markdown: a heading, a code block, a link)
- [ ] `LICENSE` exists (MIT is fine) and GitHub shows the license in the About box
- [ ] `CONTRIBUTING.md` explains how to propose a change: issue first, branch, PR, test passes
- [ ] `SECURITY.md` tells people not to open public issues for vulnerabilities, and how to report privately
- [ ] `.github/CODEOWNERS` makes you the owner of everything
- [ ] The repo has a description and at least three topics
- [ ] The repo is marked as a template
- [ ] A second public repo, `p2-1-from-template`, was created from it

## Hints

- Insights > Community Standards shows what is still missing.
- On the web, **Add file > Create new file**, name it `LICENSE`, and GitHub offers **Choose a license template**.
- Chapter 10 has the file tree, the template steps and the `gh repo create --template` command.
- Stuck? `SOLUTION.md` has one complete answer. Try first.

## Start over

```bash
bash reset.sh
```

This deletes both lab repos and the local folder. You need the `delete_repo`
scope once: `gh auth refresh -s delete_repo`.
