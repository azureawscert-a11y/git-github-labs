# P2-4: Lock it down

Chapters 19 and 20. About 45 minutes.

## Before you start: a free practice organization

Teams, team code owners and organization repos need an organization. Create a
free one for practice: **Settings > Organizations > New organization**, choose
the **Free** plan, and give it a name such as `yourname-lab`. You are its owner.
Nothing here needs a paid plan, because the lab repo is public.

## The ticket

> **From:** the security lead
> **Repo:** `YOUR-ORG/p2-4-locked`
>
> Last week someone force-pushed to `main` and we lost a day of work. From now
> on: everyone uses 2FA, nobody pushes to `main` directly, the platform team
> reviews anything under `infra/`, and outside contributors come in through
> forks and pull requests.

## Start

```bash
bash setup.sh YOUR-ORG
cd ~/git-lab/part2/p2-4-locked
```

The setup script needs the `admin:org` scope to create the team:
`gh auth refresh -s admin:org`.

## Done when

- [ ] Your account has 2FA on with an authenticator app, and your recovery codes are saved offline
- [ ] A ruleset named `protect-main` is **Active** on the default branch, requires a pull request and blocks force pushes
- [ ] A direct `git push` to `main` was refused
- [ ] `.github/CODEOWNERS` makes you the default owner and `@YOUR-ORG/platform` the owner of `/infra/`, merged through a PR
- [ ] A PR that changes `infra/deploy.sh` shows the platform team as a requested reviewer
- [ ] You forked the repo to your personal account and opened one PR from the fork, which you then merged or closed
- [ ] `gh ruleset check main` lists the rules

## Hints

- 2FA lives in **Settings > Password and authentication**. GitHub Support cannot get you back in if you lose both the phone and the codes.
- Rulesets: **Settings > Rules > Rulesets > New ruleset > New branch ruleset** on the repo (Chapter 19).
- You cannot approve your own PR, so leave required approvals at 0 for this lab.
- Chapter 20 has the fork and PR loop.
- Stuck? `SOLUTION.md` has one complete answer. Try first.

## Start over

```bash
bash reset.sh YOUR-ORG
```

Deletes the org repo, the team and your fork. The organization stays; delete it
from its **Settings** page if you no longer want it. Needs the `delete_repo` and
`admin:org` scopes.
