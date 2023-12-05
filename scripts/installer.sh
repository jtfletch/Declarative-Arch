#!/bin/bash

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "yay is not installed. Please install yay first."
    exit 1
fi

# Define the default program list file
program_list_file="$HOME/System/scripts/app_list"

# Check if the file exists
if [ ! -f "$program_list_file" ]; then
    echo "File not found: $program_list_file"
    exit 1
fi

# Loop through each program in the list
while read -r program; do
    # Check if the program is already installed
    if yay -Qi "$program" &> /dev/null; then
        echo "$program is already installed."
    else
        # Install the program using yay
        echo "Installing $program..."
        yay -S --noconfirm "$program"
        if [ $? -eq 0 ]; then
            echo "$program successfully installed."
        else
            echo "Failed to install $program."
        fi
    fi
done < "$program_list_file"
