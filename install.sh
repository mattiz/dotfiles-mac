#!/bin/sh

########################
### Install software ###
########################

brew tap FelixKratz/formulae
brew install borders


#####################
### Link dotfiles ###
#####################

ln -swf $HOME/.dotfiles/sketchybar $HOME/.config/sketchybar
ln -swf $HOME/.dotfiles/aerospace $HOME/.config/aerospace
ln -swf $HOME/.dotfiles/ghostty $HOME/.config/ghostty


####################
### Mac settings ###
####################

# Turn off "Displays have separate Spaces"
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer

# Turn off Dock delay
defaults write com.apple.dock autohide-delay -float 0; defaults write com.apple.dock autohide-time-modifier -int 0;killall Dock

# Turn off "Click wallpaper to reveal desktop"
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false


# Remap Home and End keys
mkdir -p $HOME/Library/KeyBindings
echo '{
/* Remap Home / End keys to be correct */
"\UF729" = "moveToBeginningOfLine:"; /* Home */
"\UF72B" = "moveToEndOfLine:"; /* End */
"$\UF729" = "moveToBeginningOfLineAndModifySelection:"; /* Shift + Home */
"$\UF72B" = "moveToEndOfLineAndModifySelection:"; /* Shift + End */
"^\UF729" = "moveToBeginningOfDocument:"; /* Ctrl + Home */
"^\UF72B" = "moveToEndOfDocument:"; /* Ctrl + End */
"$^\UF729" = "moveToBeginningOfDocumentAndModifySelection:"; /* Shift + Ctrl + Home */
"$^\UF72B" = "moveToEndOfDocumentAndModifySelection:"; /* Shift + Ctrl + End */
}' > $HOME/Library/KeyBindings/DefaultKeyBinding.dict
