# .claude

Version-controlled configuration for [Claude Code](https://claude.com/claude-code) on this
machine, living directly in `~/.claude`.

Claude Code uses `~/.claude` for two very different things: a handful of files I actually write,
and a large amount of runtime state it manages itself (conversation transcripts, caches, session
keys, downloaded plugins — hundreds of megabytes of it). Only the first group is tracked.
`.gitignore` denies everything by default and re-includes tracked paths explicitly, so new state
files are ignored automatically instead of needing a rule each time.

## What is tracked

| Path | Purpose |
| --- | --- |
| `CLAUDE.md` | Global instructions applied to every project on this machine. |
| `settings.json.example` | Template for `settings.json` — see below. |
| `statusline.sh` | Status line in use: model, directory, git branch, context bar, cost, elapsed time. |
| `statusline-command.sh` | Earlier status line variant, kept for reference. |
| `skills/` | Symlinks into `~/.agents/skills`, which is managed separately. |
| `agents/`, `commands/`, `hooks/`, `output-styles/` | Allowed ahead of time so they are picked up when they appear. |

## settings.json

`settings.json` is **not** tracked. It holds an `OTEL_EXPORTER_OTLP_HEADERS` bearer token for the
telemetry endpoint, and a secret in git history stays recoverable long after it is removed.

`settings.json.example` is the same file with that token redacted. When the configuration changes,
refresh the template:

```sh
jq '.env.OTEL_EXPORTER_OTLP_HEADERS = "Authorization=Bearer <REDACTED>"' \
  ~/.claude/settings.json > ~/.claude/settings.json.example
```

## Setting up a new machine

```sh
git clone git@github.com:Shion1305/.claude.git ~/.claude   # into an empty ~/.claude
cp ~/.claude/settings.json.example ~/.claude/settings.json
# then paste the real OTLP token into settings.json
chmod +x ~/.claude/statusline.sh
```

Entries under `skills/` point at `~/.agents/skills`; they dangle until that directory exists.
