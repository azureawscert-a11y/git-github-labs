#!/usr/bin/env bash
# G1 check: tells you whether the ticket is done, and what to fix if not.
# It looks at the result, not at which commands you used.
# Run: bash check.sh   (or: bash check.sh b)
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

VARIANT="${1:-a}"
case "$VARIANT" in a|b) ;; *) fail "Unknown variant '$VARIANT'. Use a or b." ;; esac
DIR="$LAB_HOME/g1-$VARIANT"
[[ -d "$DIR/.git" ]] || fail "No drill repo at $DIR. Run: bash setup.sh $VARIANT"
cd "$DIR"
need_git

if [[ "$VARIANT" == a ]]; then
  FILE=menu.txt
  FIX="-Latte .......... 4.25|+Latte .......... 4.50|"
  FEAT="+Iced tea ....... 3.75|"
  OLD_FEAT="+Iced tea ....... 3.50|"
  FIX_WORDS="the latte price"; FEAT_WORDS="the iced tea line at 3.75"
else
  FILE=hours.txt
  FIX="-Saturday ....... 10 am to 5 pm|+Saturday ....... 10 am to 4 pm|"
  FEAT="+Civic Holiday|"
  OLD_FEAT="+Civic Holday|"
  FIX_WORDS="the Saturday hours"; FEAT_WORDS="the Civic Holiday line, spelled right"
fi

# changed lines of one commit, joined with |
changes() {
  git --no-pager show --format= --unified=0 "$1" -- . |
    grep -E '^[-+]' | grep -vE '^(\+\+\+|---) ' | tr '\n' '|' || true
}

printf 'Checking drill G1, variant %s, in %s\n\n' "$VARIANT" "$DIR"

branch="$(git symbolic-ref --short -q HEAD || echo DETACHED)"
if [[ "$branch" == main ]]; then pass "You are on main."
else nope "You are on main." "You are on '$branch'. Run: git switch main"; fi

root="$(git rev-list --max-parents=0 HEAD | tail -n 1)"
count="$(git rev-list --count "$root"..HEAD)"
if [[ "$count" == 2 ]]; then pass "Exactly two new commits after the starting commit."
else nope "Exactly two new commits after the starting commit." \
  "You have $count. Each change from the ticket gets its own commit. To start again: bash reset.sh $VARIANT && bash setup.sh $VARIANT"; fi

got_fix=0; got_feat=0
for c in $(git rev-list --reverse "$root"..HEAD); do
  subj="$(git log -1 --format=%s "$c")"
  ch="$(changes "$c")"
  other="$(git --no-pager show --format= --name-only "$c" | grep -vx "$FILE" || true)"
  if [[ -n "$other" ]]; then
    nope "Commit \"$subj\" only touches $FILE." "It also changes: $other"
  elif [[ "$ch" == "$FIX" ]]; then got_fix=1; pass "Commit \"$subj\" holds only $FIX_WORDS."
  elif [[ "$ch" == "$FEAT" ]]; then got_feat=1; pass "Commit \"$subj\" holds only $FEAT_WORDS."
  elif [[ "$ch" == *DEBUG* ]]; then
    nope "Commit \"$subj\" leaves the debug line out." \
      "The DEBUG line got committed. Not pushed yet, so if it is your last commit: delete the line, git add $FILE, git commit --amend --no-edit"
  elif [[ "$ch" == "$OLD_FEAT" ]]; then
    nope "Commit \"$subj\" holds the corrected line." \
      "It has the first version. You edited the file after staging but did not git add again. Edit, git add -p, then git commit --amend --no-edit"
  else
    nope "Commit \"$subj\" holds one change only." \
      "It holds: $(printf '%s' "$ch" | tr '|' ' '). Use git add -p and answer y only for the hunk you want."
  fi
  if (( ${#subj} < 10 )) || printf '%s' "$subj" | grep -qiE '^(wip|update|updates|changes|fix|stuff|misc|test)$'; then
    nope "Commit \"$subj\" has a message that says what changed." \
      "Not pushed yet, so if it is your last commit: git commit --amend -m \"fix: ...\" (Chapter 22 has the style)."
  fi
done
((got_fix)) || nope "One commit holds $FIX_WORDS." "Stage that hunk alone with git add -p, then commit."
((got_feat)) || nope "One commit holds $FEAT_WORDS." "Stage that hunk alone with git add -p, then commit."

if git --no-pager log -p --all | grep -q 'DEBUG'; then
  nope "No commit contains the debug line." "Look with: git log -p | grep -n DEBUG"
else pass "No commit contains the debug line."; fi

if [[ -z "$(git status --porcelain)" ]]; then pass "Working tree is clean."
else nope "Working tree is clean." "git status still shows changes. If only the DEBUG line is left: git restore $FILE"; fi

summary
