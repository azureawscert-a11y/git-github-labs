# G3: Clean up before review

Book chapter: 7. About 30 minutes. Git only: no GitHub account, no internet.

## The ticket

> **From:** your tech lead
> **Branch:** `feature/faq`
>
> Before I review your FAQ branch: it has five commits called things like
> `wip` and `typo`, and main has moved on since you started. Please make it
> **two clean commits** on top of the **latest main**, and push it again:
>
> 1. `docs: add FAQ with returns and shipping`
> 2. `docs: add payment question`
>
> Keep every bit of the work, including the typo fixes.

## How this drill works

`setup.sh` makes three folders in `~/git-lab/part1/g3-a`:

| Folder | Plays the role of |
|---|---|
| `team.git` | GitHub: the shared copy everyone pushes to. Never edit it directly. |
| `you` | Your clone, already on branch `feature/faq`, which you pushed earlier. |
| `alex` | Your teammate's clone. Alex has since merged a change to main. |

## You need

- Git working in a terminal (Start Here). On Windows, use Git Bash.
- An editor Git can open. `git rebase -i` opens the editor you set in
  Chapter 2. Check with `git config --global core.editor`. If it prints
  nothing, Git opens Vim, which is hard for beginners: run
  `git config --global core.editor nano` first.
- In nano: change the text, then **Ctrl + O**, **Enter** to save and
  **Ctrl + X** to close. Git carries on as soon as you close the editor.

## Start

```bash
cd ~/git-lab/git-github-labs/part1/G3-clean-up-before-review
bash setup.sh
cd ~/git-lab/part1/g3-a/you
```

**Start from:** `pwd` ends in `g3-a/you`, and `git status` says
`On branch feature/faq`.

## Do it

Write your answer to each **Guess** before you run the command.

1. **Look.** Run `git log --oneline --graph --all`. You see your five messy
   commits on top of the first commit.
   **Guess first:** does it show Alex's new commit on main?

2. **Catch up.** Run `git fetch`, then `git log --oneline --graph --all`
   again. Now the history forks: Alex's commit on one side, your five on
   the other.

3. **Make a safety net.** Before you rewrite anything:

   ```bash
   git branch backup-faq
   ```

   This is a second label on your current commit. If the cleanup goes wrong,
   `git reset --hard backup-faq` puts everything back.

4. **Start the cleanup.**

   ```bash
   git rebase -i origin/main
   ```

   This does two jobs at once: it moves your branch on top of the latest
   main, and it lets you tidy your commits on the way. Your editor opens
   with one line per commit.
   **Guess first:** is the oldest commit at the top or the bottom?

5. **Edit the list.** Change the first word of each line. Leave the rest of
   each line alone:

   ```text
   reword e33e4f9 add faq heading
   fixup acbc1c6 wip
   fixup d9e2b7a typo
   reword 2545b1f more
   fixup 5280ce2 typo again
   ```

   Your hashes will be different. The words mean:

   | Word | What happens to that commit |
   |---|---|
   | `pick` | Keep it as it is. |
   | `reword` | Keep it, and let me change its message. |
   | `fixup` | Melt it into the commit above and throw its message away. |
   | `squash` | Melt it into the commit above and combine the messages. |
   | `drop` | Delete it, work and all. Not for this ticket. |

   Save and close. Git replays the commits. Each `reword` opens the editor
   again with the old message: replace it with the message from the ticket,
   save and close.

6. **Check nothing was lost.**

   ```bash
   git log --oneline --graph --all
   git diff backup-faq
   ```

   **Guess first:** what will `git diff backup-faq` show? Your branch now
   has two commits instead of five. If no work was lost, the only difference
   from the backup is the line Alex changed on main.

7. **Push.** **Guess first:** will a plain `git push` work this time? Run it
   and read the message.

8. **Push safely.** You rewrote your branch, so GitHub's copy and yours no
   longer line up. Replace it, but safely (Chapter 7):

   ```bash
   git push --force-with-lease --force-if-includes
   ```

9. **Check your work:**

   ```bash
   bash ~/git-lab/git-github-labs/part1/G3-clean-up-before-review/check.sh
   ```

   When it passes, delete the safety net: `git branch -D backup-faq`.

## Done when

- [ ] The branch on the shared repo starts from the latest main
- [ ] It has exactly two commits, with the messages from the ticket
- [ ] Commit 1 holds the returns and shipping questions, commit 2 the payment question
- [ ] No typos are left, and no work is missing
- [ ] main on the shared repo still has Alex's commit
- [ ] `check.sh` prints `All checks passed`

## Hints

<details><summary>Hint 1: the oldest commit is at the top?</summary>

Yes. `git log` shows newest first, but the rebase list is a to-do list: Git
replays it from the top down, oldest first. That is why `fixup` melts a commit
into the one *above* it.
</details>

<details><summary>Hint 2: the push was rejected again</summary>

`rejected ... (non-fast-forward)` is expected after a rebase. The shared repo
still has your five old commits, and yours are new commits with new hashes.
**Do not run `git pull` here**: it would merge the five old commits back in.
Use the push in step 8.
</details>

<details><summary>Hint 3: I ran git pull anyway</summary>

The pull made a merge commit. If it is your last commit, `git reset --hard HEAD~1`
removes it. Then do step 8.
</details>

<details><summary>Hint 4: it went wrong in the middle</summary>

During the rebase, `git rebase --abort` puts everything back to before step 4.
After it has finished, `git reset --hard backup-faq` does the same. Then start
again from step 4.
</details>

## Start over

```bash
bash reset.sh       # asks you to type yes, then deletes ~/git-lab/part1/g3-a
bash setup.sh
```

## Next week: try it cold

```bash
bash setup.sh b     # a new-starter guide on branch feature/setup-guide
bash check.sh b
bash reset.sh b
```

The variant b ticket: two clean commits on the latest main,
`docs: add first-day setup steps` and `docs: add working from home section`,
with every typo fix kept. Do it without this page.

## At work

Teams review the commits you push, and many merge them as they are. Ten
`wip` commits make a branch hard to review and hard to undo later. Tidying with
`git rebase -i` before you ask for review is normal and expected, **on your own
branch**. Never rewrite a branch other people have built on, and never force
push main.

Stuck? `SOLUTION.md` has one complete answer. Try first.
