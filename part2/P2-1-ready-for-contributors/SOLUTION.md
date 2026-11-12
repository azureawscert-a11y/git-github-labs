# P2-1 solution

One way to finish the ticket. Your wording will differ, and that is fine.
Replace `YOUR-USERNAME` with your GitHub username.

## 1. Files

From `~/git-lab/part2/p2-1-pocket-budget`, on a branch:

```bash
git switch -c docs/contributor-ready
```

`README.md`

````markdown
# pocket-budget

Add up what you spent this month, by category, from a CSV file.

## Run it

```bash
python3 budget.py sample.csv
```

## Test it

```bash
python3 -m unittest
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Report security problems as described in [SECURITY.md](SECURITY.md).
````

`CONTRIBUTING.md`

```markdown
# Contributing

1. Open an issue first for anything bigger than a typo, so we can agree on the change.
2. Create a branch from `main`, for example `fix/12-rounding`.
3. Keep the change small and add or update a test.
4. Run `python3 -m unittest` and make sure it passes.
5. Open a pull request that says `Fixes #12` and explains why.
```

`SECURITY.md`

```markdown
# Security policy

Please do not open a public issue for a security problem.
Use **Security and quality > Report a vulnerability** on this repo, or email
the maintainer listed on the profile. We reply within a week.
```

`.github/CODEOWNERS`

```text
# Every change is reviewed by the maintainer
*    @YOUR-USERNAME
```

`LICENSE`: the easiest way is the web. **Add file > Create new file**, type
`LICENSE`, click **Choose a license template**. That opens a separate page: pick
MIT, enter Year and Full name, **Review and submit**, and commit to a branch.
If the commit box lists only your real email address, turn on **Keep my email
addresses private** first (see the README). Or copy the MIT text from
choosealicense.com into the file.

Commit, push and merge with a PR (Chapter 13):

```bash
git add README.md CONTRIBUTING.md SECURITY.md .github/CODEOWNERS
git commit -m "docs: make the repo ready for contributors"
git push -u origin docs/contributor-ready
gh pr create --title "docs: make the repo ready for contributors" \
  --body "Adds README, CONTRIBUTING, SECURITY and CODEOWNERS."
gh pr merge --squash --delete-branch
git switch main && git pull
```

With two commits, `gh pr create --fill` would title the PR from the branch name,
so this uses an explicit title.

If you added LICENSE on the web, merge that too, then `git pull`.

## 2. Vulnerability reporting, description, topics, template

Private vulnerability reporting is off on a new repo, so the "Report a
vulnerability" button in SECURITY.md does not exist yet. Turn it on:

```bash
gh api -X PUT repos/YOUR-USERNAME/p2-1-pocket-budget/private-vulnerability-reporting
```

You can also turn it on in the repo's **Settings**, in the security section.

```bash
gh repo edit --description "Add up monthly spending by category from a CSV" \
  --add-topic python --add-topic budgeting --add-topic cli
gh repo edit --template
```

## 3. A repo from the template

```bash
gh repo create p2-1-from-template --public --template YOUR-USERNAME/p2-1-pocket-budget
```

The new repo starts with one commit and has no link back (Chapter 10).

## Check your work

```bash
gh repo view --json description,repositoryTopics,isTemplate,licenseInfo
gh api repos/YOUR-USERNAME/p2-1-pocket-budget/private-vulnerability-reporting --jq .enabled
gh api repos/YOUR-USERNAME/p2-1-pocket-budget/community/profile --jq '.health_percentage'
gh repo view YOUR-USERNAME/p2-1-from-template --json templateRepository
```

On the web, **Insights > Community Standards** should tick README, LICENSE,
CONTRIBUTING and Security policy. Code of conduct and issue templates stay
unticked; P2-2 adds an issue form.
