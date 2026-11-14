#!/usr/bin/env bash
# G3 reset: deletes the drill folder so you can start again.
# Run: bash reset.sh   (or: bash reset.sh b)
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

VARIANT="${1:-a}"
case "$VARIANT" in a|b) ;; *) fail "Unknown variant '$VARIANT'. Use a or b." ;; esac
DIR="$LAB_HOME/g3-$VARIANT"
[[ -d "$DIR" ]] || { echo "Nothing to reset: $DIR does not exist."; exit 0; }
[[ -d "$DIR/team.git" && -d "$DIR/you/.git" ]] || fail "$DIR is not a G3 drill folder. Delete it yourself if you are sure."

confirm "This deletes the folder $DIR (team.git, you and alex). It cannot be undone."
rm -rf "$DIR"
say "Reset done. Run: bash setup.sh $VARIANT"
