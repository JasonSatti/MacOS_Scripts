#!/bin/bash
## Returns the Age of the Macbook's local password in Days.

LOGGED_IN_USER=`/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys;\
 username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0];\
username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

passwordDateTime=$( dscl . read /Users/$LOGGED_IN_USER accountPolicyData | sed 1,2d | /usr/bin/xpath\
"/plist/dict/real[preceding-sibling::key='passwordLastSetTime'][1]/text()" 2> /dev/null | sed -e 's/\.[0-9]*//g' )
((passwordAgeDays = ($(date +%s) - $passwordDateTime) / 86400 ))

echo "<result>$passwordAgeDays</result>"
