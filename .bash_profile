# <path>

# Add RVM to PATH for scripting
PATH=/Applications/Postgres.app/Contents/MacOS/bin:/usr/local/bin:$PATH:$HOME/.rvm/bin:$HOME/bin:/usr/local/mysql/bin 

# Use MAMPS's PHP
PATH=/Applications/MAMP/bin/php/php5.4.4/bin:$PATH

#add sbin to PATH (for Homebrew)
PATH=/usr/local/sbin:$PATH

# </path>

# <prompt>
D=$'\e[37;40m'
PINK=$'\e[35;40m'
GREEN=$'\e[32;40m'
ORANGE=$'\e[33;40m'

hg_ps1() {
    hg prompt "{${D} on ${PINK}{branch}}{${D} at ${ORANGE}{bookmark}}{${GREEN}{status}}" 2> /dev/null
}

export PS1='\n${PINK}\u ${D}at ${ORANGE}\h ${D}in ${GREEN}\w$(hg_ps1)\
${D}\n$ '

# </prompt>

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM 

# Rails alias
alias r="rails"
export RAILS_ENV="development"

# Pow
alias pow_restart="touch ~/.pow/restart.txt"

# fix mysql
# export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

# flush dns alias
alias flush_dns="sudo killall -HUP mDNSResponder"

export environment="chasse_dev"

# node.js and npm
export NODE_PATH="/usr/local/lib/node"
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:$PATH"

# TextMate alias
alias m="mate"
export EDITOR="nano"

# ls aliases
alias  l="ls -lha" # list / human readable size / including hidden (alpha order)
alias ll="ls -ltrha" # list / order by time / reversed / human readable size / including hidden

# naming tabs with ssh hostnames
function tabname { printf "\e]1;$1\a"; }
function winname { printf "\e]2;$1\a"; }
function ssh() { echo "$@" | tabname `sed -E 's/(.*@)?([-a-zA-Z0-9\.]*)(.*)/\2/'`; /usr/bin/ssh "$@"; tabname; }

# SourceTreeApp
alias sourcetree='open -a SourceTree'

# SickBeard alias
alias sickbeard="python ~/Documents/code/python/Sick-Beard/SickBeard.py"

alias duu="du -sm * |sort -n"

alias v="vagrant"

alias VBoxManage="/Applications/VirtualBox.app/Contents/MacOS/VBoxManage-x86"

alias filemerge="/Applications/Xcode.app/Contents/Applications/FileMerge.app/Contents/MacOS/FileMerge"
export PATH=$PATH:/Applications/acquia-drupal/drush

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
