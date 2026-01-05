#!/bin/bash

# Check if a VPN is connected by looking for an IPv4 default route
# that points to a utun interface. This is the most reliable method.

# Use netstat to check the IPv4 routing table for a default route.
# The `grep -q` command searches quietly, returning a success code if a match is found.
if netstat -rn -f inet | grep -q 'utun'; then
    echo "VPN is connected."
else
    # The VPN is not connected, or the default route is not set correctly.
    # We can perform a secondary check for the `pptp` or `l2tp` interfaces
    # for older or manually configured VPNs.
    if netstat -rn -f inet | grep -q 'pptp\|l2tp'; then
        echo "VPN is connected."
    else
        # If neither check passes, the VPN is not running.
        echo "VPN is not connected."
    fi
fi