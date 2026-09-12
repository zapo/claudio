## claudy
Yet another claude-code cli environment for my basic web-dev needs,
wrapped in a docker container for isolation.

### Install
```
export CLAUDY_PATH=~/.local/share/claudy # or wherever you prefer

git clone https://github.com/zapo/claudy.git "$CLAUDY_PATH"
alias claudy="docker compose -f "$CLAUDY_PATH/docker-compose.yml" run --rm claude"
```

### Usage
Navigate to your project and invoke `claudy` like you would invoke claude.
