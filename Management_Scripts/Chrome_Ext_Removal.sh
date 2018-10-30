#!/usr/bin/env bash
## Remove an extenstion for Chrome that is installed on a device
## Dakr-xv

## List of extentions to check in all Chrome user profiles
EXTENSIONS=("mdanidgdpmkimeiiojknlnekblgmpdll") 

## Message for user when they are out of compliance
MSG_TITLE='Boomerang Extension Disabled'
MSG_NOTICE='No longer permitted.'

## Get the logged in user
LOGGED_IN_USER=$(/usr/bin/python -c 'from SystemConfiguration import\
 SCDynamicStoreCopyConsoleUser;import sys; username = \
 (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0];username\
 = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write\
 (username + "\n");')

IFS=$'\n' ## This cmd allows for the bash shell to recognize the whitespace in a
## string and not require a line split

## Chrome Directory
DIRECTORY="/Users/$LOGGED_IN_USER/Library/Application Support/Google/Chrome"

## Get a list of all Chrome profiles on the device
PROFILES=$(ls "$DIRECTORY" | grep "Profile " )

## Full path to Yo Scheduler
YO='/usr/local/bin/yo_scheduler'

## Check Default Profile and ALL User Profiles
for PRF in $PROFILES; do 
    for EXT in "${EXTENSIONS[@]}"; do
        if [[ ( -d "$DIRECTORY/Default/Extensions/$EXT" ) ||\
         ( -d "$DIRECTORY/$PRF/Extensions/$EXT" )]]; then 
            rm -rf "$DIRECTORY/Default/Extensions/$EXT"
            rm -rf "$DIRECTORY/$PRF/Extensions/$EXT"   
        fi
    done;
done;

## Send User Removal Notification
su -l "$LOGGED_IN_USER" -c ""$YO" -t '$MSG_TITLE' -s '$MSG_NOTICE'
