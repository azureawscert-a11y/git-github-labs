# shellcheck shell=bash
# Shared helpers for the Part 1 drills. Sourced by setup.sh, check.sh and reset.sh.
# Git only: no GitHub account and no internet needed.
# Works in bash 3.2 or newer: macOS Terminal, Linux, and Git Bash on Windows.

set -euo pipefail

LAB_HOME="${LAB_HOME:-$HOME/git-lab/part1}"

say()  { printf '\n== %s\n' "$*"; }
fail() { printf '\nSTOP: %s\n' "$*" >&2; exit 1; }

need_git() {
  command -v git >/dev/null 2>&1 || fail "git is not installed (Start Here, Step 3)."
  git config user.name  >/dev/null 2>&1 || fail "git user.name is not set (Start Here, Step 4)."
  git config user.email >/dev/null 2>&1 || fail "git user.email is not set (Start Here, Step 4)."
}

# confirm "text": asks the reader to type yes
confirm() {
  local reply
  printf '%s\nType yes to continue: ' "$1"
  read -r reply
  [[ "$reply" == "yes" ]] || fail "Nothing was changed."
}

# Checker output. Each check prints PASS or FAIL with a hint.
FAILS=0
pass() { printf '  PASS  %s\n' "$1"; }
nope() { printf '  FAIL  %s\n        hint: %s\n' "$1" "$2"; FAILS=$((FAILS + 1)); }
summary() {
  if ((FAILS)); then
    printf '\n%s check(s) failed. Fix them and run check.sh again.\n' "$FAILS"; exit 1
  fi
  printf '\nAll checks passed. Ticket done.\n'
}
