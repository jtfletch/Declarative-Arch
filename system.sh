#!/bin/bash

# Set the paths to the scripts
installer_script="$HOME/System/scripts/installer.sh"
configure_script="$HOME/System/scripts/configure.sh"

# Check if installer.sh is executable, if not, make it executable
if [[ ! -x "$installer_script" ]]; then
    chmod +x "$installer_script"
fi

# Check if configure.sh is executable, if not, make it executable
if [[ ! -x "$configure_script" ]]; then
    chmod +x "$configure_script"
fi

# Ask the user if they want to configure the system
read -p "Do you want to configure the system? (yes/no): " configure_choice

if [[ "$configure_choice" == "yes" ]]; then
    # Run the configure.sh script
    "$configure_script"
fi

# Ask the user if they want to install applications
read -p "Do you want to install applications? (yes/no): " install_choice

if [[ "$install_choice" == "yes" ]]; then
    # Run the installer.sh script
    "$installer_script"
fi
