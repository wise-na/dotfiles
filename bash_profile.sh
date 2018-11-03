
#############################################
# GIT completions & highlighted prompt
#############################################
if [ -f `brew --prefix`/etc/bash_completion ]; then
. `brew --prefix`/etc/bash_completion
fi

GIT_PS1_SHOWDIRTYSTATE=true
PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[36m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '

#############################################
# Bash ls colors
#############################################
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad

#############################################
# alias
#############################################
alias ll='ls -l'
alias la='ls -la'

########
## git
alias g='git status'
alias gg='git log'
alias gst='git status'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gce="git commit --amend" # fix last commit message
alias gco='git checkout'
alias gd='git diff | bbedit'
alias gdm='git diff master'
alias gl='git pull'
alias gp='git push'

#############################################
# update path for mysql
#############################################
# export PATH=$PATH:/usr/local/mysql/bin:/usr/local/share/npm/bin
# export PATH=$PATH:$HOME/.rvm/gems/ruby-2.1.1/bin:$HOME/.rvm/gems/ruby-2.1.1@sysdefault/bin:$HOME/.rvm/rubies/ruby-2.1.1/bin:$HOME/.rvm/bin
export PATH="$PATH:$HOME/.rvm/bin"

#############################################
# RVM - for managing versions of ruby
#############################################
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
