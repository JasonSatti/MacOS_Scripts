#!/usr/bin/env bash
## Disable Screensaver for 1 hour
## Dakr-xv

## Get the logged in user
LOGGED_IN_USER=$(/usr/bin/python -c 'from SystemConfiguration import\
 SCDynamicStoreCopyConsoleUser;import sys; username = \
 (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0];username\
 = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write\
 (username + "\n");')

LOG_PATH="/Users/$LOGGED_IN_USER/.jamf" ## Directory where log is stored
mkdir -p "$LOG_PATH" ## Ensure logging directory exists
RUN_LOG="$LOG_PATH/ss_disable.log" ## Where to store log of policy usage amount
DEFAULT_TIME=$((60 * 60 * 1)) ## The preferred Disable Time is 1 hour.

## Message for user when they disable the screensaver
MSG_TITLE='Screensaver Disabled for 1 Hour'

## Kill all previous caffeinate processes
killall caffeinate

## Set veriables for policy usage tracking
USAGE_COUNT=0

## If the log file exists, retrieve current counter
if [ -f $RUN_LOG ]; then
    USAGE_COUNT=$(head -1 $RUN_LOG)
fi

## Send User a Notification via Yo Notificaation
## https://github.com/sheagcraig/yo
sudo -u $LOGGED_IN_USER /usr/local/bin/yo_scheduler -t "$MSG_TITLE"

## Update Usage Count and Log results of latest run
((USAGE_COUNT++))
echo $USAGE_COUNT > $RUN_LOG

## Disable Screensaver for 1 hour
sudo -u $LOGGED_IN_USER caffeinate -d -t "$DEFAULT_TIME" &
