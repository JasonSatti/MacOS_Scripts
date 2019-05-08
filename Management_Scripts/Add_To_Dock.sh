#!/usr/bin/env bash
# Jason Satti

# Get the logged in user
LOGGED_IN_USER=$(/usr/bin/python -c 'from SystemConfiguration import\
 SCDynamicStoreCopyConsoleUser;import sys; username = \
 (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0];username\
 = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write\
 (username + "\n");')

# Path of apps to add to dock
APPS_TO_ADD=(
"/Applications/Visual Studio Code.app"
)

# Add apps to dock
for APP_TO_ADD in "${APPS_TO_ADD[@]}"; do
    sudo -u "$LOGGED_IN_USER" defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$APP_TO_ADD</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
done

# Restart dock
killall Dock
