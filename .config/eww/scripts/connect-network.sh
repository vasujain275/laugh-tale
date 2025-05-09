#!/bin/bash


NETWORK="$1"
PASSWORD="$2"

# Attempt to connect to the network
if [ -z "$PASSWORD" ]; then
  # Try to connect without password (open network)
  nmcli device wifi connect "$NETWORK" &>/dev/null
else
  # Connect with password
  nmcli device wifi connect "$NETWORK" password "$PASSWORD" &>/dev/null
fi

# Check if connection succeeded
if [ $? -eq 0 ]; then
  notify-send "Network" "Connected to $NETWORK"
else
  notify-send "Network" "Failed to connect to $NETWORK"
fi
