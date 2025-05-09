#!/bin/bash

# Check if network menu is already open
if eww list-windows | grep -q "*network_menu"; then
  # Menu is open, close it
  eww close network_menu
else
  # Update network status before opening
  scripts/update-network-status.sh
  
  # Open the menu
  eww open network_menu
fi
