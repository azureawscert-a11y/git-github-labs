# G1 solution

One way to finish the ticket. Work in `~/git-lab/part1/g1-a`.

## 1. Look

```bash
git diff
```

**Answer to the guess:** three chunks. The latte line near the top, the
DEBUG line in the bakery, and the new iced tea line at the bottom. They are far
enough apart that Git shows each one separately.

## 2 to 4. Stage and commit the latte price

```bash
git add -p
# latte chunk:  y
# DEBUG chunk:  n
# iced tea:     n
git diff --staged
git diff
git commit -m "fix: raise latte price to 4.50"
```

**Answer to the guess:** `git diff --staged` shows only the latte change
(`-4.25`, `+4.50`). Plain `git diff` shows the other two: the DEBUG line and
iced tea at 3.50. Staging moved one change into the next commit and left the
rest in your working files.

## 5 to 7. Stage iced tea, then the price changes

```bash
git add -p
# DEBUG chunk:  n
# iced tea:     y
nano menu.txt        # change Iced tea 3.50 to 3.75, Ctrl + O, Enter, Ctrl + X
git diff --staged
git diff
```

**Answer to the guess:** `git diff --staged` still shows `+Iced tea ... 3.50`.
`git diff` shows the DEBUG line and the change from 3.50 to 3.75. If you
committed now, the commit would say **3.50**. The staging area holds a copy of
the file from the moment you ran `git add`, not a live link to it.

## 8. Stage the corrected line and commit

```bash
git add -p
# DEBUG chunk:  n
# iced tea:     y   (the 3.50 to 3.75 change)
git diff --staged    # now shows +Iced tea ... 3.75
git commit -m "feat: add iced tea to cold drinks"
```

## 9. Throw away the test line

```bash
git diff             # only the DEBUG line is left
git restore menu.txt
git status           # nothing to commit, working tree clean
```

## Check

```bash
git log --oneline
bash /path/to/git-github-labs/part1/G1-split-the-commit/check.sh
```

```text
  PASS  You are on main.
  PASS  Exactly two new commits after the starting commit.
  PASS  Commit "fix: raise latte price to 4.50" holds only the latte price.
  PASS  Commit "feat: add iced tea to cold drinks" holds only the iced tea line at 3.75.
  PASS  No commit contains the debug line.
  PASS  Working tree is clean.

All checks passed. Ticket done.
```

## If you made a mistake

- **Committed iced tea at 3.50:** you skipped the second `git add`. Fix the
  last commit: `git add -p` (y for the iced tea change), then
  `git commit --amend --no-edit`.
- **Committed the DEBUG line:** if it is in your last commit, delete the line,
  `git add menu.txt`, `git commit --amend --no-edit`.
- **Everything in one commit:** easiest is `bash reset.sh` and
  `bash setup.sh`. Chapter 8 shows `git reset --soft HEAD~1`, which undoes the
  commit but keeps the changes staged so you can split them.

`--amend` rewrites the last commit. That is fine here because nothing was
pushed. Never amend a commit other people already have (Chapter 3).

## Variant b

Same steps with `hours.txt`: commit the Saturday hours change, stage
`Civic Holday`, fix the spelling to `Civic Holiday`, stage again, commit, then
`git restore hours.txt` to drop the DEBUG line. Check with `bash check.sh b`.
