#!/usr/bin/env bash

# source $HOME/Library/init/utils.sh
source utils.sh

main() {
    # First things first, asking for sudo credentials
    ask_for_sudo

    # Installing Homebrew, the basis of anything and everything
    install_homebrew

    # Cloning Dotfiles repository for install_packages_with_brewfile
    # to have access to Brewfile
    # clone_dotfiles_repo

    # Installing all packages in Dotfiles repository's Brewfile
    install_packages_with_brewfile

    # Configuring git config file
    configure_git
    generate_key
    install_node

    # Installing typescript so that YouCompleteMe can support it
    # and prettier so that Neoformat can auto-format files
    # yarn_packages=(prettier)
    # yarn_install "${yarn_packages[@]}"

    gem_packages=(bundler mysql2 pg)
    gem_install "${gem_packages[@]}"

    # Setting up macOS defaults
    # defaults

}

DOTFILES_REPO=~/Projects/dotfiles
GITHUB_REPO=https://github.com/bluengreen/dotfiles.git
GITHUB_NAME="Phillip Novess"
GITHUB_EMAIL="phillip@novess.com"


function install_homebrew() {
    info "Installing Homebrew..."
    if hash brew 2>/dev/null; then
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

function install_packages_with_brewfile() {
    info "Installing packages within ${DOTFILES_REPO}/Brewfile ..."
    if brew bundle --file=$DOTFILES_REPO/Brewfile; then
        success "Brewfile installation succeeded."
    else
        error "Brewfile installation failed."
        exit 1
    fi
}

function configure_git() {
    info "Configuring git..."
    # configure git
    if git config --global color.ui true && \
       git config --global core.editor bbedit && \
       git config --global color.branch auto && \
       git config --global color.diff auto && \
       git config --global color.status auto && \
       git config --global user.email "$EMAIL" && \
       git config --global user.name "$USERNAME"; then
         success "git configuration succeeded."
    else
       error "git configuration failed."
    fi
}

function clone_dotfiles_repo() {
    info "Cloning dotfiles repository into ${DOTFILES_REPO} ..."
    if test -e $DOTFILES_REPO; then
        substep "${DOTFILES_REPO} already exists."
        pull_latest $DOTFILES_REPO
    else
        if git clone "$REPO" $DOTFILES_REPO; then
            success "Cloned into ${DOTFILES_REPO}"
        else
            error "Cloning into ${DOTFILES_REPO} failed."
            exit 1
        fi
    fi
}


function install_node() {
    info "Installing node, npm, nvm ..."
    # Install NODE
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

    # add lines to .bash_profile to load on new shell window
    echo "export NVM_DIR=~/.nvm; source ~/.nvm/nvm.sh" >> ~/.bash_profile

    # install stable version of node
    nvm install stable

    # set default node version
    nvm alias default stable

    # update npm
    npm install -g npm@latest
    npm install -g organize-cli
}

function pull_latest() {
    info "Pulling latest changes in ${1} repository..."
    if git -C $1 pull origin master &> /dev/null; then
        success "Pull successful in ${1} repository."
    else
        error "Please pull the latest changes in ${1} repository manually."
    fi
}

function setup_macOS_defaults() {
    info "Updating macOS defaults..."

    current_dir=$(pwd)
    cd ${DOTFILES_REPO}/
    if bash defaults.sh; then
        cd $current_dir
        success "macOS defaults setup succeeded."
    else
        cd $current_dir
        error "macOS defaults setup failed."
        exit 1
    fi
}

function yarn_install() {
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

function gem_install() {
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
