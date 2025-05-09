#!/bin/bash

# Get WiFi status (enabled or disabled)
WIFI_STATUS=$(nmcli radio wifi)
eww update wifi_status="$WIFI_STATUS"

# Get current connection
CURRENT_NETWORK=$(nmcli -t -f NAME connection show --active 2>/dev/null | grep -v 'lo' | head -n 1)
eww update current_network="$CURRENT_NETWORK"

# Generate network list with signal strength
if [ "$WIFI_STATUS" = "enabled" ]; then
  # Scan for networks first
  nmcli device wifi rescan >/dev/null 2>&1
  
  # Build the network list with markup
  NETWORKS=$(nmcli -f SSID,SIGNAL,IN-USE device wifi list --rescan no | tail -n +2)
  NETWORK_LIST=""
  
  while read -r line; do
    # Extract SSID (it might contain spaces)
    IN_USE=$(echo "$line" | awk '{print $NF}')
    SIGNAL=$(echo "$line" | awk '{print $(NF-1)}')
    # Get everything except the last two columns (SIGNAL and IN-USE)
    SSID=$(echo "$line" | awk '{for(i=1;i<NF-1;i++) printf "%s ", $i; print ""}' | sed 's/^[ \t]*//;s/[ \t]*$//')
    
    if [ -n "$SSID" ]; then
      # Determine signal icon based on strength
      # Make sure SIGNAL is a number
      if [[ "$SIGNAL" =~ ^[0-9]+$ ]]; then
        if [ "$SIGNAL" -ge 75 ]; then
          SIGNAL_ICON=""
        elif [ "$SIGNAL" -ge 50 ]; then
          SIGNAL_ICON=""
        elif [ "$SIGNAL" -ge 25 ]; then
          SIGNAL_ICON=""
        else
          SIGNAL_ICON=""
        fi
        SIGNAL_TEXT="$SIGNAL%"
      else
        # If signal is not a number, use a default icon
        SIGNAL_ICON=""
        SIGNAL_TEXT=""
      fi
      
      # Check if currently connected
      CLASS="network-item"
      if [ "$IN_USE" = "*" ]; then
        CLASS="network-item connected"
        CONNECTION_INDICATOR=" "
      else
        CONNECTION_INDICATOR=""
      fi
      
      # Escape quotes in SSID
      ESCAPED_SSID=$(echo "$SSID" | sed 's/"/\\"/g')
      
      # Add to network list
      NETWORK_LIST="$NETWORK_LIST(box :class \"$CLASS\" :orientation \"horizontal\" (label :class \"network-name\" :text \"$CONNECTION_INDICATOR$ESCAPED_SSID\") (label :class \"signal-strength\" :text \"$SIGNAL_ICON $SIGNAL_TEXT\") (button :onclick \"scripts/select-network.sh \\\"$ESCAPED_SSID\\\"\" \"\")"
    fi
  done <<< "$NETWORKS"
  
  # Replace empty list with message
  if [ -z "$NETWORK_LIST" ]; then
    NETWORK_LIST="(box :class \"no-networks\" (label :text \"No networks found\"))"
  else
    # Close all boxes
    NETWORK_LIST="$NETWORK_LIST)"
  fi
  
  eww update wifi_list="$NETWORK_LIST"
fi
