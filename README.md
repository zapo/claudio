## claudio
Yet another claude-code cli environment for my basic web-dev needs,
wrapped in a docker container for isolation.

### Install
```
export CLAUDIO_PATH=~/.local/share/claudio # or wherever you prefer

git clone https://github.com/zapo/claudio.git "$CLAUDIO_PATH"
alias claudio="docker compose -f "$CLAUDIO_PATH/docker-compose.yml" run --rm claude"
```

### Usage
Navigate to your project and invoke `claudio` like you would invoke claude.
