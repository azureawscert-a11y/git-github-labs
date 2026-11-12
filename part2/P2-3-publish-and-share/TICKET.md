# P2-3: Publish and share

Chapters 16, 17 and 18. About 45 minutes.

## The ticket

> **From:** the team's tech writer
> **Repo:** `p2-3-site`
>
> Our study notes page is sitting in `docs/` and nobody can see it. Please
> publish it, share my command notes with the new hire without making them
> public, and set the repo up so anyone can open it in a ready-made cloud
> environment. Add a tiny workflow so we can see Actions run on every push.

## Start

```bash
bash setup.sh
cd ~/git-lab/part2/p2-3-site
```

## Done when

- [ ] GitHub Pages publishes the `docs/` folder from `main`, and the page opens at `https://YOUR-USERNAME.github.io/p2-3-site/`
- [ ] `notes.md` is shared as a **secret** gist whose description contains `p2-3 lab`
- [ ] `.devcontainer/devcontainer.json` uses a Python image and forwards port 8000
- [ ] You started a codespace on `main`, served the site from its terminal, opened the forwarded port, then **deleted** the codespace
- [ ] `.github/workflows/hello.yml` runs on every push, and one run shows green on the Actions tab

## Hints

- Pages: **Settings > Pages**, deploy from a branch, choose `main` and `/docs`. The first publish can take a minute or two.
- A secret gist is not private: anyone with the link can open it (Chapter 16).
- Codespaces use your free monthly allowance while they run. Stop or delete them when you are done (Chapter 17).
- The hello workflow is in Chapter 23. Chapter 18 explains event, workflow, job and step.
- Stuck? `SOLUTION.md` has one complete answer. Try first.

## Start over

```bash
bash reset.sh
```

Needs the `delete_repo`, `codespace` and `gist` scopes. Deleting the repo also
takes down its Pages site.
