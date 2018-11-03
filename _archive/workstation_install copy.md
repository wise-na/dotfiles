# Dev Workstation Setup - 10.14.1
# These instructions are for Mac OSX 10.14.1 El Capitan. Following these instructions will prepare your workstation for developing in Ruby on Rails, node, aws.
#
# Mac OS X 10.14 Mojave installation steps
#

# make the ~/Library directory visible so we can move bbedit customizations into it
chflags nohidden ~/Library/

# make directories for our projects
mkdir -p ~/Projects/shared/

# install xcode - needed for compilers and command line tools
# **this requires an apple developer account
# use the App Store app
xcode-select --install

# install homebrew - http://brew.sh/
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# check brew config
brew doctor

# update brew
brew update
brew install wget
brew install git git-extras bash-completion

# install these for compatibility with older versions of ruby < 2
brew install autoconf automake

# configure git
git config --global color.ui true
git config --global core.editor bbedit
git config --global color.branch auto
git config --global color.diff auto
git config --global color.status auto
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# create new github account for user @ http://github.com
# or add key to existing github account
# create keys for new computer / user
ssh-keygen -t rsa -C "<your_email_username>@yourdomain.com"
pbcopy < ~/.ssh/id_rsa.pub

# Start agent in background
eval "$(ssh-agent -s)"

# If OSX 10.12+
echo 'Host *
 AddKeysToAgent yes
 UseKeychain yes
 IdentityFile ~/.ssh/id_rsa
' >> ~/.ssh/config

# Add to local keys
ssh-add -K ~/.ssh/id_rsa

# copy key to clipboard
pbcopy < ~/.ssh/id_rsa.pub

# Add key on github
open https://github.com/settings/keys

# copy keys user account @ http://github.com
# https://help.github.com/articles/generating-ssh-keys

# install services - mysql, postgres, memcached, redis, kafka, rabbitmq
brew install mysql
brew install postgresql
brew install memcached
brew install ghostscript imagemagick redis mongodb rabbitmq

# start services
brew services start postgresql
brew services start mysql

# set mysql root db password
# if you want to set mysql root password (optional)
mysqladmin -u root password NEWPASSWORD

# optional
brew install pgcli

# install hub
brew install hub
brew install coreutils

# install RVM and rubies
brew install gnupg gnupg2
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L https://get.rvm.io | bash -s stable --ruby

# !! RELOAD terminal
#
# install rubies
rvm install 2.3.6
rvm install 2.3.7

# use this ruby as default and create gemset
rvm use 2.3.7@efault --create --default


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

cat <<- 'ENDOFMESSAGE' > ~/.bash_profile

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
export PATH=$PATH:/usr/local/mysql/bin:/usr/local/share/npm/bin
export PATH=$PATH:$HOME/.rvm/gems/ruby-2.1.1/bin:$HOME/.rvm/gems/ruby-2.1.1@sysdefault/bin:$HOME/.rvm/rubies/ruby-2.1.1/bin:$HOME/.rvm/bin

#############################################
# RVM - for managing versions of ruby
#############################################
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

ENDOFMESSAGE

###########
# prevent gems from installing docs
echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

# install gems
gem install bundler
gem install mysql2
gem install pg

# Install NODE

# install NVM
# brew install nvm
# source $(brew --prefix nvm)/nvm.sh
# echo "source $(brew --prefix nvm)/nvm.sh" >> ~/.bash_profile

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

# add lines to .bash_profile to load on new shell window
echo "export NVM_DIR=~/.nvm; source ~/.nvm/nvm.sh" >> ~/.bash_profile

# install stable version of node
nvm install stable

# set default node version
nvm alias default stable

# update npm
npm install -g npm@latest


# additional installs

## media tools ffmpeg
brew install ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-libass --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x265 --with-openh264


# aws tools
brew install awscli amazon-ecs-cli chamber
brew install terraform
brew install s3cmd

# data tools

brew cask install homebrew/cask-versions/java8
brew install kafka


# configure aws profiles

# copy ssh config


# add bbedit config

cp /Volumes/pnovess/Library/Preferences/com.barebones.bbedit.plist ~/Library/Preferences/com.barebones.bbedit.plist

cp -R /Volumes/pnovess/Library/BBEdit ~/Library/BBEdit
cp -R /Volumes/pnovess/Library/Application\ Support/BBEdit/  ~/Library/Application\ Support/BBEdit/
