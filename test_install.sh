#!/bin/bash

source utils.sh


function gem_install() {
  packages_to_install=("$@")

  e_header "install gem Packages"
  list="$(to_install "${packages_to_install[*]}" "$(gem list | awk '{print $1}')")"
  if [[ "$list" ]]; then
    for item in ${list[@]}
    do
      echo "$item is not on the list"
      gem install $item
    done
  else
    e_arrow "Nothing to install. You've already got them all."
  fi
}

gem_packages=(bundler mysql2 pg)
gem_install "${gem_packages[@]}"
