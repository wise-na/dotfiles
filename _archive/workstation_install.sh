#!/bin/bash

# Dev Workstation Setup - 10.14.1
# These instructions are for Mac OSX 10.14.1 El Capitan. Following these instructions will prepare your workstation for developing in Ruby on Rails, node, # aws.
#
# Mac OS X 10.14 Mojave installation steps
#

#
# Brew it
#

# include functions
# . utils.sh
#
# # set mac defaults
# bash defaults.sh
#
# # make the ~/Library directory visible so we can move bbedit customizations into it
# chflags nohidden ~/Library/
#
# # make directories for our projects
# mkdir -p ~/Projects/shared/
#
#

###################
# create and edit .bash_profile for your environment
# !!
# copy everything from the line that starts with cat
# and ends with ENDOFMESSAGE
#
# paste it into your terminal and hit enter
# that will effectively create your bash profile
#
###################
#
# cat <<- 'ENDOFMESSAGE' > ~/.bash_profile
#
# #############################################
# # GIT completions & highlighted prompt
# #############################################
# if [ -f `brew --prefix`/etc/bash_completion ]; then
# . `brew --prefix`/etc/bash_completion
# fi
#
# GIT_PS1_SHOWDIRTYSTATE=true
# PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[36m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
#
# #############################################
# # Bash ls colors
# #############################################
# export CLICOLOR=1
# export LSCOLORS=DxGxcxdxCxegedabagacad
#
# #############################################
# # alias
# #############################################
# alias ll='ls -l'
# alias la='ls -la'
#
# ########
# ## git
# alias g='git status'
# alias gg='git log'
# alias gst='git status'
# alias gb='git branch'
# alias gba='git branch -a'
# alias gc='git commit -v'
# alias gca='git commit -v -a'
# alias gce="git commit --amend" # fix last commit message
# alias gco='git checkout'
# alias gd='git diff | bbedit'
# alias gdm='git diff master'
# alias gl='git pull'
# alias gp='git push'
#
# #############################################
# # update path for mysql
# #############################################
# export PATH=$PATH:/usr/local/mysql/bin:/usr/local/share/npm/bin
# export PATH=$PATH:$HOME/.rvm/gems/ruby-2.1.1/bin:$HOME/.rvm/gems/ruby-2.1.1@sysdefault/bin:$HOME/.rvm/rubies/ruby-2.1.1/bin:$HOME/.rvm/bin
#
# #############################################
# # RVM - for managing versions of ruby
# #############################################
# [[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
#
# ENDOFMESSAGE




# # Install NODE
# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
#
# # add lines to .bash_profile to load on new shell window
# echo "export NVM_DIR=~/.nvm; source ~/.nvm/nvm.sh" >> ~/.bash_profile
#
# # install stable version of node
# nvm install stable
#
# # set default node version
# nvm alias default stable
#
# # update npm
# npm install -g npm@latest



# copy files
# add bbedit config
cp /Volumes/pnovess/Library/Preferences/com.barebones.bbedit.plist ~/Library/Preferences/com.barebones.bbedit.plist
cp -R /Volumes/pnovess/Library/BBEdit ~/Library/BBEdit
cp -R /Volumes/pnovess/Library/Application\ Support/BBEdit/  ~/Library/Application\ Support/BBEdit/
