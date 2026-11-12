#!/usr/bin/env bash
# P2-1 setup: creates a small public repo that is NOT ready for contributors yet.
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

need_tools
ME="$(me)"
REPO="$ME/p2-1-pocket-budget"
DIR="$LAB_HOME/p2-1-pocket-budget"

repo_exists "$REPO" && fail "$REPO already exists. Run reset.sh first."

say "Creating $REPO (public) from the starter files"
copy_starter "$HERE/starter" "$DIR"
publish "$DIR" "$REPO" "Add up monthly spending by category"

say "Ready. Your working folder is $DIR"
echo "Open TICKET.md and start."
