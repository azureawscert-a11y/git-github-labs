# G4: Wrong branch, urgent fix

Book chapter: 8. About 30 minutes. Git only: no GitHub account, no internet.

## The situation

You have been building a gift wrap option all morning. Three problems:

1. You forgot to make a branch. Your two feature commits are on `main`.
2. You are halfway through the next change, and it is not committed.
3. Yesterday you deleted the branch `experiment/banner` by mistake. Your
   manager now wants that idea back.

Then this lands:

> **From:** the shop owner, URGENT
>
> The website says a mug costs **129.00**. It should be **12.90**. Fix it on
> main and push it now, please. Nothing else goes out with it.

## How this drill works

`setup.sh` makes two folders in `~/git-lab/part1/g4-a`:

| Folder | Plays the role of |
|---|---|
| `team.git` | GitHub: the shared copy. Never edit it directly. |
| `you` | Your clone, in the mess described above. |

## You need

- Git working in a terminal (Start Here). On Windows, use Git Bash.
- A text editor for one line, such as `nano prices.txt`
  (**Ctrl + O**, **Enter** to save, **Ctrl + X** to quit).

## Start

```bash
cd ~/git-lab/git-github-labs/part1/G4-wrong-branch-urgent-fix
bash setup.sh
cd ~/git-lab/part1/g4-a/you
```

**Start from:** `pwd` ends in `g4-a/you`.

## Do it

Write your answer to each **Guess** before you run the command.

1. **Look.**

   ```bash
   git status
   git log --oneline --graph --all
   ```

   `git status` says `Your branch is ahead of 'origin/main' by 2 commits` and
   shows `checkout.txt` as modified. The log shows your two `feat:` commits
   on `main`.

2. **Stop and think.** The obvious move is to throw main back to the shared
   version with `git reset --hard origin/main`.
   **Guess first:** if you ran that right now, what would happen to your two
   commits? And to your unsaved change in `checkout.txt`?

3. **Park the unsaved change.**

   ```bash
   git stash push -m "gift wrap in progress"
   git status
   git stash list
   ```

   `git status` is now clean. The change is safe in the stash.

4. **Put a label on your two commits.**

   ```bash
   git branch feature/gift-wrap
   ```

   **Guess first:** which branch are you on after this command?
   (`git branch --show-current` tells you.)

5. **Clean up main.** Now it is safe:

   ```bash
   git reset --hard origin/main
   git log --oneline --graph --all
   ```

   main is back to the shared version, and your two commits now live on
   `feature/gift-wrap`. The log also shows the stash as an odd extra commit
   marked `refs/stash`; that is just how Git stores it. Ignore it.

6. **Ship the urgent fix.** Change the mug line in `prices.txt` to
   `Mug .......... 12.90`, then:

   ```bash
   git diff
   git add prices.txt
   git commit -m "fix: correct the mug price"
   git push
   ```

   Check `git diff` first: only the mug line should change.

7. **Back to your feature.**

   ```bash
   git switch feature/gift-wrap
   git stash pop
   git status
   ```

   **Guess first:** after `git stash pop`, is your unfinished line committed,
   staged, or just changed in the file?

8. **Get yesterday's branch back.** A deleted branch only deletes the label.
   The commit is still there, and `git reflog` remembers every commit you
   have been on:

   ```bash
   git reflog
   ```

   Press `q` if you see `(END)`. Find the line ending in
   `commit: feat: add holiday banner` and copy the short hash at its start.
   Then:

   ```bash
   git branch experiment/banner PASTE-THE-HASH
   git log --oneline -1 experiment/banner
   ```

9. **Check your work:**

   ```bash
   bash ~/git-lab/git-github-labs/part1/G4-wrong-branch-urgent-fix/check.sh
   ```

## Done when

- [ ] The shared main has exactly one new commit: the mug price fix
- [ ] Neither the feature commits nor your unfinished line reached main
- [ ] `feature/gift-wrap` has both feature commits, and you are on it
- [ ] Your unfinished line is back in `checkout.txt`, and the stash is empty
- [ ] `experiment/banner` is back
- [ ] `check.sh` prints `All checks passed`

## Hints

<details><summary>Hint 1: the answer to step 2</summary>

The two commits would lose their only label, but Git keeps them for a while
and `git reflog` can still find them. The unsaved change would be **gone for
good**: Git never stored it, so nothing can bring it back. That is why you
stash first.
</details>

<details><summary>Hint 2: I reset before making the branch</summary>

Your commits are not lost. `git reflog` shows a line ending in
`commit: feat: no gift wrap for mugs`. Run
`git branch feature/gift-wrap PASTE-THAT-HASH`.
</details>

<details><summary>Hint 3: git stash pop said CONFLICT</summary>

You popped it on a branch where the file is different, probably main. Run
`git restore --staged checkout.txt` and `git restore checkout.txt` to undo the
attempt (the stash is kept when a pop conflicts), then `git switch
feature/gift-wrap` and pop again.
</details>

<details><summary>Hint 4: I used git stash apply</summary>

`apply` brings the change back but keeps the stash too. Once your line is
back, `git stash drop` removes the old copy.
</details>

## Start over

```bash
bash reset.sh       # asks you to type yes, then deletes ~/git-lab/part1/g4-a
bash setup.sh
```

## Next week: try it cold

```bash
bash setup.sh b     # an on-call page and a runbook: ~/git-lab/part1/g4-b/you
bash check.sh b
bash reset.sh b
```

The variant b situation: two runbook commits are on main by mistake, a line is
half-written, and yesterday you deleted `experiment/status-page`. Urgent: the
escalation phone in `oncall.md` says 555-9999 and must say
`Escalation phone: 555-0100`. Put the runbook work on `feature/db-runbook`. Do
it without this page.

## At work

This is a normal week. Work on the wrong branch, an interruption, a "can you
just quickly fix", a branch deleted too early. The order that never loses
anything: **stash** what is unsaved, **label** what is committed, **then**
reset or switch. And when something seems gone, look in `git reflog` before
you panic: by default Git keeps what you committed findable there for at least
30 days.

Stuck? `SOLUTION.md` has one complete answer. Try first.
