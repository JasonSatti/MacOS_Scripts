#!/usr/bin/env bash
# Jason Satti

# Get the logged in user
LOGGED_IN_USER=$(/usr/bin/python -c 'from SystemConfiguration import\
 SCDynamicStoreCopyConsoleUser;import sys; username = \
 (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0];username\
 = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write\
 (username + "\n");')

# Name of apps to remove from dock
APPS_TO_REMOVE=(
"Visual Studio Code"
"Chrome"
)

# Remove apps from dock
    for APP_TO_REMOVE in "${APPS_TO_REMOVE[@]}"; do
        DLOC=$(defaults read com.apple.dock persistent-apps | grep file-label | awk "/$APP_TO_REMOVE/  {printf NR}")
        DLOC=$[$DLOC-1]
        sudo -u $LOGGED_IN_USER /usr/libexec/PlistBuddy -c "Delete persistent-apps:$DLOC" ~/Library/Preferences/com.apple.dock.plist
done

# Restart dock
killall Dock
