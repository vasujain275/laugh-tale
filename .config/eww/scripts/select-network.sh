#!/bin/bash

NETWORK="$1"

# Check if we're already connected to this network
CURRENT_NETWORK=$(nmcli -t -f NAME connection show --active 2>/dev/null | grep -v 'lo' | head -n 1)

if [ "$CURRENT_NETWORK" = "$NETWORK" ]; then
  # Already connected - offer to disconnect
  notify-send "Network" "Already connected to $NETWORK"
  exit 0
fi

# Check if this is a known network
if nmcli -g name connection show | grep -q "^$NETWORK$"; then
  # Known network, connect directly
  nmcli connection up "$NETWORK"
  notify-send "Network" "Connecting to $NETWORK"
  # Update status after a short delay to allow connection to establish
  (sleep 2 && scripts/update-network-status.sh) &
else
  # Unknown network, show password entry
  eww update connect_to_network="$NETWORK"
  eww update password_value=""
  eww update show_password_entry=true
fi
