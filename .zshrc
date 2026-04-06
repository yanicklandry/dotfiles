# Uncomment the next line to profile shell startup — run `zprof` after sourcing
# zmodload zsh/zprof

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git aws docker docker-compose github golang helm jira kubectl minikube npm node python rsync screen ssh-agent sudo svn terraform vscode yarn)
SHOW_AWS_PROMPT=false
export AWS_PAGER=""

# Brew — must come before oh-my-zsh so paths/fpath are available
eval "$(brew shellenv)"
fpath+=("$HOMEBREW_PREFIX/opt/eza/share/zsh/site-functions")

source $ZSH/oh-my-zsh.sh

# Disable eza's broken zsh completion function (quotes filenames)
compdef -d eza

# ── Language / Locale ────────────────────────────────────────────────
export LANG=en_US.UTF-8

# ── Editors ──────────────────────────────────────────────────────────
export EDITOR="$HOME/bin/code-wait"
export VISUAL="$HOME/bin/code-wait"

# ── Homebrew ─────────────────────────────────────────────────────────
export HOMEBREW_AUTO_UPDATE_SECS=1200
export HOMEBREW_NO_ENV_HINTS=1

# ── NVM ──────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
# Lazy-load nvm — avoids ~300ms startup cost; loads on first use of node/npm/npx/nvm
_nvm_load() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm()  { unfunction nvm node npm npx; _nvm_load; nvm  "$@" }
node() { unfunction nvm node npm npx; _nvm_load; node "$@" }
npm()  { unfunction nvm node npm npx; _nvm_load; npm  "$@" }
npx()  { unfunction nvm node npm npx; _nvm_load; npx  "$@" }

# Auto-switch Node version when entering a directory with .nvmrc
_nvm_auto_use() {
  [[ -f .nvmrc ]] || return 0
  # If the nvm stub is still in place, load the real nvm first
  type nvm | grep -q '_nvm_load' && _nvm_load
  nvm use --silent
}
add-zsh-hook chpwd _nvm_auto_use

# ── Bun ──────────────────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ── Pnpm ─────────────────────────────────────────────────────────────
export PNPM_HOME="$HOME/.local/share/pnpm"

# ── Python / Pyenv / Pipx ────────────────────────────────────────────
export PYENV_VERSION=3
export PYENV_ROOT=$HOME/.pyenv
export PIPX_BIN_DIR=$HOME/.local/bin

# ── Java ─────────────────────────────────────────────────────────────
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
export CPATH="/opt/homebrew/include"
export C_INCLUDE_PATH="/opt/homebrew/include"

# ── Android ──────────────────────────────────────────────────────────
export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"

# ── Dotnet ───────────────────────────────────────────────────────────
export DOTNET_CLI_TELEMETRY_OPTOUT="true"

# ── Perl ─────────────────────────────────────────────────────────────
export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

# ── PATH ─────────────────────────────────────────────────────────────
export -U PATH path
path=(
  $PIPX_BIN_DIR
  $PYENV_ROOT/{bin,shims}
  $BUN_INSTALL/bin
  $PNPM_HOME
  $ANDROID_HOME/cmdline-tools/latest/bin
  /opt/homebrew/opt/openjdk@17/bin
  $HOME/perl5/bin
  $HOME/bin
  $path
)

# CUDA (only if present)
if [ -d "/usr/local/cuda/bin/" ]; then
  path=(/usr/local/cuda/bin $path)
  export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}:/usr/local/cuda/extras/CUPTI/lib64
fi

# ── Aliases: Git ─────────────────────────────────────────────────────
alias g="git"
export LLM_MODEL=claude-4-sonnet
function gcg {
  if git diff --cached --quiet; then
    echo "nothing staged" >&2; return 1
  fi
  local msg
  msg="$( (git diff --staged --stat && echo "---" && git diff --staged -- ":(exclude)package-lock.json" ":(exclude)pnpm-lock.yaml" ":(exclude)yarn.lock" ":(exclude)*.lock" | head -n 5000) | llm -m $LLM_MODEL -s "write a conventional commit message (feat/fix/docs/style/refactor) with scope. Output ONLY the commit message text - no markdown, no backticks, no code blocks, just the plain commit message")"
  echo "$msg"
  git commit -m "$msg" -e
}

# ── Aliases: Docker ──────────────────────────────────────────────────
alias dc="docker compose"
alias dc-restart="dc down && dc up --build -d && dc logs -f"
alias docker-prune="docker system prune -af && docker volume prune -f && df -h"
alias docker-clean="docker container prune -f && docker image prune -af && docker volume prune -f && docker network prune -f && df -h"

# ── Aliases: eza (ls) ────────────────────────────────────────────────
_EZA="eza --icons --no-quotes"
alias ls="$_EZA" ll="$_EZA -l" la="$_EZA -a" l="$_EZA -l" ld="$_EZA -l -d" lt="$_EZA -l -t"
unset _EZA

# ── Aliases: Misc ────────────────────────────────────────────────────
alias tf="terraform"
alias d="doctl"
alias h="$HOME/bin/htotheizzo.sh"
export skip_gem=1

# ── Ghcup (Haskell) ──────────────────────────────────────────────────
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# ── Local env/secrets (not in git) ───────────────────────────────────
[ -f "$HOME/.env.local" ] && source "$HOME/.env.local"

# ── Dev / Profiling ──────────────────────────────────────────────────
alias zsh-bench="time zsh -i -c exit"
# zprof  # uncomment this line (and zmodload at top) to print startup profile

# ── Pyenv/Pipenv helper ──────────────────────────────────────────────
pybake() {
  setopt LOCAL_OPTIONS ERR_RETURN
  .pybake.install-or-upgrade() {
    if command -v $1 &>/dev/null; then print -n "upgrade $1"
    else print -n "install $1"
    fi
  }
  trap "unfunction .pybake.install-or-upgrade" EXIT
  brew $( .pybake.install-or-upgrade pyenv )
  pyenv install --skip-existing "$(pyenv latest "$PYENV_VERSION" 2>/dev/null || echo "$PYENV_VERSION")"
  pip install --upgrade pip
  pip install --upgrade --user pipx
  pipx $( .pybake.install-or-upgrade pipenv )
}
