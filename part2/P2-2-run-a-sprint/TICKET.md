# P2-2: Run a sprint

Chapters 12, 13, 14 and 15. About 60 minutes.

## The ticket

> **From:** your product owner
> **Repo:** `p2-2-tip-split`
>
> Users are angry. Splitting a 100 dollar bill three ways with a 15% tip says
> each person pays 533 dollars. Please run a one-week sprint: get the problems
> into issues with a proper bug form, plan them on a board, and fix the top
> three through reviewed pull requests.

What the app does today (real output from the starter code):

```text
$ python3 tip.py 100 3 15
Each person pays: 533.3333333333334

$ python3 tip.py 100 0 15
ZeroDivisionError: float division by zero
```

## The backlog

1. Bug: a 15% tip is treated as 1500%.
2. Bug: amounts print with many decimals instead of cents.
3. Bug: zero people crashes the app instead of showing a message.
4. Docs: the README does not say how to run the app.
5. Feature: let people round each share up to the next dollar.

## Start

```bash
bash setup.sh
cd ~/git-lab/part2/p2-2-tip-split
```

## Done when

- [ ] `.github/ISSUE_TEMPLATE/bug.yml` is an issue form with at least a "What happened" and a "Steps to reproduce" field, and it adds the `bug` label
- [ ] Five issues exist, one per backlog item; the three bugs were filed through the form
- [ ] Each issue has a label; the three bugs also have `sprint-1` and are assigned to you
- [ ] A project named **P2-2 Sprint** holds all five issues, has a Board view grouped by Status, and has the **Item closed** workflow on
- [ ] Three merged PRs fix bugs 1 to 3, each closing its issue with a keyword such as `Fixes #1`
- [ ] On one PR you left a review comment with a suggested change and committed the suggestion
- [ ] The repo's watch setting is **Custom** with Issues and Pull requests ticked (Chapter 15)
- [ ] Bugs 1 to 3 show Done on the board, and `python3 -m unittest` passes

## Hints

- You cannot approve your own PR, but you can comment on it. Use the **suggestion** button in a review comment, then **Commit suggestion**.
- `gh project` needs the `project` scope: `gh auth refresh -s project`.
- Chapter 12 has the issue form syntax, Chapter 13 the PR flow, Chapter 14 the board.
- Stuck? `SOLUTION.md` has one complete answer. Try first.

## Start over

```bash
bash reset.sh
```

Needs the `delete_repo` and `project` scopes.
