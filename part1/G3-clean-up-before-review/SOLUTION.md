# G3 solution

One way to finish the ticket. Work in `~/git-lab/part1/g3-a/you`.

## 1. Look

```bash
git log --oneline --graph --all
```

Your hashes will be different.

```text
* 5280ce2 (HEAD -> feature/faq, origin/feature/faq) typo again
* 2545b1f more
* d9e2b7a typo
* acbc1c6 wip
* e33e4f9 add faq heading
* 0277dc6 (origin/main, origin/HEAD, main) docs: first version of help.md
```

**Answer to the guess:** no. Alex's commit is on the shared repo, but your
laptop only learns about it when you fetch.

## 2. Catch up

```bash
git fetch
git log --oneline --graph --all
```

```text
* 5280ce2 (HEAD -> feature/faq, origin/feature/faq) typo again
* 2545b1f more
* d9e2b7a typo
* acbc1c6 wip
* e33e4f9 add faq heading
| * 97643da (origin/main, origin/HEAD) docs: add opening days
|/
* 0277dc6 (main) docs: first version of help.md
```

## 3. Safety net

```bash
git branch backup-faq
```

## 4 and 5. Rebase and tidy

```bash
git rebase -i origin/main
```

**Answer to the guess:** the oldest commit is at the top. The list is the
order Git will replay the commits in.

Change the list to:

```text
reword e33e4f9 add faq heading
fixup acbc1c6 wip
fixup d9e2b7a typo
reword 2545b1f more
fixup 5280ce2 typo again
```

Save and close. The editor opens twice more, once per `reword`. Replace the
message each time:

```text
docs: add FAQ with returns and shipping
```

```text
docs: add payment question
```

```text
Successfully rebased and updated refs/heads/feature/faq.
```

## 6. Check nothing was lost

```bash
git log --oneline --graph --all
```

Your branch now has two commits on top of Alex's `docs: add opening days`.
The five old commits are still visible, because `origin/feature/faq` and
`backup-faq` still point at them.

```bash
git diff backup-faq
```

**Answer to the guess:** only Alex's line differs. The backup has the old
"Welcome" line, and your branch now has Alex's "open 7 days a week" version
from main. Every FAQ line is the same, so no work was lost.

## 7. Plain push

```text
 ! [rejected]        feature/faq -> feature/faq (non-fast-forward)
```

**Answer to the guess:** no. The rebase made new commits with new hashes, and
the shared repo still has the old five. A plain push would have to throw them
away, so Git refuses.

## 8. Safe force push

```bash
git push --force-with-lease --force-if-includes
```

```text
 + 5280ce2...3c6c193 feature/faq -> feature/faq (forced update)
```

`--force-with-lease` replaces the branch only if nobody else pushed to it
since your last fetch. `--force-if-includes` also refuses if you never looked
at what is there. Here the branch is yours alone, so both agree.

## 9. Check

```text
  PASS  You are on feature/faq.
  PASS  main on the shared repo still has Alex's commit.
  PASS  The shared branch starts from the latest main.
  PASS  The shared branch has no merge commits.
  PASS  The shared branch has exactly two commits.
  PASS  No typos are left in help.md.
  PASS  All of your work is still in help.md.
  PASS  Commit 1 holds the returns and shipping questions, with the typo fixed.
  PASS  Commit 2 holds the payment question, with its typo fixed.
  PASS  Message "docs: add FAQ with returns and shipping" says what changed.
  PASS  Message "docs: add payment question" says what changed.
  PASS  Your working tree is clean.
  PASS  Your branch matches the shared repo.

All checks passed. Ticket done.
```

Then `git branch -D backup-faq`.

## If you made a mistake

- **Marked a commit `drop`:** its work is gone from the branch. Run
  `git reset --hard backup-faq` and redo step 4.
- **Ended with one commit, or three:** count your `pick` and `reword` lines.
  Each one becomes a commit. Redo from the backup.
- **Ran `git pull` after the rejected push:** `git reset --hard HEAD~1`
  removes the merge, then do step 8.
- **Used `git rebase -i HEAD~5`:** that tidies the commits but leaves the
  branch on the old main. Run `git rebase origin/main`, then push as in step 8.

## Variant b

Same steps on branch `feature/setup-guide` in `setup.md`:

```text
reword ... start guide
fixup ... wip
fixup ... fix spelling
reword ... vpn
fixup ... oops
```

Messages: `docs: add first-day setup steps` and
`docs: add working from home section`.
