# Shared helpers for the Part 2 labs. Sourced by setup.sh and reset.sh.
# Works in bash on macOS, Linux and Git Bash on Windows.

set -euo pipefail

LAB_HOME="${LAB_HOME:-$HOME/git-lab/part2}"

say()  { printf '\n== %s\n' "$*"; }
fail() { printf '\nSTOP: %s\n' "$*" >&2; exit 1; }

need_tools() {
  command -v git >/dev/null 2>&1 || fail "git is not installed (Chapter 2)."
  command -v gh  >/dev/null 2>&1 || fail "the GitHub CLI (gh) is not installed. See cli.github.com."
  gh auth status >/dev/null 2>&1 || fail "gh is not signed in. Run: gh auth login"
  git config user.name  >/dev/null 2>&1 || fail "git user.name is not set (Chapter 2)."
  git config user.email >/dev/null 2>&1 || fail "git user.email is not set (Chapter 2)."
}

# need_scopes delete_repo project ...
# Checks the scopes listed by `gh auth status` and tells you how to add missing ones.
need_scopes() {
  local status missing=()
  status="$(gh auth status 2>&1 || true)"
  for s in "$@"; do
    grep -q "'$s'" <<<"$status" || missing+=("$s")
  done
  if ((${#missing[@]})); then
    local list; list="$(IFS=,; echo "${missing[*]}")"
    fail "gh needs more permission for this lab. Run this, approve it in the browser, then run this script again:
    gh auth refresh -s $list"
  fi
}

me() { gh api user --jq .login; }

repo_exists() { gh repo view "$1" >/dev/null 2>&1; }

# confirm "text": asks the reader to type yes
confirm() {
  local reply
  printf '%s\nType yes to continue: ' "$1"
  read -r reply
  [[ "$reply" == "yes" ]] || fail "Nothing was changed."
}

# copy_starter <starter dir> <target dir>: copies starter files into a new folder
copy_starter() {
  [[ -e "$2" ]] && fail "$2 already exists. Run reset.sh first, or move that folder."
  mkdir -p "$2"
  cp -R "$1"/. "$2"/
}

# publish <dir> <owner/name> <description>: first commit, then a new public repo
publish() {
  ( cd "$1"
    git init -q -b main
    git add .
    git commit -q -m "chore: starter files for the lab"
    gh repo create "$2" --public --description "$3" --source=. --remote=origin --push )
}
