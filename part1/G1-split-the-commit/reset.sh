#!/usr/bin/env bash
# G1 reset: deletes the drill folder so you can start again.
# Run: bash reset.sh   (or: bash reset.sh b)
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

VARIANT="${1:-a}"
case "$VARIANT" in a|b) ;; *) fail "Unknown variant '$VARIANT'. Use a or b." ;; esac
DIR="$LAB_HOME/g1-$VARIANT"
[[ -d "$DIR" ]] || { echo "Nothing to reset: $DIR does not exist."; exit 0; }
[[ -d "$DIR/.git" ]] || fail "$DIR is not a drill repo. Delete it yourself if you are sure."

confirm "This deletes the folder $DIR and everything in it. It cannot be undone."
rm -rf "$DIR"
say "Reset done. Run: bash setup.sh $VARIANT"
