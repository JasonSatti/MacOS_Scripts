#!/usr/bin/env bash
# remove_guest_network: Verify corp network exists then remove guest network.
# Used to verify employees stay connected to corp network
# Jason Satti

# Set Corp and Guest network SSID names
CORP_NETWORK="Corp"
GUEST_NETWORK="Guest"

# Check to see if corp network exists on preffered network list
NETWORK_CHECK="$(networksetup -listpreferredwirelessnetworks en0 |
    grep "${CORP_NETWORK}")"

# If corp network does not exist exit script
# Else attempt to remove guest network
if [ "${NETWORK_CHECK}" = "" ]; then
    echo ""${CORP_NETWORK}" SSID Not Found"
    exit 0
else
    echo ""${CORP_NETWORK}" SSID Found, \
Attempting To Remove "${GUEST_NETWORK}" SSID"
fi

# Remove guest network
networksetup -removepreferredwirelessnetwork en0 "${GUEST_NETWORK}"
exit 0
