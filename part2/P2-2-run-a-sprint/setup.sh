#!/usr/bin/env bash
# P2-2 setup: creates a small public repo with real bugs for your sprint.
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

need_tools
need_scopes project
ME="$(me)"
REPO="$ME/p2-2-tip-split"
DIR="$LAB_HOME/p2-2-tip-split"

repo_exists "$REPO" && fail "$REPO already exists. Run reset.sh first."

say "Creating $REPO (public) from the starter files"
copy_starter "$HERE/starter" "$DIR"
publish "$DIR" "$REPO" "Share a restaurant bill fairly"

say "Adding a sprint label"
gh label create "sprint-1" --repo "$REPO" --color "1D76DB" --description "Planned for sprint 1"

say "Ready. Your working folder is $DIR"
echo "Open TICKET.md and start."
