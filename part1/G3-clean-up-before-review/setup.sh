#!/usr/bin/env bash
# G3 setup: a shared repo that plays GitHub, and your clone with a pushed
# feature branch full of messy commits. Meanwhile a teammate moved main on.
# Run: bash setup.sh   (or: bash setup.sh b)
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

VARIANT="${1:-a}"
case "$VARIANT" in a|b) ;; *) fail "Unknown variant '$VARIANT'. Use a or b." ;; esac

need_git
DIR="$LAB_HOME/g3-$VARIANT"
[[ -e "$DIR" ]] && fail "$DIR already exists. Run: bash reset.sh $VARIANT"

alex() { git -c user.name="Alex (teammate)" -c user.email="alex@example.com" "$@"; }
# replace_line FILE OLD NEW: swap one whole line, portable on macOS, Linux and Git Bash
replace_line() {
  local f="$1" old="$2" new="$3" line
  while IFS= read -r line; do
    if [[ "$line" == "$old" ]]; then printf '%s\n' "$new"; else printf '%s\n' "$line"; fi
  done < "$f" > "$f.new" && mv "$f.new" "$f"
}
# replace_text FILE OLD NEW: swap a word inside lines
replace_text() {
  sed "s/$2/$3/g" "$1" > "$1.new" && mv "$1.new" "$1"
}

if [[ "$VARIANT" == a ]]; then
  FILE=help.md; BRANCH=feature/faq
  base() { printf '%s\n' "# Corner Shop help" "" "Welcome to the Corner Shop help page." "" "## Contact" "" "Email help@cornershop.example or call 555-0100."; }
  ALEX_OLD="Welcome to the Corner Shop help page."
  ALEX_NEW="Welcome to the Corner Shop help page. We are open 7 days a week."
  ALEX_MSG="docs: add opening days"
  messy() {
    printf '%s\n' "" "## FAQ" "" "**Can I return an item?**" "Yes, within 30 days with the retruns form." >> "$FILE"; git add "$FILE"; git commit -q -m "add faq heading"
    printf '%s\n' "" "**How long does shipping take?**" "Two to four business days in Canada." >> "$FILE"; git commit -q -am "wip"
    replace_text "$FILE" "retruns" "returns"; git commit -q -am "typo"
    printf '%s\n' "" "**Which payments do you take?**" "Visa, Mastercard, debit and PayPall." >> "$FILE"; git commit -q -am "more"
    replace_text "$FILE" "PayPall" "PayPal"; git commit -q -am "typo again"
  }
else
  FILE=setup.md; BRANCH=feature/setup-guide
  base() { printf '%s\n' "# New starter setup" "" "Read this on your first day." "" "## Who to ask" "" "Your buddy, or the #it-help channel."; }
  ALEX_OLD="Read this on your first day."
  ALEX_NEW="Read this on your first day. It takes about an hour."
  ALEX_MSG="docs: say how long setup takes"
  messy() {
    printf '%s\n' "" "## Steps" "" "1. Sign in to your laptop with the password from IT." "2. Open the email app and sign in with your work acount." >> "$FILE"; git add "$FILE"; git commit -q -m "start guide"
    printf '%s\n' "3. Join the #team channel in chat." >> "$FILE"; git commit -q -am "wip"
    replace_text "$FILE" "acount" "account"; git commit -q -am "fix spelling"
    printf '%s\n' "" "## Working from home" "" "Install the VPN app from the company portal and sign in with your work accuont." >> "$FILE"; git commit -q -am "vpn"
    replace_text "$FILE" "accuont" "account"; git commit -q -am "oops"
  }
fi

mkdir -p "$DIR"
cd "$DIR"
git init -q --bare -b main team.git

# Alex starts the project.
alex clone -q team.git alex 2>/dev/null
( cd alex
  git symbolic-ref HEAD refs/heads/main
  base > "$FILE"
  alex add "$FILE"; alex commit -q -m "docs: first version of $FILE"
  alex push -q -u origin main )

# You clone it, start a feature branch, commit in a hurry and push it.
git clone -q team.git you
( cd you
  git switch -q -c "$BRANCH"
  messy
  git push -q -u origin "$BRANCH" 2>/dev/null )

# Alex merges a small change to main. You have not fetched since.
( cd alex
  replace_line "$FILE" "$ALEX_OLD" "$ALEX_NEW"
  alex commit -q -am "$ALEX_MSG"
  alex push -q )

say "Ready. Three folders in $DIR:"
echo "    team.git   the shared repo. It plays the role of GitHub. Never edit it."
echo "    you        your clone, on branch $BRANCH. All your work happens here."
echo "    alex       your teammate's clone."
echo
echo "IMPORTANT: you are still in the labs folder. Before any git command, run:"
echo
echo "    cd $DIR/you"
echo
echo "Then check: pwd must end in g3-$VARIANT/you. Now follow TICKET.md, variant $VARIANT."
