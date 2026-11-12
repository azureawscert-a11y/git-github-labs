#!/usr/bin/env bash
# P2-2 reset: deletes the lab repo, the "P2-2 Sprint" project and the local folder.
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

need_tools
need_scopes delete_repo project
ME="$(me)"

confirm "This deletes $ME/p2-2-tip-split, every project of yours titled \"P2-2 Sprint\",
and the folder $LAB_HOME/p2-2-tip-split. It cannot be undone."

if repo_exists "$ME/p2-2-tip-split"; then gh repo delete "$ME/p2-2-tip-split" --yes; else echo "skip: repo not found"; fi

for n in $(gh project list --owner "@me" --format json --jq '.projects[] | select(.title=="P2-2 Sprint") | .number'); do
  gh project delete "$n" --owner "@me"
done

rm -rf "$LAB_HOME/p2-2-tip-split"
say "Reset done. Run setup.sh to start again."
