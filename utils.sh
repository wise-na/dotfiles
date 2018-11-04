#!/bin/bash


ask_for_sudo() {
  info "Prompting for sudo password..."
  if sudo --validate; then
    # Keep-alive
    while true; do sudo --non-interactive true; \
        sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
  else
    error "Obtaining sudo credentials failed."
    exit 1
  fi
}

coloredEcho() {
  local exp="$1";
  local color="$2";
  local arrow="$3";
  if ! [[ $color =~ '^[0-9]$' ]] ; then
     case $(echo $color | tr '[:upper:]' '[:lower:]') in
      black) color=0 ;;
      red) color=1 ;;
      green) color=2 ;;
      yellow) color=3 ;;
      blue) color=4 ;;
      magenta) color=5 ;;
      cyan) color=6 ;;
      white|*) color=7 ;; # white or invalid color
     esac
  fi
  tput bold;
  tput setaf "$color";
  echo "$arrow $exp";
  tput sgr0;
}

info() {
  coloredEcho "$1" blue "========>"
}

substep() {
  coloredEcho "$1" magenta "===="
}

success() {
  coloredEcho "$1" green "========>"
}

error() {
  coloredEcho "$1" red "========>"
}


##################################################################

#
# Set Colors
#

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

#
# Headers and  Logging
#

e_header() {
  printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@"
}

e_arrow() {
  printf "➜ $@\n"
}

e_success() {
  printf "${green}✔ %s${reset}\n" "$@"
}

e_error() {
  printf "${red}✖ %s${reset}\n" "$@"
}

e_warning() {
  printf "${tan}➜ %s${reset}\n" "$@"
}

e_underline() {
  printf "${underline}${bold}%s${reset}\n" "$@"
}

e_bold() {
  printf "${bold}%s${reset}\n" "$@"
}

e_note() {
  printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"
}

#
# USAGE FOR SEEKING CONFIRMATION
# seek_confirmation "Ask a question"
# Credt: https://github.com/kevva/dotfiles
#
# if is_confirmed; then
#   some action
# else
#   some other action
# fi
#

seek_confirmation() {
  printf "\n${bold}$@${reset}"
  read -p " (y/n) " -n 1
  printf "\n"
}

# underlined
seek_confirmation_head() {
  printf "\n${underline}${bold}$@${reset}"
  read -p "${underline}${bold} (y/n)${reset} " -n 1
  printf "\n"
}

# Test whether the result of an 'ask' is a confirmation
is_confirmed() {
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

#
# Test whether a command exists
# $1 = cmd to test
# Usage:
# if type_exists 'git'; then
#   some action
# else
#   some other action
# fi
#
type_exists() {
  if [ $(type -P $1) ]; then
    return 0
  fi
  return 1
}

#
# Test which OS the user runs
# $1 = OS to test
# Usage: if is_os 'darwin'; then
#
is_os() {
  if [[ "${OSTYPE}" == $1* ]]; then
    return 0
  fi
  return 1
}

# mkdir and enter it
function mk() {
  mkdir -p "$@" && cd "$@"
}

#
# Given a list of desired items and installed items, return a list
# of uninstalled items. Arrays in bash are insane (not in a good way).
# Credit: https://github.com/cowboy/dotfiles
#


# list=$(awk 'NR==FNR{a[$0];next}!($0 in a)' <(echo "$2") <(echo "$1" | xargs -n1) | sort)

to_install() {
  list=$(awk 'NR==FNR{a[$0];next}!($0 in a)' <(echo "$2") <(echo "$1" | xargs -n1) | sort)
  #
  # local debug desired installed i desired_s installed_s remain
  # if [[ "$1" == 1 ]]; then debug=1; shift; fi
  #
  # # Convert args to arrays, handling both space- and newline-separated lists.
  # read -ra desired <<(echo "$1" | tr '\n' ' ')
  # read -ra installed <<(echo "$2" | tr '\n' ' ')
  #
  # # Sort desired and installed arrays.
  # unset i; while read -r; do desired_s[i++]=$REPLY; done <<(
  #   printf "%s\n" "${desired[@]}" | sort
  # )
  #
  # unset i; while read -r; do installed_s[i++]=$REPLY; done <<(
  #   printf "%s\n" "${installed[@]}" | sort
  # )
  #
  # # Get the difference. comm is awesome.
  # unset i; while read -r; do remain[i++]=$REPLY; done <<(
  #   comm -13 <(printf "%s\n" "${installed_s[@]}") <(printf "%s\n" "${desired_s[@]}")
  # )
  #
  # [[ "$debug" ]] && for v in desired desired_s installed installed_s remain; do
  #   echo "$v ($(eval echo "\${#$v[*]}")) $(eval echo "\${$v[*]}")"
  # done
  # echo "${remain[@]}"
  echo "${list[@]}"
}

# <doc:truth> {{{
#
# Determine the "truthiness" of the given value.
#
# Usage examples:
#     truth True   #==> true
#     truth        #==> false
#     truth 1      #==> true
#     truth false  #==> false
#     truth on     #==> true
#     truth spam   #==> false
#
# </doc:truth> }}}
truth()
{
    case $(lower <<<"$1") in
        yes|y|true|t|on|1) return 0 ;;
    esac
    return 1
}

# <doc:truth_echo> {{{
#
# Depending on the "truthiness" of the given value, echo the first (true)
# or second (false) value.
#
#  truth_echo "$1" 1 0
#
#
# </doc:truth_echo> }}}
truth_echo()
{
    if truth "$1"; then
        [[ $2 ]] && echo "$2"
    else
        [[ $3 ]] && echo "$3"
    fi
}
