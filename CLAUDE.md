# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal macOS dotfiles and utility scripts for Yanick Landry. No build system, no tests — changes are applied by editing files and (re)symlinking or sourcing them.

## File layout

- `.zshrc` — main shell config: oh-my-zsh, all PATH/env setup, aliases
- `.zprofile` — Homebrew init (runs before .zshrc on login shells)
- `.gitconfig` — git identity, aliases, push/pull defaults
- `.gitignore` — repo-level ignores (env files, secrets, some bin/ submodules)
- `.env.local.template` — copy to `~/.env.local` for secrets (e.g. `GEMINI_API_KEY`); never committed
- `bin/` — standalone utility scripts on `$PATH` via `$HOME/bin`

## Key environment details (.zshrc)

- **Editor**: `$HOME/bin/code-wait` (VS Code with `-w` flag)
- **LLM**: `$LLM_MODEL=claude-sonnet-4-6`; the `gc` alias auto-generates conventional commit messages using `llm` CLI from staged diff
- **Node**: nvm manages Node versions; bun and pnpm also available
- **Python**: pyenv + pipx; `pybake` shell function bootstraps pyenv/pipenv via Homebrew
- **Java**: OpenJDK 17 via Homebrew at `/opt/homebrew/opt/openjdk@17`
- **ls replacement**: `eza` with `--icons --no-quotes`; the default zsh completion for eza is disabled (`compdef -d eza`) to avoid quoting bugs

## bin/ scripts

| Script | Purpose |
|---|---|
| `code-wait` | `code -w` wrapper — opens VS Code and waits |
| `dfs` | Simplified `df -h` showing only relevant macOS volumes |
| `vpn_check.sh` | Checks for active VPN via `utun`/`pptp`/`l2tp` interfaces |
| `git-cleanup-merged-branches.sh` | Deletes local branches whose remotes are gone; skips `master`, `main`, `staging`, `develop` |
| `fix-stremio.sh` | Reinstalls Stremio and re-signs the app bundle |
| `create_timestamp_folder.sh` | Creates a timestamped directory |

## Secrets / sensitive files

- `~/.env.local` is sourced at the end of `.zshrc` — put API keys there
- `.gitignore` excludes `.env`, `.env.*`, `*secret*`, `*credential*`, `*token*`, `*.pem`, `*.key`
- `bin/claude-process-manager`, `bin/cproc`, `bin/cproc2`, `bin/.htotheizzo` are gitignored (local-only submodules/scripts)
