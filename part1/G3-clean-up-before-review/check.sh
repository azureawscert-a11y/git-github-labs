#!/usr/bin/env bash
# G3 check: looks at your branch on the shared repo and tells you what to fix.
# It checks the result, not which commands you used.
# Run: bash check.sh   (or: bash check.sh b)
HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib.sh
source "$HERE/../lib.sh"

VARIANT="${1:-a}"
case "$VARIANT" in a|b) ;; *) fail "Unknown variant '$VARIANT'. Use a or b." ;; esac
DIR="$LAB_HOME/g3-$VARIANT"
[[ -d "$DIR/you/.git" ]] || fail "No drill at $DIR. Run: bash setup.sh $VARIANT"
need_git
cd "$DIR/you"

if [[ "$VARIANT" == a ]]; then
  FILE=help.md; BRANCH=feature/faq
  ALEX_MSG="docs: add opening days"
  FIRST_HAS=("returns form" "shipping"); FIRST_NOT="payments"
  SECOND_HAS="PayPal."; TYPOS="retruns|PayPall"
  FIRST_WORDS="the returns and shipping questions"; SECOND_WORDS="the payment question"
  FINAL_LAST="Visa, Mastercard, debit and PayPal."
else
  FILE=setup.md; BRANCH=feature/setup-guide
  ALEX_MSG="docs: say how long setup takes"
  FIRST_HAS=("work account." "#team channel"); FIRST_NOT="VPN"
  SECOND_HAS="VPN"; TYPOS="acount|accuont"
  FIRST_WORDS="the three setup steps"; SECOND_WORDS="the working from home section"
  FINAL_LAST="Install the VPN app from the company portal and sign in with your work account."
fi

printf 'Checking drill G3, variant %s, in %s\n\n' "$VARIANT" "$DIR"
git fetch -q origin

if [[ -d .git/rebase-merge || -d .git/rebase-apply ]]; then
  nope "No rebase is half-finished." "git status shows where you are. Finish with git rebase --continue, or start again with git rebase --abort."
fi

br="$(git symbolic-ref --short -q HEAD || echo DETACHED)"
if [[ "$br" == "$BRANCH" ]]; then pass "You are on $BRANCH."
else nope "You are on $BRANCH." "You are on '$br'. Run: git switch $BRANCH"; fi

if git log origin/main --format='%s' | grep -qx "$ALEX_MSG"; then pass "main on the shared repo still has Alex's commit."
else nope "main on the shared repo still has Alex's commit." "main was overwritten. Only your feature branch should ever be force pushed. Start again: bash reset.sh $VARIANT && bash setup.sh $VARIANT"; fi

R="origin/$BRANCH"
git rev-parse -q --verify "$R" >/dev/null || fail "There is no $BRANCH on the shared repo. Run: git push -u origin $BRANCH"

if [[ "$(git merge-base origin/main "$R")" == "$(git rev-parse origin/main)" ]]; then pass "The shared branch starts from the latest main."
else nope "The shared branch starts from the latest main." "It still starts from the old main. Run git fetch, then git rebase -i origin/main, then push again."; fi

merges="$(git rev-list --merges --count origin/main.."$R")"
count="$(git rev-list --count origin/main.."$R")"
if [[ "$merges" == 0 ]]; then pass "The shared branch has no merge commits."
else nope "The shared branch has no merge commits." "A merge crept in, usually from running git pull after the rejected push. If the merge is your last commit, git reset --hard HEAD~1 removes it. Then push with --force-with-lease --force-if-includes."; fi

if [[ "$count" == 2 ]]; then pass "The shared branch has exactly two commits."
else nope "The shared branch has exactly two commits." "It has $count. In git rebase -i, keep two lines as pick or reword and mark the others fixup."; fi

final="$(git show "$R:$FILE" 2>/dev/null || true)"
if printf '%s\n' "$final" | grep -qE "$TYPOS"; then
  nope "No typos are left in $FILE." "A typo fix was lost, often by marking it drop instead of fixup. git reflog shows where your branch was; git reset --hard <that hash> gets it back."
else pass "No typos are left in $FILE."; fi
if [[ "$(printf '%s\n' "$final" | tail -n 1)" == "$FINAL_LAST" ]] && printf '%s\n' "$final" | grep -q "${FIRST_HAS[0]}"; then
  pass "All of your work is still in $FILE."
else nope "All of your work is still in $FILE." "Something is missing. A commit marked drop is deleted. git reflog shows where your branch was before; git reset --hard <that hash> gets it back, then try again."; fi

if (( count == 2 )); then
  c1="$(git rev-list --reverse origin/main.."$R" | head -n 1)"; c2="$(git rev-list --reverse origin/main.."$R" | tail -n 1)"
  t1="$(git show "$c1:$FILE")"
  ok1=1; for k in "${FIRST_HAS[@]}"; do printf '%s' "$t1" | grep -qF "$k" || ok1=0; done
  printf '%s' "$t1" | grep -qF "$FIRST_NOT" && ok1=0
  if ((ok1)); then pass "Commit 1 holds $FIRST_WORDS, with the typo fixed."
  else nope "Commit 1 holds $FIRST_WORDS, with the typo fixed." "Commit 1 should be the first three messy commits folded together. Mark wip and the first typo fix as fixup under it."; fi
  if [[ "$(git show "$c2:$FILE" | tail -n 1)" == "$FINAL_LAST" ]] && git show "$c2" | grep -q "^+.*$SECOND_HAS"; then pass "Commit 2 holds $SECOND_WORDS, with its typo fixed."
  else nope "Commit 2 holds $SECOND_WORDS, with its typo fixed." "Commit 2 should be the fourth messy commit with the last typo fix folded in as fixup."; fi
  for c in "$c1" "$c2"; do
    subj="$(git log -1 --format=%s "$c")"
    if printf '%s' "$subj" | grep -qE '^(docs|feat|fix|chore)(\([a-z0-9-]+\))?!?: .{8,}'; then pass "Message \"$subj\" says what changed."
    else nope "Message \"$subj\" says what changed." "Use the style from Chapter 22, such as docs: add the payment question. Change it with reword in git rebase -i."; fi
  done
fi

if [[ -z "$(git status --porcelain)" ]]; then pass "Your working tree is clean."
else nope "Your working tree is clean." "git status still shows changes."; fi

if [[ "$(git rev-parse HEAD)" == "$(git rev-parse "$R")" ]]; then pass "Your branch matches the shared repo."
else nope "Your branch matches the shared repo." "Your cleaned-up branch is not pushed yet. Run: git push --force-with-lease --force-if-includes"; fi

summary
