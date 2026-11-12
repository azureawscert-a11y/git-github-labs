# P2-4 solution

One way to finish the ticket. Replace `YOUR-USERNAME` and `YOUR-ORG`.

## 1. 2FA

**Settings > Password and authentication > Enable two-factor authentication**.
Scan the QR code with an authenticator app, enter the code, and download the
recovery codes (`github-recovery-codes.txt`). Keep them offline, never in a
repo. Optionally add a passkey on the same page.

## 2. The ruleset

On `YOUR-ORG/p2-4-locked`: **Settings > Rules > Rulesets > New ruleset >
New branch ruleset**.

- Name: `protect-main`
- Enforcement status: **Active**
- Target branches: **Add target > Include default branch**
- Rules: **Restrict deletions** and **Block force pushes** are already ticked.
  Also tick **Require a pull request before merging** and leave required
  approvals at 0.
- Before you click **Create**, check that Enforcement status still says
  **Active** and the target is the default branch. Check again on the ruleset
  page afterwards.
- **Create**

```bash
gh ruleset list --repo YOUR-ORG/p2-4-locked
gh ruleset check main --repo YOUR-ORG/p2-4-locked
```

`gh ruleset` commands need `--repo`, or you must run them inside the repo folder.

## 3. Prove a direct push is refused

```bash
echo "direct" >> README.md
git commit -am "test: direct push to main"
git push                      # refused
git reset --hard HEAD~1       # throw the test commit away
```

The error starts with `GH013` and says "Changes must be made through a pull
request". It links to the repo's rules page; it does not name the ruleset.

## 4. CODEOWNERS, through a PR

`.github/CODEOWNERS`

```text
# Default owner for everything
*          @YOUR-USERNAME
# The platform team owns deploy scripts
/infra/    @YOUR-ORG/platform
```

```bash
git switch -c chore/codeowners
git add .github/CODEOWNERS
git commit -m "chore: add code owners"
git push -u origin chore/codeowners
gh pr create --fill
gh pr merge --squash --delete-branch
git switch main && git pull
```

The team needs write access to count as a code owner; the setup script gave it
write. Open the file on GitHub: errors in CODEOWNERS are highlighted there.

Now change `infra/deploy.sh` on a new branch and open a PR. The PR's
reviewers list shows `YOUR-ORG/platform`, even though you are the only member of
that team. With required approvals at 0, you can merge it without anyone
approving.

## 5. A PR from a fork

Your personal account plays the outside contributor.

```bash
mkdir -p ~/git-lab/part2/p2-4-fork && cd ~/git-lab/part2/p2-4-fork
gh repo fork YOUR-ORG/p2-4-locked --clone
cd p2-4-locked
git remote -v                 # origin = your fork, upstream = the org repo
git switch -c docs/runbook-step
echo "3. Check the app greets the team after deploy." >> docs/runbook.md
git commit -am "docs: add a check step to the runbook"
git push -u origin docs/runbook-step
gh pr create --repo YOUR-ORG/p2-4-locked --head YOUR-USERNAME:docs/runbook-step --fill
```

Leave **Allow edits from maintainers** on. This PR only touches `docs/`, which
you own by default, so it shows no requested reviewer. As the org owner you can
merge it, or close it if you prefer.

## Check your work

```bash
gh ruleset check main --repo YOUR-ORG/p2-4-locked   # three rules: deletion, non_fast_forward, pull_request
gh pr list --repo YOUR-ORG/p2-4-locked --state all
gh api orgs/YOUR-ORG/teams/platform/repos --jq '.[].full_name'
```

On your profile, **Settings > Password and authentication** shows
two-factor authentication as enabled.
