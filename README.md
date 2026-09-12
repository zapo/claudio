## claudio
A minimal, containerized `claude` development environment.

### Install
```sh
git clone https://github.com/zapo/claudio.git ~/.claudio
alias claudio="docker compose -f ~/.claudio/docker-compose.yml run --rm claude"
```

### Usage
Navigate to your project and invoke `claudio` like you would invoke `claude`.

### Features
- **Sandboxed**: it runs in its own container, and Docker commands go to an isolated dind instance instead of your host.
- **Minimal by default**: `mise.toml` ships with just `claude`. Add languages and CLIs there for everyone, or system packages in the `Dockerfile`.
- **A [template](https://github.com/new?template_name=claudio&template_owner=zapo)**: fork it and make it yours.

### What's in the box
- **Base**: Ubuntu 24.04.
- **System packages**: `git`, `curl`, `ca-certificates`, `procps`, `openssh-client`, `mise`, and `docker.io` plus `docker-compose-v2` (used to talk to the isolated dind instance).
- **mise tools (default)**: `claude` and `jq`.
- **An isolated dind daemon**: a separate `dockerd-isolated` service that the container's Docker CLI points at, so Docker commands never touch your host's daemon.

### Tooling layers
Three places to add tools, depending on who they're for:

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
