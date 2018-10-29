#!/usr/bin/env bash
## Set Screen Idle Time if it is out of scope
## Dakr-xv

VIOLATION_LOG="set_idletime.log" ## Where to store violation count and run dates
MAX_TIME=$((5 * 60)) ## 5 minutes
DEFAULT_TIME=$((5 * 60)) ## The preferred Idle Time is 5 minutes.

## Message for user when they are out of compliance
MSG_TITLE='Screensaver Policy Violation'
MSG_NOTICE='Screensaver time reset to 5 min.'
MSG_INFO='The maximum allowed time is 5 min.'

## Get the logged in user
LOGGED_IN_USER=$(/usr/bin/python -c 'from SystemConfiguration import\
 SCDynamicStoreCopyConsoleUser;import sys; username = \
 (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0];username\
 = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write\
 (username + "\n");')

## The screen saver preferences file
SAVER_PREFS="/Users/$LOGGED_IN_USER/Library/Preferences/ByHost/com.apple.screensaver"
SAVER_SETTING='idleTime' ## the specific setting that we're interested in

## Get the Current Idle Time setting
IDLE_TIME="$(sudo -u $LOGGED_IN_USER /usr/bin/defaults -currentHost read $SAVER_PREFS $SAVER_SETTING)"

## Set veriables for violation tracking
VIOLATION_COUNT=0
LATEST_DATE="$(date +'%F %R')"

## If the log file exists, retrieve current counter
if [ -f $VIOLATION_LOG ]; then
    VIOLATION_COUNT=$(head -1 $VIOLATION_LOG)
fi

## Make sure Idle Time is in allowed range
if [ "$IDLE_TIME" -le "0" ] || [ "$IDLE_TIME" -gt "$MAX_TIME" ]; then
    sudo -u $LOGGED_IN_USER /usr/bin/defaults -currentHost write "$SAVER_PREFS" "$SAVER_SETTING" -int "$DEFAULT_TIME"
    su -l "$LOGGED_IN_USER" -c "/usr/local/bin/yo_scheduler -t '$MSG_TITLE' -s '$MSG_NOTICE' -n '$MSG_INFO'"
    ((VIOLATION_COUNT++)); 
fi

## Log results of latest run
echo $VIOLATION_COUNT > $VIOLATION_LOG
echo $LATEST_DATE >> $VIOLATION_LOG