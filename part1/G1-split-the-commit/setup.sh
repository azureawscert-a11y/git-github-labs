#!/usr/bin/env bash
# G1 setup: makes a local repo with one commit, then leaves three mixed-up
# changes in one file for you to split. Run: bash setup.sh   (or: bash setup.sh b)
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

VARIANT="${1:-a}"
case "$VARIANT" in a|b) ;; *) fail "Unknown variant '$VARIANT'. Use a or b." ;; esac

need_git
DIR="$LAB_HOME/g1-$VARIANT"
[[ -e "$DIR" ]] && fail "$DIR already exists. Run: bash reset.sh $VARIANT"

mkdir -p "$DIR"
cd "$DIR"
git init -q -b main

if [[ "$VARIANT" == a ]]; then
FILE=menu.txt
write_start() { cat > "$FILE" <<'TXT'
Corner Cafe menu
================

Hot drinks
----------
Coffee ......... 3.50
Latte .......... 4.25
Hot chocolate .. 3.75
Chai ........... 4.00

Bakery
------
Croissant ...... 2.95
Muffin ......... 3.25
Banana bread ... 3.50
Cookie ......... 1.95

Cold drinks
-----------
Iced coffee .... 4.00
Lemonade ....... 3.25
Smoothie ....... 5.50

Prices include tax.
Open 7 am to 6 pm.
TXT
}
write_mixed() { cat > "$FILE" <<'TXT'
Corner Cafe menu
================

Hot drinks
----------
Coffee ......... 3.50
Latte .......... 4.50
Hot chocolate .. 3.75
Chai ........... 4.00

Bakery
------
Croissant ...... 2.95
Muffin ......... 3.25
DEBUG: are the dots lined up?
Banana bread ... 3.50
Cookie ......... 1.95

Cold drinks
-----------
Iced coffee .... 4.00
Lemonade ....... 3.25
Smoothie ....... 5.50
Iced tea ....... 3.50

Prices include tax.
Open 7 am to 6 pm.
TXT
}
else
FILE=hours.txt
write_start() { cat > "$FILE" <<'TXT'
Maple Street Library
====================

Opening hours
-------------
Monday ......... 9 am to 8 pm
Tuesday ........ 9 am to 8 pm
Wednesday ...... 9 am to 8 pm
Thursday ....... 9 am to 8 pm
Friday ......... 9 am to 6 pm
Saturday ....... 10 am to 5 pm
Sunday ......... closed

Last checkout is 15 minutes before closing.
Book returns are open all day.

Services
--------
Printing ....... 10 cents a page
Wi-Fi .......... free
Study rooms .... book at the desk
Meeting room ... book online
Laptop loans ... ask at the desk
Kids corner .... ground floor

Closed on holidays
------------------
New Year's Day
Canada Day
Thanksgiving
TXT
}
write_mixed() { cat > "$FILE" <<'TXT'
Maple Street Library
====================

Opening hours
-------------
Monday ......... 9 am to 8 pm
Tuesday ........ 9 am to 8 pm
Wednesday ...... 9 am to 8 pm
Thursday ....... 9 am to 8 pm
Friday ......... 9 am to 6 pm
Saturday ....... 10 am to 4 pm
Sunday ......... closed

Last checkout is 15 minutes before closing.
Book returns are open all day.

Services
--------
Printing ....... 10 cents a page
Wi-Fi .......... free
DEBUG: remove before commit
Study rooms .... book at the desk
Meeting room ... book online
Laptop loans ... ask at the desk
Kids corner .... ground floor

Closed on holidays
------------------
New Year's Day
Canada Day
Civic Holday
Thanksgiving
TXT
}
fi

write_start
git add "$FILE"
git commit -q -m "chore: starting file for drill G1"
write_mixed

say "Ready. Your drill folder is $DIR"
echo
echo "IMPORTANT: you are still in the labs folder. Before any git command, run:"
echo
echo "    cd $DIR"
echo
echo "Then check: pwd must end in part1/g1-$VARIANT. Now follow TICKET.md, variant $VARIANT."
