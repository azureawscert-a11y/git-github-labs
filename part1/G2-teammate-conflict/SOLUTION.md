# G2 solution

One way to finish the ticket. Work in `~/git-lab/part1/g2-a/you`.

## 1. Look

```bash
git status
```

```text
On branch main
Your branch is up to date with 'origin/main'.
```

**Answer to the guess:** no. Alex pushed after you cloned. `git status` only
knows what you last fetched, and you have not fetched since you cloned.

## 2. Do the ticket

Edit `party.txt` so these two lines read:

```text
Venue ....... The Harbour Room
Food ........ pizza, plus a vegan option
```

```bash
git diff
git add party.txt
git commit -m "docs: new venue and a vegan option"
```

## 3. Push

```bash
git push
```

```text
 ! [rejected]        main -> main (fetch first)
hint: Updates were rejected because the remote contains work that you do not
hint: have locally.
```

**Answer to the guess:** no. The shared repo has a commit you do not have, so
Git refuses rather than overwrite it.

## 4. Find out what happened

```bash
git fetch
git status
```

```text
Your branch and 'origin/main' have diverged,
and have 1 and 1 different commits each, respectively.
```

You have one commit Alex does not, and Alex has one you do not.

```bash
git log -p main..origin/main
```

It shows Alex's commit, `docs: add salad to the food`, changing
`Food ........ pizza` to `Food ........ pizza and salad`.

## 5 and 6. Merge

**Answer to the guess:** only the food line. Both of you changed it. Only you
changed the venue, so Git takes yours without asking.

```bash
git merge origin/main
```

```text
CONFLICT (content): Merge conflict in party.txt
Automatic merge failed; fix conflicts and then commit the result.
```

`party.txt` now contains:

```text
<<<<<<< HEAD
Food ........ pizza, plus a vegan option
=======
Food ........ pizza and salad
>>>>>>> origin/main
```

Replace those five lines with one line that keeps both changes:

```text
Food ........ pizza and salad, plus a vegan option
```

## 7. Finish and share

```bash
git add party.txt
git commit -m "merge: keep Alex's salad and the vegan option"
git push
```

## 8. Alex pulls

```bash
cd ../alex
git pull
cat party.txt
cd ../you
```

Alex now has `The Harbour Room` and `pizza and salad, plus a vegan option`.

## 9. Check

```text
  PASS  You are on main.
  PASS  Alex's commit is still on the shared repo.
  PASS  Your work is on the shared repo.
  PASS  The shared file has no conflict markers.
  PASS  On the shared repo, the venue is The Harbour Room.
  PASS  On the shared repo, the Food line keeps Alex's salad and your vegan option.
  PASS  Your working tree is clean.
  PASS  Your main matches the shared repo.

All checks passed. Ticket done.
```

## If you made a mistake

- **Pushed with `--force`:** Alex's commit is gone from the shared repo. On a
  real team you would now have to ask Alex to push it again. Here, run
  `bash reset.sh` and `bash setup.sh` and do it the safe way.
- **Committed the markers, or kept only one side:** fix the file, then
  `git add party.txt`, `git commit -m "fix: keep both food changes"` and
  `git push`. Do not amend: the merge is already shared.
- **Lost in the middle of the merge:** `git merge --abort` takes you back to
  just before step 6. Your commit from step 2 is safe.

## Variant b

Same steps with `schedule.txt`. Your ticket changes the topic line and adds
` (projector)` to the room line. Alex moved the meeting to room 310. Only the
room line conflicts. Keep both:

```text
Room ........ 310, Building B (projector)
```
