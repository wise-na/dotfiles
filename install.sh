#!/usr/bin/env bash

# source $HOME/Library/init/utils.sh
source utils.sh

main() {
  # First things first, asking for sudo credentials
  # ask_for_sudo

  # Installing Homebrew, the basis of anything and everything
  install_homebrew

  # Cloning Dotfiles repository for install_packages_with_brewfile
  # to have access to Brewfile
  clone_dotfiles_repo

  # Installing all packages in Dotfiles repository's Brewfile
  install_packages_with_brewfile

  # Configuring git config file
  configure_git
  install_node
  ssh_key_gen

  # Installing typescript so that YouCompleteMe can support it
  # and prettier so that Neoformat can auto-format files
  # yarn_packages=(prettier)
  # yarn_install "${yarn_packages[@]}"

  gem_packages=(bundler mysql2 pg)
  gem_install "${gem_packages[@]}"

  # Setting up macOS defaults
  setup_macOS_defaults
}

DOTFILES_PATH=~/Projects/dotfiles-pull
GITHUB_REPO=https://github.com/bluengreen/dotfiles.git
GITHUB_NAME="Phillip Novess"
GITHUB_USERNAME="bluengreen"
GITHUB_EMAIL="phillip@novess.com"


ssh_key_gen() {
  if [ ! -f "$HOME/.ssh/${GITHUB_USERNAME}_id_rsa" ]; then
    # add prompt for password maybe?
    ssh-keygen -t rsa -N "" -C "$GITHUB_EMAIL" -f $HOME/.ssh/${GITHUB_USERNAME}_id_rsa

    # Start agent in background
    eval "$(ssh-agent -s)"

    # # If OSX 10.12+
    echo 'Host *
     AddKeysToAgent yes
     UseKeychain yes
     IdentityFile $HOME/.ssh/${GITHUB_USERNAME}_id_rsa
    ' >> ~/.ssh/config
  fi
}

install_homebrew() {
  info "Installing Homebrew..."
  if type_exists 'brew'; then
    success "Homebrew already exists."
  else
    url=https://raw.githubusercontent.com/Sajjadhosn/dotfiles/master/installers/homebrew_installer
    if /usr/bin/ruby -e "$(curl -fsSL ${url})"; then
      success "Homebrew installation succeeded."
    else
      error "Homebrew installation failed."
      exit 1
    fi
  fi
}



install_packages_with_brewfile() {
  info "Installing packages within ${DOTFILES_PATH}/Brewfile ..."
  if brew bundle --file=$DOTFILES_PATH/Brewfile; then
    success "Brewfile installation succeeded."
  else
    error "Brewfile installation failed."
    exit 1
  fi
}

configure_git() {
  info "Configuring git..."
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
  info "Pulling latest changes in ${1} repository..."

  if git -C $1 pull origin master &> /dev/null; then
    success "Pull successful in ${1} repository."
  else
    error "Please pull the latest changes in ${1} repository manually."
  fi
}


setup_macOS_defaults() {
  info "Updating macOS defaults..."

  current_dir=$(pwd)
  cd ${DOTFILES_PATH}/
  if bash defaults.sh; then
    cd $current_dir
    success "macOS defaults setup succeeded."
  else
    cd $current_dir
    error "macOS defaults setup failed."
    exit 1
  fi
}


install_node() {
    info "Installing node, npm, nvm ..."
    # Install NODE
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

    # install stable version of node
    nvm install stable

    # set default node version
    nvm alias default stable

    # update npm
    npm install -g npm@latest
    npm install -g organize-cli
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
    echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
    packages_to_install=("$@")

    for package_to_install in "${packages_to_install[@]}"
    do
        info "gem install ${package_to_install}"
        if gem list "$package_to_install" --quiet; then
            success "${package_to_install} already exists."
        else
            if gem install "$package_to_install"; then
                success "Package ${package_to_install} installation succeeded."
            else
                error "Package ${package_to_install} installation failed."
                exit 1
            fi
        fi
    done
}


main "$@"