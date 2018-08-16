#!/usr/bin/env bash
## Local Password Change Reminder
## Dakr-xv

## Get the username of the logged in user and the current date
## Apple approved way to get the currently logged in user
LOGGED_IN_USER=`/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys;\
 username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0];\
 username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
CURRENT_DATE=`date +%s`

## Get the date that the password was set on in seconds ##
PW_DATE_FLOAT=$(dscl . read /Users/$LOGGED_IN_USER | grep -A 1 passwordLastSetTime | grep -Eo '[0-9.]+')
PW_DATE_SET=`echo "$PW_DATE_FLOAT/1" | bc`

## How many seconds has the current password been active ##
DAYS_SECONDS=$(($CURRENT_DATE-$PW_DATE_SET))

## How many days has the current password been active ##
DAYS_SET=`echo "$DAYS_SECONDS/86400"| bc`

## Days left till password will expire ##
MAX_PW_AGE=182
PW_REMAINING_DAYS=$(($MAX_PW_AGE - $DAYS_SET))

## Exit if Password was recently updated ##
if [ $PW_REMAINING_DAYS -gt "177" ]; then
    echo "Password was already updated. Exiting script."
    exit 0;
fi

## Notify the user that their password will expire in X day(s)
DIALOG="Macbook Login Password Expiration."
TEXT="Password will expire in $PW_REMAINING_DAYS day(s)."

## We use Yo Notification - https://github.com/sheagcraig/yo 
yo_scheduler -t "$DIALOG" -s "$TEXT" -o "Postpone" -b "Update" -B "open /System/Library/PreferencePanes/Accounts.prefPane/"