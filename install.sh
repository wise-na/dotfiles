#!/usr/bin/env bash

DOTFILES_PATH=$HOME/.dotfiles
GITHUB_REPO=https://github.com/bluengreen/dotfiles.git
GITHUB_NAME="Phillip Novess"
GITHUB_USERNAME="bluengreen"
GITHUB_EMAIL="phillip@novess.com"

main() {
  # Cloning Dotfiles repository for install_packages_with_brewfile
  # to have access to Brewfile
  clone_dotfiles_repo
  # bash "${DOTFILES_PATH}/main.sh"
}

clone_dotfiles_repo() {
  echo "Cloning dotfiles repository into ${DOTFILES_PATH} ..."

  if test -e $DOTFILES_PATH; then
    echo "${DOTFILES_PATH} already exists."
    pull_latest $DOTFILES_PATH
  else
    if git clone "$GITHUB_REPO" $DOTFILES_PATH; then
      echo "Cloned into ${DOTFILES_PATH}"
    else
      error "Cloning into ${DOTFILES_PATH} failed."
      exit 1
    fi
  fi
}

pull_latest() {
  echo "Pulling latest changes in ${1} repository..."

  if git -C $1 pull origin master &> /dev/null; then
    echo "Pull successful in ${1} repository."
  else
    echo "Please pull the latest changes in ${1} repository manually."
  fi
}


main "$@"
