# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
source $HOME/.profile

# Rails
alias r="rails"
export RAILS_ENV="development"

# flush dns alias
alias flush_dns="sudo discoveryutil mdnsflushcache"

# node.js and npm
export NODE_PATH="/usr/local/lib/node"
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Text editor
alias a="atom"
export EDITOR="atom"

# ls aliases
alias  l="ls -lha" # list / human readable size / including hidden (alpha order)
alias ll="ls -lhatr" # list / order by time / reversed / human readable size / including hidden

# SourceTreeApp
alias st='open -a SourceTree'

# other aliases
alias duu="du -sm | sort -n"
alias v="vagrant"
alias VBoxManage="/Applications/VirtualBox.app/Contents/MacOS/VBoxManage-x86"
alias filemerge="/Applications/Xcode.app/Contents/Applications/FileMerge.app/Contents/MacOS/FileMerge"
alias g="git"

export WP_CLI_PHP="/usr/bin/php"

# added by travis gem
[ -f /Users/yanick/.travis/travis.sh ] && source /Users/yanick/.travis/travis.sh
