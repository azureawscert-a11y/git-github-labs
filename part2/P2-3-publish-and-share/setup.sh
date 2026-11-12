#!/usr/bin/env bash
# P2-3 setup: creates a public repo with a one-page site, ready to publish.
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

need_tools
need_scopes codespace gist
ME="$(me)"
REPO="$ME/p2-3-site"
DIR="$LAB_HOME/p2-3-site"

repo_exists "$REPO" && fail "$REPO already exists. Run reset.sh first."

say "Creating $REPO (public) from the starter files"
copy_starter "$HERE/starter" "$DIR"
publish "$DIR" "$REPO" "One-page study notes site for the P2-3 lab"

say "Ready. Your working folder is $DIR"
echo "Open TICKET.md and start."
