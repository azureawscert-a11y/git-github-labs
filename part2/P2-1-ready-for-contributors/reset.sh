#!/usr/bin/env bash
# P2-1 reset: deletes the lab repos and the local folder so you can start again.
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

need_tools
need_scopes delete_repo
ME="$(me)"

confirm "This deletes $ME/p2-1-pocket-budget, $ME/p2-1-from-template and the folder
$LAB_HOME/p2-1-pocket-budget. It cannot be undone."

for r in p2-1-pocket-budget p2-1-from-template; do
  if repo_exists "$ME/$r"; then gh repo delete "$ME/$r" --yes; else echo "skip: $ME/$r not found"; fi
done
rm -rf "$LAB_HOME/p2-1-pocket-budget" "$LAB_HOME/p2-1-from-template"
say "Reset done. Run setup.sh to start again."
