#!/bin/sh
## Checks for Firewall Status.

#fwstatus=$( defaults read /Library/Preferences/com.apple.alf globalstate )
fws=("/usr/libexec/ApplicationFirewall/socketfilterfw --getblockall")

#if [[ $fwstatus = 0 ]]; 
#then
#	echo "<result>Off</result>"
#else
#	echo "<result>On</result>"
#fi

if [[ $fws = *"Block all DISABLED!"* ]]; then
    echo "<result>Off</result>"
else
    echo "<result>On</result>"
fi