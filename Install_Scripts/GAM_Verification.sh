#!/usr/bin/env bash
## GAM Verification and Update Script
## Dakr-xv

## Initalize the full path of GAM
GAM=~/bin/gam/gam

## Verify that GAM is installed on the computer, if not then install it
$GAM version >/dev/null 2>&1
if [[ $? == "0" ]]; then
    echo "GAM is installed. Verifying version information."
else
    echo "GAM is not installed. Installing GAM and initating setup."
    bash <(curl -s -S -L https://git.io/install-gam)
fi

## Get the version number of the latest GAM release as well as the version number of the local GAM
LATEST_GAM=$(curl -s https://github.com/jay0lee/GAM/releases | grep "GAM/tree" | head -n 1 | sed -e 's/.*v\(.*\)".*/\1/') >/dev/null 2>&1
LOCAL_GAM=$($GAM version | grep "GAM" | awk '{print $2}')

## Verify that GAM is up to date, if not then update it
if [ $LATEST_GAM != $LOCAL_GAM ]; then
    echo "GAM version $LOCAL_GAM is out of date. Latest Version is $LATEST_GAM."
    echo "Updating to latest version of GAM."
    bash <(curl -s -S -L https://git.io/install-gam) -l
else
    echo "GAM version $LOCAL_GAM is up to date. Latest Version is $LATEST_GAM."
fi
