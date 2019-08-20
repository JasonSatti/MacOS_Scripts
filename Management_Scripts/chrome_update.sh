#!/usr/bin/env bash
# Verify Chrome Version
# Jason Satti

# Get the latest version of Google Chrome and compare to installed version
# If up to date just exit, else; install the latest version of Google Chrome
# Prompt user to restart for update to take affect

# Get the version of Google Chrome that is installed
chrome_installed=$(/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version |
    awk '{print $3}')

# Get the latest version of Google Chrome
chrome_latest=$(curl https://www.whatismybrowser.com/guides/the-latest-version/chrome |
    grep -A1 "Chrome on <strong>macOS</strong>" | tail -n1 | sed -e 's/[A-Za-z</>]*//g' |
    sed -e 's/^[ \t]*//')

# If the latest version is downloaded and installed, exit.
if [ "$chrome_installed" == "$chrome_latest" ]; then
    echo "Latest version of Google Chrome is installed."
    exit 0
fi

# If Google Chrome is out of date, download and install the latest version
echo "Google Chrome is out of date"
echo "Installed version: $chrome_installed (Latest version: $chrome_latest)"
echo "Updating Chrome"

# Link to download the latest Google Chrome
chrome_download="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"

# Name of the DMG file that will be downloaded
chrome_dmg=$(echo $chrome_download | cut -f8 -d'/')

# Download the latest version of Google Chrome into /tmp/
curl -s $chrome_download -o /tmp/"$chrome_dmg"

# Mount the DMG
hdiutil attach /tmp/"$chrome_dmg" -nobrowse

# Copy contents of the Google Chrome DMG file to /Applications/
cp -pPR /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/

# Get the Volume Name
chrome_volume=$(hdiutil info | grep "/Volumes/Google Chrome" | awk '{ print $1 }')

# Unmount the Volume
hdiutil detach "$chrome_volume"

# Remove the DMG
rm -f /tmp/"$chrome_dmg"

# Get the logged in user
logged_in_user=$(/usr/bin/python -c 'from SystemConfiguration import\
 SCDynamicStoreCopyConsoleUser;import sys; username = \
 (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0];username\
 = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write\
 (username + "\n");')

# Inform user that restart is required for changes to take affect
su -l "$logged_in_user" -c "/usr/local/bin/yo_scheduler -t 'Google Chrome Updated' --info 'Google Chrome needs to be restarted so the update can take affect.'"
