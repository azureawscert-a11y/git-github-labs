# G2: Your teammate pushed first

Book chapters: 4, 5 and 6. About 30 minutes. Git only: no GitHub account, no internet.

## The ticket

> **From:** the office manager
> **File:** `party.txt` in the team repo
>
> Two updates for the party plan, please:
>
> 1. The venue is now **The Harbour Room**.
> 2. Add a vegan option to the food.

Sounds simple. But your teammate Alex has been working on the same file, and
you do not know it yet.

## How this drill works

`setup.sh` makes three folders in `~/git-lab/part1/g2-a`:

| Folder | Plays the role of |
|---|---|
| `team.git` | GitHub: the shared copy everyone pushes to. Never edit it directly. |
| `you` | Your clone on your laptop. All your work happens here. |
| `alex` | Your teammate's clone on their laptop. |

The shared repo is a folder instead of GitHub, but `push`, `fetch` and `merge`
work exactly the same way.

## You need

- Git working in a terminal (Start Here). On Windows, use Git Bash.
- A text editor for one file, such as `nano`: `nano party.txt`, change the
  lines, then **Ctrl + O**, **Enter** to save and **Ctrl + X** to quit.

## Start

```bash
cd ~/git-lab/git-github-labs/part1/G2-teammate-conflict
bash setup.sh
cd ~/git-lab/part1/g2-a/you
```

**Start from:** run `pwd`. It must end in `g2-a/you`. If `git status` says
`not a git repository`, you are in the wrong folder.

## Do it

Write your answer to each **Guess** before you run the command.

1. **Look.** Run `git status`.
   **Guess first:** it says `Your branch is up to date with 'origin/main'`.
   Is your copy really the same as the shared repo?

2. **Do the ticket.** Open `party.txt`. Change the venue line to
   `Venue ....... The Harbour Room`, and change the food line to
   `Food ........ pizza, plus a vegan option`. Save, check with `git diff`,
   then commit:

   ```bash
   git add party.txt
git commit -m "docs: new venue and a vegan option"
   ```

3. **Share it.** **Guess first:** will `git push` work? Run it and read the
   message carefully.

4. **Find out what happened.**

   ```bash
   git fetch
   git status
   git log -p main..origin/main
   ```

   `git fetch` downloads new commits from the shared repo without changing
   your files. `main..origin/main` means "commits the shared repo has that my
   main does not". Press `q` if you see `(END)`.

5. **Guess first:** when you bring in Alex's commit, which line will
   conflict: the venue, the food, or both?

6. **Bring in Alex's work.**

   ```bash
   git merge origin/main
   ```

   Open `party.txt`. In a merge, the top half (`HEAD`) is yours and the
   bottom half is what came in, here Alex's commit. Make the food line keep
   **both** changes, delete the three marker lines, and save.

7. **Finish and share.**

   ```bash
   git add party.txt
   git commit -m "merge: keep Alex's salad and the vegan option"
   git push
   ```

8. **Be Alex for a moment.** Alex's laptop does not know about your work
   until Alex pulls:

   ```bash
   cd ../alex
   git pull
   cat party.txt
   cd ../you
   ```

9. **Check your work:**

   ```bash
   bash ~/git-lab/git-github-labs/part1/G2-teammate-conflict/check.sh
   ```

   Use your own path to the labs folder if it is different.

## Done when

- [ ] Alex's commit is still on the shared repo
- [ ] Your venue change is on the shared repo
- [ ] The food line keeps Alex's change **and** yours
- [ ] No conflict markers were committed
- [ ] `git status` is clean and your main matches the shared repo
- [ ] `check.sh` prints `All checks passed`

## Hints

Read one at a time, only when you are stuck.

<details><summary>Hint 1: step 1 lied to me</summary>

`git status` compares your branch with `origin/main`, which is your laptop's
memory of the shared repo from the last time you fetched. It never goes online
by itself. "Up to date" means "up to date with what I last saw".
</details>

<details><summary>Hint 2: the push was rejected</summary>

`rejected ... (fetch first)` means the shared repo has commits you do not
have. Git refuses so it never throws a teammate's work away. Do not reach for
`--force`: that is exactly what would delete Alex's commit.
</details>

<details><summary>Hint 3: why did only one line conflict?</summary>

Git merges line by line. You and Alex both changed the food line, so Git
cannot choose and asks you. Only you changed the venue line, so Git takes your
version by itself.
</details>

<details><summary>Hint 4: I committed the markers, or kept only one side</summary>

Nothing is lost. Fix `party.txt`, then `git add party.txt`,
`git commit -m "fix: keep both food changes"` and `git push`. A normal new
commit is the right fix here, because the merge is already on the shared repo.
</details>

## Why not just `git pull`?

`git pull` does steps 4 and 6 in one go: fetch, then merge. This drill splits
them so you see each step. If you set `pull.rebase true` in Chapter 2, `git pull`
rebases instead of merging, and the conflict sides swap: the top half becomes
Alex's and the bottom half yours (Chapter 7). Either way the result is the
same, and `check.sh` accepts both.

## Start over

```bash
bash reset.sh       # asks you to type yes, then deletes ~/git-lab/part1/g2-a
bash setup.sh
```

## Next week: try it cold

```bash
bash setup.sh b     # a study group schedule: schedule.txt in ~/git-lab/part1/g2-b/you
bash check.sh b
bash reset.sh b
```

The variant b ticket: change the topic line to
`Topic ....... Git branches and merges`, and add ` (projector)` to the end of
the room line. Alex has changed something too. Do it without this page.

## At work

This happens many times a week. Someone merges to main while you are working,
and your push is rejected. The habit is always the same: fetch, look at what
changed, merge (or rebase), test, push. Never force push a shared branch: on a
real team, `--force` here deletes a colleague's work, and they find out the
hard way.

Stuck? `SOLUTION.md` has one complete answer. Try first.
