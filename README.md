dotfiles
========

My dot files. Feel free to copy them!

## Install

```sh
git clone https://github.com/yanick/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh       # preview what will be linked
./install.sh -y    # apply (skips existing files)
./install.sh -yf   # apply, backing up existing files first
```

Re-running `install.sh` is safe — already-correct symlinks are left untouched.

## Dependencies

Install these before sourcing `.zshrc`:

| Tool | Purpose | Install |
|---|---|---|
| [oh-my-zsh](https://ohmyz.sh) | zsh framework | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |
| [Homebrew](https://brew.sh) | package manager | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` |
| [eza](https://github.com/eza-community/eza) | `ls` replacement | `brew install eza` |
| [llm](https://llm.datasette.io) | AI commit messages | `brew install llm` |
| [nvm](https://github.com/nvm-sh/nvm) | Node version manager | see nvm docs |
| [pyenv](https://github.com/pyenv/pyenv) | Python version manager | `brew install pyenv` |
| [bun](https://bun.sh) | JS runtime | `curl -fsSL https://bun.sh/install \| bash` |

## Secrets

Copy `.env.local.template` to `~/.env.local` and fill in your API keys.
`install.sh` does this automatically if `~/.env.local` doesn't exist yet.
`~/.env.local` is sourced at the end of `.zshrc` and is never committed.

## Key aliases

| Alias / Function | Description |
|---|---|
| `gc` | AI-generated conventional commit message via `llm`, opens editor to confirm |
| `g` | `git` |
| `dc` | `docker compose` |
| `dc-restart` | rebuild and follow logs |
| `docker-prune` | full Docker cleanup + disk report |
| `tf` | `terraform` |
| `d` | `doctl` (DigitalOcean CLI) |
| `l` / `ll` / `ls` / `la` | `eza` variants with icons |

## bin/ utilities

| Script | Description |
|---|---|
| `dfs` | Simplified `df -h` for macOS (filters noise) |
| `code-wait` | `code -w` wrapper — opens VS Code and waits |
| `vpn_check.sh` | Detects active VPN via routing table |
| `git-cleanup-merged-branches.sh` | Deletes local branches whose remotes are gone |
| `brew-size.sh` | Lists Homebrew packages sorted by disk usage |
| `fix-stremio.sh` | Reinstalls and re-signs Stremio (macOS) |
| `restart_whisky.sh` | Clears Steam cache inside a Whisky bottle (macOS) |

## Testing

```sh
./test.sh            # shellcheck + executability + symlink health
./test.sh --bench    # also runs 10-iteration zsh startup benchmark
```
