# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git jira)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
source .profile

# <prompt>
# D=$'\e[37;40m'
# PINK=$'\e[35;40m'
# GREEN=$'\e[32;40m'
# ORANGE=$'\e[33;40m'
#
# hg_ps1() {
#     hg prompt "{${D} on ${PINK}{branch}}{${D} at ${ORANGE}{bookmark}}{${GREEN}{status}}" 2> /dev/null
# }
#
# export PS1='\n${PINK}\u ${D}at ${ORANGE}\h ${D}in ${GREEN}\w$(hg_ps1)\
# ${D}\n$ '

# </prompt>

# RVM

# Rails alias
alias r="rails"
export RAILS_ENV="development"

# Pow
alias pow_restart="touch ~/.pow/restart.txt"

# fix mysql
# export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

# flush dns alias
alias flush_dns="sudo discoveryutil mdnsflushcache"

# node.js and npm
export NODE_PATH="/usr/local/lib/node"

# TextMate alias
alias m="mate"
export EDITOR="nano"

# ls aliases
alias  l="ls -lha" # list / human readable size / including hidden (alpha order)
alias ll="ls -ltrha" # list / order by time / reversed / human readable size / including hidden

# SourceTreeApp
alias st='open -a SourceTree'

# SickBeard alias
alias sickbeard="python ~/Documents/code/python/Sick-Beard/SickBeard.py"

# aliases for Digital Midi :
alias gall='bundle exec guard -g all'
alias gcu='bundle exec guard -g cucumber'
alias gcufocus='bundle exec guard -g cucumber_with_focus'
alias gfocus='SPEC_INCLUDE='\''focus'\'' bundle exec guard -g rspec'
alias grspec='bundle exec guard -g rspec'
alias gslow='SPEC_INCLUDE='\''slow'\'' SPEC_EXCLUDE='\'''\'' bundle exec guard -g rspec'
alias hlp='heroku logs -tail --app digital-midi-production'
alias hls='heroku logs -tail --app digital-midi-staging'
alias hpp='heroku ps --app digital-midi-production'
alias hps='heroku ps --app digital-midi-staging'
ARCHFLAGS="-arch x86_64"

# other aliases
alias duu="du -sm | sort -n"
alias v="vagrant"
alias VBoxManage="/Applications/VirtualBox.app/Contents/MacOS/VBoxManage-x86"
alias filemerge="/Applications/Xcode.app/Contents/Applications/FileMerge.app/Contents/MacOS/FileMerge"
alias g="git"

# google chrome canary
alias can="open -a Google\ Chrome\ Canary"

export WP_CLI_PHP="/usr/bin/php"

alias c="php app/console"


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
