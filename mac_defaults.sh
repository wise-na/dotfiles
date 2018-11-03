#!/usr/bin/env bash

main() {
    # configure_plist_apps # Configure all apps whose configurations are plists
    configure_finder
    configure_system
}

configure_system() {
    # Disable Gatekeeper entirely to get rid of \
    # “Are you sure you want to open this application?” dialog
    sudo spctl --master-disable

    # make the ~/Library directory visible
    chflags nohidden "${HOME}/Library/"

    # make directories for our projects
    mkdir -p "${HOME}/Projects/shared/"
}

configure_finder() {
    # Save screenshots to Downloads folder
    defaults write com.apple.screencapture location -string "${HOME}/Downloads"
    # Require password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    # allow quitting via ⌘ + q; doing so will also hide desktop icons
    # defaults write com.apple.finder QuitMenuItem -bool true
    # disable window animations and Get Info animations
    # defaults write com.apple.finder DisableAllAnimations -bool true
    # Set Downloads as the default location for new Finder windows
    defaults write com.apple.finder NewWindowTarget -string "PfLo"
    defaults write com.apple.finder NewWindowTargetPath -string \
        "file://${HOME}/Downloads/"
    # disable status bar
    defaults write com.apple.finder ShowStatusBar -bool false
    # disable path bar
    defaults write com.apple.finder ShowPathbar -bool false
    # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
    # Keep folders on top when sorting by name
    # defaults write com.apple.finder _FXSortFoldersFirst -bool true
    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    # Disable disk image verification
    # defaults write com.apple.frameworks.diskimages \
    #     skip-verify -bool true
    # defaults write com.apple.frameworks.diskimages \
    #     skip-verify-locked -bool true
    # defaults write com.apple.frameworks.diskimages \
    #     skip-verify-remote -bool true
    # Use list view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    # Disable the warning before emptying the Trash
    # defaults write com.apple.finder WarnOnEmptyTrash -bool false
}

quit() {
    app=$1
    killall "$app" > /dev/null 2>&1
}


# link_files(){
#   # cp /Volumes/pnovess/Library/Preferences/com.barebones.bbedit.plist ~/Library/Preferences/com.barebones.bbedit.plist
#   # cp -R /Volumes/pnovess/Library/BBEdit ~/Library/BBEdit
#   # cp -R /Volumes/pnovess/Library/Application\ Support/BBEdit/  ~/Library/Application\ Support/BBEdit/
# }


main "$@"
