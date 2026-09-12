## claudy
Yet another claude-code cli environment for my basic web-dev needs,
wrapped in a docker container for isolation.

### Install
```
git clone https://github.com/zapo/claudy.git <claudy-path>
alias claudy="docker compose -f <claudy-path>/docker-compose.yml run --rm claude-sandbox"
```

### Usage
Navigate to your project and invoke claudy like you would invooke claude.
