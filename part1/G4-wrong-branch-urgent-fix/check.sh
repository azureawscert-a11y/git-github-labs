#!/usr/bin/env bash
# G4 check: looks at the shared repo and your clone, and tells you what to fix.
# It checks the result, not which commands you used.
# Run: bash check.sh   (or: bash check.sh b)
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

VARIANT="${1:-a}"
case "$VARIANT" in a|b) ;; *) fail "Unknown variant '$VARIANT'. Use a or b." ;; esac
DIR="$LAB_HOME/g4-$VARIANT"
[[ -d "$DIR/you/.git" ]] || fail "No drill at $DIR. Run: bash setup.sh $VARIANT"
need_git
cd "$DIR/you"

if [[ "$VARIANT" == a ]]; then
  DATA=prices.txt; WORK=checkout.txt; LOST=experiment/banner; FEAT=feature/gift-wrap
  BAD="Mug .......... 129.00"; GOOD="Mug .......... 12.90"
  M1="feat: add gift wrap option"; M2="feat: no gift wrap for mugs"; ML="feat: add holiday banner"
  WIPLINE="Add a gift message of up to 200 characters."
else
  DATA=oncall.md; WORK=runbook.md; LOST=experiment/status-page; FEAT=feature/db-runbook
  BAD="Escalation phone: 555-9999"; GOOD="Escalation phone: 555-0100"
  M1="docs: add slow database steps"; M2="docs: replica restart needs approval"; ML="docs: draft status page"
  WIPLINE="Post an update in #incidents every 30 minutes."
fi

printf 'Checking drill G4, variant %s, in %s\n\n' "$VARIANT" "$DIR"
git fetch -q origin

if [[ -e .git/MERGE_HEAD || -d .git/rebase-merge || -d .git/rebase-apply || -e .git/CHERRY_PICK_HEAD ]]; then
  nope "Nothing is half-finished." "git status says what is in progress and how to finish or abort it."
fi

root="$(git rev-list --max-parents=0 origin/main | tail -n 1)"
shared_new="$(git rev-list --count "$root"..origin/main)"
if git log origin/main --format=%s | grep -qxF -e "$M1" -e "$M2"; then
  nope "The feature commits are not on the shared main." "They were pushed to main. Start again: bash reset.sh $VARIANT && bash setup.sh $VARIANT. Move them to a branch before you push."
else pass "The feature commits are not on the shared main."; fi

shared="$(git show "origin/main:$DATA")"
if printf '%s\n' "$shared" | grep -qxF "$GOOD" && ! printf '%s\n' "$shared" | grep -qxF "$BAD"; then pass "The urgent fix is on the shared main."
else nope "The urgent fix is on the shared main." "In $DATA the line must read: $GOOD. Fix it on main, commit, git push."; fi

if [[ "$shared_new" == 1 ]] && [[ "$(git diff --name-only "$root" origin/main)" == "$DATA" ]]; then pass "The shared main got exactly one new commit, touching only $DATA."
else nope "The shared main got exactly one new commit, touching only $DATA." "It has $shared_new new commit(s), changing: $(git diff --name-only "$root" origin/main | tr '\n' ' '). The hotfix should be one small commit."; fi

if git show "origin/main:$WORK" | grep -qxF "$WIPLINE"; then
  nope "Your unfinished work did not reach main." "The half-done line was pushed with the hotfix. git stash before you fix, so only the fix goes out."
else pass "Your unfinished work did not reach main."; fi

if [[ "$(git rev-parse main)" == "$(git rev-parse origin/main)" ]]; then pass "Your main matches the shared main."
else nope "Your main matches the shared main." "Your main has $(git rev-list --count origin/main..main) commit(s) the shared repo does not, and lacks $(git rev-list --count main..origin/main). On main: git reset --hard origin/main (after the feature commits are safe on their branch)."; fi

if git rev-parse -q --verify "$FEAT" >/dev/null; then
  if git log "$FEAT" --format=%s | grep -qxF "$M1" && git log "$FEAT" --format=%s | grep -qxF "$M2"; then pass "Branch $FEAT has both feature commits."
  else nope "Branch $FEAT has both feature commits." "It is missing one. git reflog shows where main was before you reset it; git branch -f $FEAT <that hash> fixes the label."; fi
else nope "Branch $FEAT exists." "Make it on the commit that has your two feature commits: git branch $FEAT <hash>. git reflog shows the hash if main has already moved."; fi

br="$(git symbolic-ref --short -q HEAD || echo DETACHED)"
if [[ "$br" == "$FEAT" ]]; then pass "You are back on $FEAT."
else nope "You are back on $FEAT." "You are on '$br'. Run: git switch $FEAT"; fi

if grep -qxF "$WIPLINE" "$WORK" 2>/dev/null; then pass "Your unfinished line is back in $WORK."
else nope "Your unfinished line is back in $WORK." "If git stash list shows it, run git stash pop on $FEAT. If the stash is empty, git reset --hard deleted it before you stashed: work that was never committed or stashed cannot be recovered. Start again and stash first."; fi

if [[ -z "$(git stash list)" ]]; then pass "The stash is empty."
else nope "The stash is empty." "Something is still parked. If your line is already back, git stash drop removes the old copy; if not, git stash pop."; fi

if git rev-parse -q --verify "$LOST" >/dev/null && [[ "$(git log -1 --format=%s "$LOST")" == "$ML" ]]; then pass "Yesterday's branch $LOST is back."
else nope "Yesterday's branch $LOST is back." "git reflog lists every commit HEAD was on. Find \"$ML\", then: git branch $LOST <hash>"; fi

summary
