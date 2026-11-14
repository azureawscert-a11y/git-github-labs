#!/usr/bin/env bash
# G2 setup: a shared repo that plays GitHub, your clone, and a teammate's clone.
# The teammate has already pushed a change you do not know about.
# Run: bash setup.sh   (or: bash setup.sh b)
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

VARIANT="${1:-a}"
case "$VARIANT" in a|b) ;; *) fail "Unknown variant '$VARIANT'. Use a or b." ;; esac

need_git
DIR="$LAB_HOME/g2-$VARIANT"
[[ -e "$DIR" ]] && fail "$DIR already exists. Run: bash reset.sh $VARIANT"

alex() { git -c user.name="Alex (teammate)" -c user.email="alex@example.com" "$@"; }

if [[ "$VARIANT" == a ]]; then
FILE=party.txt
write_start() { cat > "$FILE" <<'TXT'
Team party plan
===============

Date ........ Friday 12 December
Venue ....... The Lakeview Room
Start ....... 5 pm

Food ........ pizza
Drinks ...... juice and pop
Music ....... playlist by Priya

Budget ...... 300 dollars
Contact ..... the office manager
TXT
}
ALEX_FROM='Food ........ pizza'
ALEX_TO='Food ........ pizza and salad'
ALEX_MSG='docs: add salad to the food'
else
FILE=schedule.txt
write_start() { cat > "$FILE" <<'TXT'
Study group: Cloud basics
=========================

Day ......... Tuesday
Time ........ 6 pm to 8 pm
Room ........ 204, Building B

Bring ....... laptop and charger
Host ........ Sam
Chat ........ #study-group

Topic ....... Git and GitHub
Next week ... Azure basics
TXT
}
ALEX_FROM='Room ........ 204, Building B'
ALEX_TO='Room ........ 310, Building B'
ALEX_MSG='docs: move to room 310'
fi

mkdir -p "$DIR"
cd "$DIR"

# 1. The shared repo. On a real team this lives on GitHub.
git init -q --bare -b main team.git

# 2. Alex starts the project and pushes it.
alex clone -q team.git alex 2>/dev/null
( cd alex
  git symbolic-ref HEAD refs/heads/main
  write_start
  alex add "$FILE"
  alex commit -q -m "docs: first version of $FILE"
  alex push -q -u origin main )

# 3. You clone the project, as you would on your first day.
git clone -q team.git you

# 4. Later, Alex changes one line and pushes. You have not fetched since.
( cd alex
  # replace one whole line, portable on macOS, Linux and Git Bash
  while IFS= read -r line; do
    if [[ "$line" == "$ALEX_FROM" ]]; then printf '%s\n' "$ALEX_TO"; else printf '%s\n' "$line"; fi
  done < "$FILE" > "$FILE.new" && mv "$FILE.new" "$FILE"
  alex commit -q -am "$ALEX_MSG"
  alex push -q )

say "Ready. Three folders in $DIR:"
echo "    team.git   the shared repo. It plays the role of GitHub. Never edit it."
echo "    you        your clone. All your work happens here."
echo "    alex       your teammate's clone."
echo
echo "IMPORTANT: you are still in the labs folder. Before any git command, run:"
echo
echo "    cd $DIR/you"
echo
echo "Then check: pwd must end in g2-$VARIANT/you. Now follow TICKET.md, variant $VARIANT."
