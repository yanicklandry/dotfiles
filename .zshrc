export ZSH="/home/yanick/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(git aws cp docker docker-compose github golang helm jira kubectl minikube npm node python rsync screen ssh-agent sudo svn terraform pipenv vscode yarn)
SHOW_AWS_PROMPT=false

source $ZSH/oh-my-zsh.sh

alias tf="terraform"

alias docker-prune="docker system prune -af && docker image prune -af && docker volume prune -f && df -h"
alias docker-clean="docker container prune -f && docker image prune -af && docker volume prune -f && docker network prune -f && df -h"
alias dc="docker-compose"

export EDITOR="code -w"

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

export PATH=/usr/local/aws-cli/v2/2.0.57/bin:$PATH

# Brew Stuff

export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/isl@0.18/lib"
export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/isl@0.18/include"
export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/isl@0.18/lib/pkgconfig"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
export HOMEBREW_AUTO_UPDATE_SECS=1200
export HOMEBREW_NO_ENV_HINTS=1

# NVM Stuff

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

export DOTNET_CLI_TELEMETRY_OPTOUT="true"

export PATH="$PATH:/opt/mssql-tools/bin"
[ -f "/home/yanick/.ghcup/env" ] && source "/home/yanick/.ghcup/env" # ghcup-env

# set PATH for cuda 10.1 installation
if [ -d "/usr/local/cuda/bin/" ]; then
    export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}:/usr/local/cuda/extras/CUPTI/lib64
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# bun completions
[ -s "/home/yanick/.bun/_bun" ] && source "/home/yanick/.bun/_bun"

# bun
export BUN_INSTALL="/home/yanick/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias ls="exa --icons"
alias ll="exa -l --icons"
alias la="exa -a --icons"
alias l="exa -l --icons"
alias ld="exa -l -d --icons"
alias lt="exa -l -t --icons"

export skip_gem=1

alias d="doctl"

# Pnpm Stuff

export PNPM_HOME="/home/yanick/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

source $HOME/.profile
