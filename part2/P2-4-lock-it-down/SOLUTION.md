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
- Rules: tick **Require a pull request before merging** (required approvals 0)
  and **Block force pushes**. Tick **Restrict deletions** too.
- **Create**

```bash
gh ruleset list
gh ruleset check main
```

## 3. Prove a direct push is refused

```bash
echo "direct" >> README.md
git commit -am "test: direct push to main"
git push                      # refused: GitHub names the ruleset
git reset --hard HEAD~1       # throw the test commit away
```

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
reviewers list shows `YOUR-ORG/platform`. Merge it.

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

Leave **Allow edits from maintainers** on. As the org owner you can merge it,
or close it if you prefer.

## Check your work

```bash
gh ruleset check main --repo YOUR-ORG/p2-4-locked
gh pr list --repo YOUR-ORG/p2-4-locked --state all
gh api orgs/YOUR-ORG/teams/platform/repos --jq '.[].full_name'
```

On your profile, **Settings > Password and authentication** shows
two-factor authentication as enabled.
