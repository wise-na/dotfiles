#!/bin/bash

source utils.sh

#
# gem_install() {
#   packages_to_install=("$@")
#
#   e_header "install gem Packages"
#
#   list="$(to_install "${packages_to_install[*]}" "$(gem list | awk '{print $1}')")"
#
#   if [[ "$list" ]]; then
#     for item in ${list[@]}
#     do
#       echo "$item is not on the list"
#       gem install $item
#     done
#   else
#     e_arrow "Nothing to install. You've already got them all."
#   fi
#
# }



install_node() {
    e_header "Installing node, npm, nvm ..."

    if ! type_exists 'node'; then
      # Install NODE
      curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

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


install_node


gem_install() {
    packages_to_install=("$@")

    echo 'gem: --no-rdoc --no-ri' >> $HOME/.gemrc
    e_header "install gem Packages"

    list="$(to_install "${packages_to_install[*]}" "$(gem list | awk '{print $1}')")"

    if [[ "$list" ]]; then
        for item in ${list[@]}
        do
            gem install $item
        done
    else
        e_arrow "Nothing to install. You've already got them all."
    fi
}


gem_packages=(bundler mysql2 pg)
gem_install "${gem_packages[@]}"
