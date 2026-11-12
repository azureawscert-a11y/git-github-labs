#!/usr/bin/env bash
# P2-3 reset: deletes the lab repo (and its Pages site), its codespaces,
# gists described "p2-3 lab", and the local folder.
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

need_tools
need_scopes delete_repo codespace gist
ME="$(me)"
REPO="$ME/p2-3-site"

confirm "This deletes $REPO with its Pages site, its codespaces, your gists whose
description contains \"p2-3 lab\", and the folder $LAB_HOME/p2-3-site.
It cannot be undone."

for cs in $(gh codespace list --repo "$REPO" --json name --jq '.[].name' 2>/dev/null || true); do
  gh codespace delete --codespace "$cs" --force
done

for id in $(gh gist list --limit 100 --filter 'p2-3 lab' | cut -f1); do
  gh gist delete "$id" --yes
done

if repo_exists "$REPO"; then gh repo delete "$REPO" --yes; else echo "skip: repo not found"; fi
rm -rf "$LAB_HOME/p2-3-site"
say "Reset done. Run setup.sh to start again."
