## claudio
A minimal, containerized `claude` development environment. It exists mostly to run auto mode at a higher level of isolation than Claude Code's native sandboxing: everything happens inside a disposable container instead of directly on your machine.

It's built with `git`, `curl`, `mise`, and `docker`. `mise.toml` ships with just `claude`, `gh`, and `jq`; see [Tooling](#tooling) to add more.

### Install
```sh
git clone https://github.com/zapo/claudio.git ~/.claudio
alias claudio="docker compose -f ~/.claudio/docker-compose.yml run --rm claude"
```

### Usage
Navigate to your project and invoke `claudio` like you would invoke `claude`.

### Isolation
Each run is a fresh, disposable container (`--rm`): anything outside the mounts below is gone once it exits.

Persists across runs, via named volumes:
- `~/.config` and `~/.claude` (settings, credentials, conversation history).
- The dind daemon's own image/container cache, so you're not re-pulling images every run.

Bind-mounted from your host:
- Your project directory, at `/workspace`. File edits land directly on your host, same as running `claude` outside a container.

Docker commands go to their own dind daemon, so they can't see or touch your host's containers, images, or volumes.

### Tooling
There are three places to add tools, depending on who they're for:

| File | Who gets it | Committed? |
| --- | --- | --- |
| `mise.toml` | everyone, always | yes |
| `mise.<name>.toml` (e.g. `mise.playwright.toml`) | everyone, opt-in | yes |
| `mise.local.toml` | just you | no (gitignored) |

Opt-in groups activate via `MISE_ENV`, set in a `.env` file next to `docker-compose.yml`:
```sh
echo MISE_ENV=playwright >> ~/.claudio/.env
```
They compose too: `MISE_ENV=playwright,python` merges `mise.playwright.toml` and `mise.python.toml` together, so each group stays in its own file instead of needing one file per combination.

If a group also needs system packages (like Playwright's Chromium libs), extend the `if [ "$MISE_ENV" = "playwright" ]` block in the `Dockerfile`.
