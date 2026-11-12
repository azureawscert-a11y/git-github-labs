#!/usr/bin/env bash
# P2-4 reset: deletes the org repo, the platform team, your personal fork and
# the local folders. The organization itself is left alone.
# Usage: bash reset.sh YOUR-ORG
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

ORG="${1:-}"
[[ -n "$ORG" ]] || fail "Give your practice organization's name: bash reset.sh YOUR-ORG"

need_tools
need_scopes delete_repo admin:org
ME="$(me)"

confirm "This deletes $ORG/p2-4-locked, the $ORG/platform team, your fork
$ME/p2-4-locked, and the folders under $LAB_HOME for this lab.
It cannot be undone. The organization $ORG itself is not deleted."

for r in "$ORG/p2-4-locked" "$ME/p2-4-locked"; do
  if repo_exists "$r"; then gh repo delete "$r" --yes; else echo "skip: $r not found"; fi
done
if gh api "orgs/$ORG/teams/platform" >/dev/null 2>&1; then
  gh api -X DELETE "orgs/$ORG/teams/platform" --silent
else
  echo "skip: team platform not found"
fi
rm -rf "$LAB_HOME/p2-4-locked" "$LAB_HOME/p2-4-fork"
say "Reset done. Run setup.sh $ORG to start again."
