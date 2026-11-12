# P2-3 solution

One way to finish the ticket. Replace `YOUR-USERNAME` with your GitHub username.
Work in `~/git-lab/part2/p2-3-site`.

## 1. Publish the site

On GitHub: **Settings > Pages**. Under **Build and deployment**, source
**Deploy from a branch**, branch `main`, folder `/docs`, **Save**. When the
page shows the address, open it:

```text
https://YOUR-USERNAME.github.io/p2-3-site/
```

The repo is public, so Pages works on a free account.

## 2. Share the notes as a secret gist

```bash
gh gist create notes.md --desc "p2-3 lab: commands I keep forgetting"
```

`gh gist create` makes a secret gist unless you add `--public`. Send the URL it
prints to the new hire. Anyone with that URL can read it, so never put a
password or key in a gist.

## 3. Dev container and workflow, through a PR

`.devcontainer/devcontainer.json`

```json
{
  "name": "p2-3 site",
  "image": "mcr.microsoft.com/devcontainers/python:3.12",
  "forwardPorts": [8000]
}
```

`.github/workflows/hello.yml`

```yaml
name: hello
on: [push, workflow_dispatch]
jobs:
  hi:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Hello from CI"
```

```bash
git switch -c chore/devcontainer-and-ci
git add .devcontainer .github
git commit -m "chore: add a dev container and a hello workflow"
git push -u origin chore/devcontainer-and-ci
gh pr create --fill
gh pr merge --squash --delete-branch
git switch main && git pull
gh run list --limit 3
gh run watch
```

## 4. Codespace: start, use, delete

```bash
gh codespace create -R YOUR-USERNAME/p2-3-site -b main -m basicLinux32gb
gh codespace code        # or open it from Code > Codespaces in the browser
```

Without `-m`, `gh` asks you to pick a machine type, and fails if it has no
terminal to ask in. A free account sees two: `basicLinux32gb` (2 cores) and
`standardLinux32gb` (4 cores). Pick the 2-core one; it uses your allowance
half as fast.

A new codespace opens in Restricted Mode and asks **Do you trust the authors of
the files in this folder?** Choose **Yes, I trust the authors**, and the
terminal works. It greets you with "You are on a custom image defined in your
devcontainer.json file."

In the codespace terminal:

```bash
python3 -m http.server 8000 --directory docs
```

A message says the app on port 8000 is available (**Open in Browser**, **Make
Public**). Or use the **Ports** tab. The address looks like
`https://CODESPACE-NAME-8000.app.github.dev/`. Check the page. Then stop
the server with Ctrl+C, close the codespace and delete it:

```bash
gh codespace list
gh codespace delete
```

## Check your work

```bash
gh api repos/YOUR-USERNAME/p2-3-site/pages --jq '.html_url, .source'
gh gist list --secret
gh codespace list        # nothing left for p2-3-site
gh run list --limit 3    # a green "hello" run
```
