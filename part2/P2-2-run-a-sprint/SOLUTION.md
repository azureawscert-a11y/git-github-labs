# P2-2 solution

One way to finish the ticket. Replace `YOUR-USERNAME` with your GitHub username.
Work in `~/git-lab/part2/p2-2-tip-split`.

## 1. The issue form

`.github/ISSUE_TEMPLATE/bug.yml`

```yaml
name: Bug report
description: Something does not work as expected
title: "Bug: "
labels: ["bug"]
body:
  - type: textarea
    id: what-happened
    attributes:
      label: What happened
      description: What did you see, and what did you expect?
    validations:
      required: true
  - type: textarea
    id: steps
    attributes:
      label: Steps to reproduce
      placeholder: "python3 tip.py 100 3 15"
    validations:
      required: true
  - type: input
    id: version
    attributes:
      label: Python version
      placeholder: "3.12"
```

Commit it straight to `main` this once (the repo has no ruleset yet), then push:

```bash
git add .github/ISSUE_TEMPLATE/bug.yml
git commit -m "chore: add a bug report form"
git push
```

## 2. Five issues

File the three bugs on the web with **Issues > New issue > Bug report**, so you
see the form. Then label, plan and assign them:

```bash
gh issue edit 1 2 3 --add-label sprint-1 --add-assignee @me
gh issue create -t "Docs: say how to run the app" -b "The README has no usage line." -l documentation
gh issue create -t "Round each share up to the next dollar" -b "Optional flag, off by default." -l enhancement
```

## 3. The board

```bash
gh project create --owner "@me" --title "P2-2 Sprint"
N=$(gh project list --owner "@me" --format json \
  --jq '.projects[] | select(.title=="P2-2 Sprint") | .number')
gh project link "$N" --owner YOUR-USERNAME --repo YOUR-USERNAME/p2-2-tip-split
for url in $(gh issue list --json url --jq '.[].url'); do
  gh project item-add "$N" --owner "@me" --url "$url"
done
```

`gh project link` needs your username after `--owner`, not `@me`, and needs
`--repo`.

On the web, open the project: **New view > Board**. The new view is named
**View 2** and already groups by **Status**; rename it if you like. New items
start in **Todo**. Then **... > Workflows > Item closed**: check it is on and
sets Status to **Done**.

## 4. Three PRs

Do them one at a time and pull `main` between them, so they do not conflict.

**PR 1, fixes #1.** In `tip.py`:

```diff
-    with_tip = total + total * tip_percent
+    with_tip = total + total * tip_percent / 100
```

```bash
git switch -c fix/1-tip-percent
git commit -am "fix: treat the tip as a percentage" -m "Fixes #1"
git push -u origin fix/1-tip-percent
gh pr create --fill
gh pr merge --squash --delete-branch
git switch main && git pull
```

**PR 2, fixes #2.**

```diff
-    print("Each person pays:", per_person(total, people, tip))
+    print(f"Each person pays: {per_person(total, people, tip):.2f}")
```

Open it the same way with `Fixes #2` in the body. Before merging, go to
**Files changed**, click the line, start a review comment, press the
**suggestion** button and change the text, for example `Each person pays:` to
`Each person pays: $`. Submit the review as a comment, then click **Apply
suggestion** on the PR. The dialog shows a commit title (default "Update
tip.py"), a message and **Commit changes**. **Add suggestion to batch** collects
several suggestions into one commit. Pull before you merge: `git pull`.

**PR 3, fixes #3.**

```diff
     total, people, tip = float(sys.argv[1]), int(sys.argv[2]), float(sys.argv[3])
+    if people < 1:
+        sys.exit("People must be 1 or more.")
```

## 5. Watching

On the repo page: **Watch > Custom**. The checkboxes are Issues, Pull requests, Releases,
Discussions and Security alerts. Tick **Issues** and **Pull requests**,
**Apply**. After a reload the button reads **Unwatch** (any watch setting other than Participating shows Unwatch); open it and **Custom** has the tick.

## Check your work

Real output after the three fixes (without the suggested `$`):

```text
$ python3 tip.py 100 3 15
Each person pays: 38.33
$ python3 tip.py 100 0 15
People must be 1 or more.
$ python3 -m unittest
.
----------------------------------------------------------------------
Ran 1 test in 0.000s

OK
```

```bash
gh issue list --state closed        # 1, 2 and 3 closed by the PRs
gh pr list --state merged           # three merged PRs
```

On the board, the three bugs sit in **Done**, moved there by the Item closed workflow.
