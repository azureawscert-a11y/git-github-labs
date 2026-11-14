# G1: Split the commit

Book chapters: Start Here, 1 and 3. About 25 minutes. Git only: no GitHub account, no internet.

## The ticket

> **From:** the cafe manager
> **Repo:** `g1-a` (a local practice repo)
>
> Two changes for the menu, please, as two separate commits so we can undo
> either one later:
>
> 1. The latte now costs 4.50.
> 2. Add iced tea to the cold drinks.
>
> Oh, and I left a test line in the file while checking the layout. It must
> never reach the history.

All three changes are already in `menu.txt`, mixed together. Your job is to
turn them into two clean commits and throw the test line away.

## You need

- Git working in a terminal (Start Here). On Windows, use Git Bash.
- A way to edit a text file. The simplest is `nano`: `nano menu.txt`, change
  the line, then **Ctrl + O**, **Enter** to save and **Ctrl + X** to quit.
  Do not use TextEdit or Word: they can save extra formatting.

## Start

```bash
cd ~/git-lab                    # wherever you cloned git-github-labs
cd git-github-labs/part1/G1-split-the-commit
bash setup.sh
cd ~/git-lab/part1/g1-a
```

**Start from:** one commit, `chore: starting file for drill G1`, plus three
unstaged changes in `menu.txt`. Check with `git log --oneline` and `git status`.

> **Wrong folder check.** Run `pwd` first. It must end in `git-lab/part1/g1-a`.
> If `git diff` shows nothing, or `git add -p` says `No changes.`, you are
> still in the labs folder. Run `cd ~/git-lab/part1/g1-a`. Never run this
> drill's `git add` or `git commit` inside the labs folder.

## How to read the diff

```text
--- a/menu.txt                     the old version is the "minus" side
+++ b/menu.txt                     the new version is the "plus" side
@@ -4,7 +4,7 @@ Corner Cafe menu  a new chunk (hunk) starts here
 Coffee ......... 3.50             starts with a space: unchanged
-Latte .......... 4.25             starts with -: removed (red on screen)
+Latte .......... 4.50             starts with +: added (green on screen)
```

A changed line shows twice: the old line with `-`, then the new one with `+`.
Book Chapter 3, "How to read a diff", explains every part.

## Do it

Write your answer to each **Guess** before you run the command. Getting a
guess wrong is fine. Finding out *why* it was wrong is the point.

1. **Look.** Run `git diff`.
   **Guess first:** how many separate chunks (lines starting `@@`) will it show?
   If the screen ends in `(END)` or `:`, press `q` to get your prompt back.

2. **Stage only the latte price.** Run `git add -p`. Git shows one chunk at a
   time and asks `Stage this hunk?`. Type `y` for the latte chunk and `n` for
   the others. (`q` quits, `?` lists every key.)

3. **Guess first:** what will `git diff --staged` show? And plain `git diff`?
   Run both and compare with your guess.

4. **Commit it** with a message that says what changed, such as
   `fix: raise latte price to 4.50`.

5. **Stage the iced tea line** with `git add -p`, answering `y` only for it.

6. **The manager calls back:** iced tea is 3.75, not 3.50. Open `menu.txt` and
   change the iced tea price to 3.75. Save.

7. **Guess first:** what will `git diff --staged` show now? Which price will
   go into the commit if you run `git commit` right now? Run
   `git diff --staged` and `git diff` to check.

8. **Make the commit match the file.** Stage the corrected iced tea line, check
   with `git diff --staged`, then commit with a clear message.

9. **Throw away the test line.** Only the DEBUG line should be left in
   `git diff`. Check that, then run `git restore menu.txt`.
   `git restore` deletes unstaged changes for good, so always look first.

10. **Check your work:**

    ```bash
    bash ~/git-lab/git-github-labs/part1/G1-split-the-commit/check.sh
    ```

    Use your own path to the labs folder. The checker looks at the result, not
    at which commands you typed.

## Done when

- [ ] There are exactly two new commits after the starting commit
- [ ] One commit holds only the latte price change
- [ ] The other holds only the iced tea line, at 3.75
- [ ] No commit contains the DEBUG line
- [ ] Each message says what changed (not `wip` or `update`)
- [ ] `git status` says `nothing to commit, working tree clean`
- [ ] `check.sh` prints `All checks passed`

## Hints

Read one hint at a time, and only when you are stuck.

<details><summary>Hint 1: git add -p shows the wrong chunk first</summary>

Chunks come in file order, top to bottom: latte, then the DEBUG line, then
iced tea. Answer `n` to skip a chunk. Nothing is lost.
</details>

<details><summary>Hint 2: step 7 surprised you</summary>

`git add` copies the file *as it is at that moment* into the staging area. Edit
the file afterwards and the staging area still holds the old copy. That is why
`git diff --staged` still shows 3.50 and `git diff` shows the change to 3.75.
Run `git add -p` again to stage the new version.
</details>

<details><summary>Hint 3: I committed the wrong thing</summary>

You have not pushed, so you can fix your **last** commit:

- Wrong content: fix the file, `git add -p` the right chunk, then
  `git commit --amend --no-edit`.
- Bad message: `git commit --amend -m "fix: a better message"`.
- It is a mess: start over (below). That is what practice repos are for.
</details>

## Start over

```bash
bash reset.sh       # asks you to type yes, then deletes ~/git-lab/part1/g1-a
bash setup.sh
```

## Next week: try it cold

Wait a few days, then run the same drill with a new file and new changes,
without reading this page or the solution:

```bash
bash setup.sh b     # a library's opening hours: hours.txt in ~/git-lab/part1/g1-b
bash check.sh b
bash reset.sh b
```

Variant b has a fix, a new holiday line with a typo to correct after staging,
and a DEBUG line. If you finish it without hints, you own this skill.

## At work

This is a daily habit. You fix a bug, notice a typo, and leave a `print` line
for testing, all in one file. `git add -p` lets you review your own diff before
anyone else does and ship only what you mean to. Small, single-purpose commits
are easier to review and safer to revert.

Stuck? `SOLUTION.md` has one complete answer. Try first.
