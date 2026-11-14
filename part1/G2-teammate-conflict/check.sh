#!/usr/bin/env bash
# G2 check: looks at the shared repo and your clone, and tells you what to fix.
# It checks the result, not which commands you used.
# Run: bash check.sh   (or: bash check.sh b)
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

VARIANT="${1:-a}"
case "$VARIANT" in a|b) ;; *) fail "Unknown variant '$VARIANT'. Use a or b." ;; esac
DIR="$LAB_HOME/g2-$VARIANT"
[[ -d "$DIR/you/.git" ]] || fail "No drill at $DIR. Run: bash setup.sh $VARIANT"
need_git
cd "$DIR/you"

if [[ "$VARIANT" == a ]]; then
  FILE=party.txt
  MINE_KEY='Venue';  MINE_WANT='Harbour Room';  MINE_WORDS="the venue is The Harbour Room"
  BOTH_KEY='Food';   BOTH_A='salad';  BOTH_B='vegan'
  BOTH_WORDS="the Food line keeps Alex's salad and your vegan option"
  ALEX_MSG='docs: add salad to the food'
else
  FILE=schedule.txt
  MINE_KEY='Topic';  MINE_WANT='branches';  MINE_WORDS="the topic mentions branches"
  BOTH_KEY='Room';   BOTH_A='310';    BOTH_B='projector'
  BOTH_WORDS="the Room line keeps Alex's room 310 and your projector note"
  ALEX_MSG='docs: move to room 310'
fi

printf 'Checking drill G2, variant %s, in %s\n\n' "$VARIANT" "$DIR"
git fetch -q origin

branch="$(git symbolic-ref --short -q HEAD || echo DETACHED)"
if [[ "$branch" == main ]]; then pass "You are on main."
else nope "You are on main." "You are on '$branch'. If a merge or rebase is still going, git status says so. Otherwise: git switch main"; fi

if [[ -e .git/MERGE_HEAD || -d .git/rebase-merge || -d .git/rebase-apply ]]; then
  nope "No merge or rebase is half-finished." "git status shows what is left. Fix the file, git add it, then git commit (merge) or git rebase --continue."
fi

alex_commit="$(git log origin/main --format='%H' --author='alex@example.com' --grep="^$ALEX_MSG\$" | head -n 1)"
if [[ -n "$alex_commit" ]]; then pass "Alex's commit is still on the shared repo."
else nope "Alex's commit is still on the shared repo." \
  "It is gone. That is what git push --force does to a teammate's work. Start again (bash reset.sh $VARIANT, bash setup.sh $VARIANT), and this time fetch and merge before you push."; fi

mine="$(git log origin/main --format='%ae' | grep -vc '^alex@example.com$' || true)"
if (( mine >= 1 )); then pass "Your work is on the shared repo."
else nope "Your work is on the shared repo." "Nothing of yours reached it yet. Finish the merge, then git push."; fi

shared="$(git show "origin/main:$FILE" 2>/dev/null || true)"
if printf '%s\n' "$shared" | grep -qE '^(<<<<<<<( |$)|=======$|>>>>>>>( |$))'; then
  nope "The shared file has no conflict markers." "Markers were committed. Delete the <<<<<<<, ======= and >>>>>>> lines, then git add $FILE, git commit and git push."
else pass "The shared file has no conflict markers."; fi

mline="$(printf '%s\n' "$shared" | grep "^$MINE_KEY " || true)"
if printf '%s' "$mline" | grep -qi "$MINE_WANT"; then pass "On the shared repo, $MINE_WORDS."
else nope "On the shared repo, $MINE_WORDS." "It says: ${mline:-nothing}. Edit $FILE, commit and push."; fi

bline="$(printf '%s\n' "$shared" | grep "^$BOTH_KEY " || true)"
has_a=0; has_b=0
printf '%s' "$bline" | grep -qi "$BOTH_A" && has_a=1
printf '%s' "$bline" | grep -qi "$BOTH_B" && has_b=1
if ((has_a && has_b)); then pass "On the shared repo, $BOTH_WORDS."
elif ((has_b)); then nope "On the shared repo, $BOTH_WORDS." "It says: $bline. You kept only your side and dropped Alex's change. Edit the line to keep both, then commit and push."
elif ((has_a)); then nope "On the shared repo, $BOTH_WORDS." "It says: $bline. You kept only Alex's side and lost your own change. Edit the line to keep both, then commit and push."
else nope "On the shared repo, $BOTH_WORDS." "It says: ${bline:-nothing}. Edit the line to keep both changes, then commit and push."; fi

if [[ -z "$(git status --porcelain)" ]]; then pass "Your working tree is clean."
else nope "Your working tree is clean." "git status still shows changes. Commit them, or look at what is left."; fi

ahead="$(git rev-list --count origin/main..HEAD)"; behind="$(git rev-list --count HEAD..origin/main)"
if [[ "$ahead" == 0 && "$behind" == 0 ]]; then pass "Your main matches the shared repo."
elif [[ "$ahead" != 0 ]]; then nope "Your main matches the shared repo." "You have $ahead commit(s) the shared repo does not. Run: git push"
else nope "Your main matches the shared repo." "The shared repo has $behind commit(s) you do not. Run: git pull"; fi

summary
