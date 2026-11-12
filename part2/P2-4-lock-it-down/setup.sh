#!/usr/bin/env bash
# P2-4 setup: creates a public repo in YOUR practice organization and a
# "platform" team with write access to it.
# Usage: bash setup.sh YOUR-ORG
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

ORG="${1:-}"
[[ -n "$ORG" ]] || fail "Give your practice organization's name: bash setup.sh YOUR-ORG
Create a free one first: Settings > Organizations > New organization > Free."

need_tools
need_scopes admin:org
ME="$(me)"
[[ "$ORG" != "$ME" ]] || fail "That is your personal account. Use an organization you own."
gh api "orgs/$ORG" >/dev/null 2>&1 || fail "Organization $ORG not found, or you are not a member."

REPO="$ORG/p2-4-locked"
DIR="$LAB_HOME/p2-4-locked"
repo_exists "$REPO" && fail "$REPO already exists. Run reset.sh $ORG first."

say "Creating $REPO (public) from the starter files"
copy_starter "$HERE/starter" "$DIR"
publish "$DIR" "$REPO" "Practice repo for the P2-4 lab"

say "Creating the platform team and giving it write access"
gh api -X POST "orgs/$ORG/teams" -f name=platform -f privacy=closed \
  -f description="Owns infra/ in p2-4-locked" --silent
gh api -X PUT "orgs/$ORG/teams/platform/repos/$REPO" -f permission=push --silent

say "Ready. Your working folder is $DIR"
echo "Open TICKET.md and start."
