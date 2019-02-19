#!/usr/bin/env bash

DOTFILES_PATH=$HOME/.dotfiles
GITHUB_REPO=https://github.com/bluengreen/dotfiles.git
GITHUB_NAME="Phillip Novess"
GITHUB_USERNAME="bluengreen"
GITHUB_EMAIL="phillip@novess.com"

# source $HOME/Library/init/utils.sh
source "${DOTFILES_PATH}/utils.sh"

main() {
  # Cloning Dotfiles repository for install_packages_with_brewfile
  # to have access to Brewfile
  # clone_dotfiles_repo
  # splash

  # First things first, asking for sudo credentials
  ask_for_sudo

  # Installing Homebrew, the basis of anything and everything
  install_homebrew

  # Installing all packages in Dotfiles repository's Brewfile
  install_packages_with_brewfile

  # Configure and install apps and packages
  ssh_key_gen
  configure_git
  set_mac_defaults

  # install rvm & ruby
  install_rvm

  # install apps and packages
  install_node
	
  # Installing typescript so that YouCompleteMe can support it
  # and prettier so that Neoformat can auto-format files
  # yarn_packages=(prettier)
  # yarn_install "${yarn_packages[@]}"

  gem_packages=(bundler mysql2 pg devise)
  gem_install "${gem_packages[@]}"
  
  bash_profile_install

}

ssh_key_gen() {
  e_header "Generating SSH key"
  if [ -f "$HOME/.ssh/${GITHUB_USERNAME}_id_rsa" ]; then
    e_arrow "Key already exists."
  else
    # add prompt for password maybe?
    ssh-keygen -t rsa -N "" -C "$GITHUB_EMAIL" -f $HOME/.ssh/${GITHUB_USERNAME}_id_rsa

    # Start agent in background
    eval "$(ssh-agent -s)"

    # # If OSX 10.12+
    echo 'Host *
     AddKeysToAgent yes
     UseKeychain yes
     IdentityFile $HOME/.ssh/${GITHUB_USERNAME}_id_rsa
    ' >> $HOME/.ssh/config
  fi
}

install_packages_with_brewfile() {
  e_header "Installing packages within ${DOTFILES_PATH}/Brewfile ..."
  if brew bundle --file=$DOTFILES_PATH/Brewfile; then
    success "Brewfile installation succeeded."
  else
    error "Brewfile installation failed."
    exit 1
  fi
}

configure_git() {
  e_header "Configuring git..."
  # configure git
  if git config --global color.ui true && \
     git config --global core.editor bbedit && \
     git config --global color.branch auto && \
     git config --global color.diff auto && \
     git config --global color.status auto && \
     git config --global user.email "$GITHUB_EMAIL" && \
     git config --global user.name "$GITHUB_NAME"; then
       success "git configuration succeeded."
  else
     error "git configuration failed."
  fi
}

clone_dotfiles_repo() {
  e_header "Cloning dotfiles repository into ${DOTFILES_PATH} ..."

  if test -e $DOTFILES_PATH; then
    substep "${DOTFILES_PATH} already exists."
    pull_latest $DOTFILES_PATH
  else
    if git clone "$GITHUB_REPO" $DOTFILES_PATH; then
      success "Cloned into ${DOTFILES_PATH}"
    else
      error "Cloning into ${DOTFILES_PATH} failed."
      exit 1
    fi
  fi
}

pull_latest() {
  e_header "Pulling latest changes in ${1} repository..."

  if git -C $1 pull origin master &> /dev/null; then
    success "Pull successful in ${1} repository."
  else
    error "Please pull the latest changes in ${1} repository manually."
  fi
}


set_mac_defaults() {
  e_header "Updating macOS defaults..."

  current_dir=$(pwd)
  cd ${DOTFILES_PATH}/
  if bash mac_defaults.sh; then
    cd $current_dir
    success "macOS defaults setup succeeded."
  else
    cd $current_dir
    error "macOS defaults setup failed."
    exit 1
  fi
}

install_rvm() {
    e_header "Installing rvm ..."

    if ! type_exists 'rvm'; then
      # install gpg
      gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

      # Install NODE
      curl -sSL https://get.rvm.io | bash

      source ~/.rvm/scripts/rvm
      source ~/.bash_profile             
    else
       e_arrow "Nothing to install. You've already got them all."
    fi
    
    # install stable version of node
    rvm install 2.3.2 --default 
}

install_node() {
    e_header "Installing node, npm, nvm ..."

    if ! type_exists 'node'; then
      # Install NODE
      curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
	  
	  source ~/.bashrc
	  
      # install stable version of node
      nvm install stable

      # set default node version
      nvm alias default stable

      # update npm
      npm install -g npm@latest
      npm install -g organize-cli
    else
       e_arrow "Nothing to install. You've already got them all."
    fi
}

yarn_install() {
    packages_to_install=("$@")

    for package_to_install in "${packages_to_install[@]}"
    do
        info "yarn global add ${package_to_install}"
        if yarn global list | grep "$package_to_install" &> /dev/null; then
            success "${package_to_install} already exists."
        else
            if yarn global add "$package_to_install"; then
                success "Package ${package_to_install} installation succeeded."
            else
                error "Package ${package_to_install} installation failed."
                exit 1
            fi
        fi
    done

}

gem_install() {
    packages_to_install=("$@")

    echo 'gem: --no-rdoc --no-ri' >> $HOME/.gemrc
    e_header "install gem Packages"

    list="$(to_install "${packages_to_install[*]}" "$(gem list | awk '{print $1}')")"
    echo $list

    if [[ "$list" ]]; then
        for item in ${list[@]}
        do
            gem install $item
        done
    else
        e_arrow "Nothing to install. You've already got them all."
    fi
}

bash_profile_install() {
	e_header "Update bash_profile..."
	cat ~/.dotfiles/bash_profile.sh > ~/.bash_profile
	
	source ~/.bash_profile
	
	success "bash_profile installation succeeded."
	
	
}

main "$@"
