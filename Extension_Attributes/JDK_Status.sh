#!/bin/sh
## Checks if JDK is installed.

files=$(ls /Library/Java/JavaVirtualMachines/*.jdk 2> /dev/null | wc -l)
if [ "$files" != "0" ]
then
    echo "<result>Installed</result>"
else
    echo "<result>Not Installed</result>"
fi
