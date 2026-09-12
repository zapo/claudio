## claudio
A containerized `claude` — isolated, disposable, forkable.

### Install
Clone it, then add a `claudio` function to your shell rc (`~/.bashrc`, `~/.zshrc`, ...):
```sh
git clone https://github.com/zapo/claudio.git ~/.claudio

claudio() {
  TZ="$(cat /etc/timezone 2>/dev/null || echo UTC)" \
    docker compose -f ~/.claudio/docker-compose.yml run --rm claude
}
```

### Usage
Navigate to your project and invoke `claudio` like you would invoke `claude`.

### Features
- **Sandboxed** — runs in its own container; Docker commands go to an isolated dind instance, not your host.
- **Your timezone** — forwarded from the host automatically, no config needed.
- **Minimal by default** — `mise.toml` ships with just `claude`. Add languages/CLIs there for everyone, or system packages in the `Dockerfile`.
- **A [template](https://github.com/new?template_name=claudio&template_owner=zapo)** — fork it and make it yours.

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
They compose — `MISE_ENV=playwright,python` merges `mise.playwright.toml` and `mise.python.toml` together — so each group stays in its own file instead of needing one file per combination.

If a group also needs system packages (like Playwright's Chromium libs), extend the `if [ "$MISE_ENV" = "playwright" ]` block in the `Dockerfile`.
