#!/bin/bash

# Get current WiFi status
WIFI_STATUS=$(nmcli radio wifi)

# Toggle WiFi based on current status
if [ "$WIFI_STATUS" = "enabled" ]; then
  nmcli radio wifi off
else
  nmcli radio wifi on
fi
