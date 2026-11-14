# G4 solution

One way to finish the ticket. Work in `~/git-lab/part1/g4-a/you`.

## 1. Look

```bash
git status
git log --oneline --graph --all
```

```text
On branch main
Your branch is ahead of 'origin/main' by 2 commits.
...
        modified:   checkout.txt
```

```text
* 4884bb2 (HEAD -> main) feat: no gift wrap for mugs
* cd2d8d5 feat: add gift wrap option
* 87097fc (origin/main) chore: first version
```

Your hashes will be different.

## 2. Answer to the guess

The two commits would lose their label but could still be found with
`git reflog`. The unsaved line in `checkout.txt` would be deleted for good,
because Git never saved it anywhere.

## 3. Stash

```bash
git stash push -m "gift wrap in progress"
```

```text
Saved working directory and index state On main: gift wrap in progress
```

## 4. Label the commits

```bash
git branch feature/gift-wrap
git branch --show-current
```

**Answer to the guess:** still `main`. `git branch NAME` creates a label on
the current commit but does not move you. (`git switch -c NAME` would.)

## 5. Clean up main

```bash
git reset --hard origin/main
```

```text
HEAD is now at 87097fc chore: first version
```

## 6. Ship the fix

```bash
nano prices.txt      # Mug .......... 129.00  becomes  Mug .......... 12.90
git diff
git add prices.txt
git commit -m "fix: correct the mug price"
git push
```

## 7. Back to the feature

```bash
git switch feature/gift-wrap
git stash pop
git status
```

```text
Changes not staged for commit:
        modified:   checkout.txt
...
Dropped refs/stash@{0} (...)
```

**Answer to the guess:** just changed in the file, exactly as it was before
you stashed. Nothing is staged or committed. `pop` also deletes the stash.

## 8. Get the deleted branch back

```bash
git reflog
```

```text
4884bb2 HEAD@{0}: checkout: moving from main to feature/gift-wrap
...
5c0f6b4 HEAD@{7}: commit: feat: add holiday banner
...
```

```bash
git branch experiment/banner 5c0f6b4
git log --oneline -1 experiment/banner
```

```text
5c0f6b4 feat: add holiday banner
```

## 9. Check

```text
  PASS  The feature commits are not on the shared main.
  PASS  The urgent fix is on the shared main.
  PASS  The shared main got exactly one new commit, touching only prices.txt.
  PASS  Your unfinished work did not reach main.
  PASS  Your main matches the shared main.
  PASS  Branch feature/gift-wrap has both feature commits.
  PASS  You are back on feature/gift-wrap.
  PASS  Your unfinished line is back in checkout.txt.
  PASS  The stash is empty.
  PASS  Yesterday's branch experiment/banner is back.

All checks passed. Ticket done.
```

## If you made a mistake

- **Reset before stashing:** the unfinished line is gone. Run
  `bash reset.sh` and `bash setup.sh` and stash first. This is the one
  mistake in this drill Git cannot undo.
- **Reset before labelling:** `git reflog`, find
  `commit: feat: no gift wrap for mugs`, then
  `git branch feature/gift-wrap THAT-HASH`.
- **Pushed main with the feature commits on it:** the shared main now has
  work that was not ready. On a real team you would ask before rewriting
  main; here, start over.
- **Popped the stash on main and committed it with the fix:** the unfinished
  line went out with the hotfix. Start over, and only `git add prices.txt`.

## Variant b

Same steps. Stash, `git branch feature/db-runbook`,
`git reset --hard origin/main`, fix `Escalation phone: 555-0100` in
`oncall.md`, commit and push, switch to `feature/db-runbook`, `git stash pop`,
then find `commit: docs: draft status page` in `git reflog` and
`git branch experiment/status-page THAT-HASH`.
