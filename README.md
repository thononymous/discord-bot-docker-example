# Discord bot

## Building

```
docker build -t docker-bot .
```

## Running

`discord-bot.py` expects a bare token in a file mounted at `/secret-vol/discord-token`.

For example:

```
docker run -v "/home/user/.discord-token:/secret-vol/discord-token:ro" discord-bot
```
