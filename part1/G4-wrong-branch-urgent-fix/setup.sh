#!/usr/bin/env bash
# G4 setup: you committed feature work on main by mistake, you have unsaved
# changes, yesterday you deleted a branch you still need, and an urgent bug
# just came in. Run: bash setup.sh   (or: bash setup.sh b)
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

VARIANT="${1:-a}"
case "$VARIANT" in a|b) ;; *) fail "Unknown variant '$VARIANT'. Use a or b." ;; esac

need_git
DIR="$LAB_HOME/g4-$VARIANT"
[[ -e "$DIR" ]] && fail "$DIR already exists. Run: bash reset.sh $VARIANT"

if [[ "$VARIANT" == a ]]; then
  DATA=prices.txt; WORK=checkout.txt; LOST=experiment/banner
  data()  { printf '%s\n' "Corner Shop prices" "" "Notebook ..... 4.99" "Pen .......... 1.49" "Mug .......... 129.00" "Tote bag ..... 12.00"; }
  work()  { printf '%s\n' "Checkout steps" "" "1. Review your cart" "2. Enter your address" "3. Pay"; }
  feat1() { printf '%s\n' "" "Gift wrap" "Add gift wrap for 3.00 per item." >> "$WORK"; }
  feat2() { printf '%s\n' "Gift wrap is not available for mugs." >> "$WORK"; }
  wip()   { printf '%s\n' "Add a gift message of up to 200 characters." >> "$WORK"; }
  lost()  { printf '%s\n' "Holiday banner: free shipping over 50 dollars." > banner.txt; }
  M1="feat: add gift wrap option"; M2="feat: no gift wrap for mugs"; ML="feat: add holiday banner"
else
  DATA=oncall.md; WORK=runbook.md; LOST=experiment/status-page
  data()  { printf '%s\n' "# On call" "" "Primary phone: 555-0142" "Backup phone: 555-0199" "Escalation phone: 555-9999" "Hours: 24/7"; }
  work()  { printf '%s\n' "# Runbook: site is down" "" "1. Check the status page" "2. Check the last deploy" "3. Roll back if needed"; }
  feat1() { printf '%s\n' "" "## Database is slow" "Check the slow query log first." >> "$WORK"; }
  feat2() { printf '%s\n' "Restart the read replica only with approval." >> "$WORK"; }
  wip()   { printf '%s\n' "Post an update in #incidents every 30 minutes." >> "$WORK"; }
  lost()  { printf '%s\n' "Status page draft: all systems normal." > status.md; }
  M1="docs: add slow database steps"; M2="docs: replica restart needs approval"; ML="docs: draft status page"
fi

mkdir -p "$DIR"
cd "$DIR"
git init -q --bare -b main team.git
git clone -q team.git you 2>/dev/null
cd you
git symbolic-ref HEAD refs/heads/main
data > "$DATA"; work > "$WORK"
git add "$DATA" "$WORK"
git commit -q -m "chore: first version"
git push -q -u origin main 2>/dev/null

# Yesterday: you tried an idea on a branch, then deleted the branch by mistake.
git switch -q -c "$LOST"
lost; git add .; git commit -q -m "$ML"
git switch -q main
git branch -q -D "$LOST"

# Today: you forgot to make a branch and committed the feature on main.
feat1; git commit -q -am "$M1"
feat2; git commit -q -am "$M2"
# ...and you are halfway through the next change, not committed.
wip

say "Ready. Two folders in $DIR:"
echo "    team.git   the shared repo. It plays the role of GitHub. Never edit it."
echo "    you        your clone. All your work happens here."
echo
echo "IMPORTANT: you are still in the labs folder. Before any git command, run:"
echo
echo "    cd $DIR/you"
echo
echo "Then check: pwd must end in g4-$VARIANT/you. Now follow TICKET.md, variant $VARIANT."
