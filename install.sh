#!/bin/bash

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "yay is not installed. Please install yay first."
    exit 1
fi

# Define the default program list file
program_list_file="program_list.txt"

# Check if the file exists
if [ ! -f "$program_list_file" ]; then
    echo "File not found: $program_list_file"
    exit 1
fi

# Prompt user to install Fish shell
read -p "Do you want to install Fish shell and set it as the default shell? (y/n): " install_fish

if [ "$install_fish" == "y" ]; then
    # Check if Fish shell is already installed
    if yay -Qi fish &> /dev/null; then
        echo "Fish shell is already installed."
    else
        # Install Fish shell using yay
        echo "Installing Fish shell..."
        yay -S --noconfirm fish
        if [ $? -eq 0 ]; then
            echo "Fish shell successfully installed."
        else
            echo "Failed to install Fish shell."
            exit 1
        fi
    fi

    # Set Fish shell as the default shell
    chsh -s "$(command -v fish)"
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

# Prompt user for Git SSH integration
read -p "Do you want to set up Git SSH integration? (y/n): " setup_git_ssh

if [ "$setup_git_ssh" == "y" ]; then
    # Get user's email for Git
    read -p "Enter your Git email: " git_email

    # Get user's name for Git
    read -p "Enter your Git username: " git_username

    # Set Git global configuration
    git config --global user.email "$git_email"
    git config --global user.name "$git_username"

    # Generate SSH keypair
    ssh-keygen -t rsa -b 4096 -C "$git_email"

    # Start the SSH agent
    eval "$(ssh-agent -s)"

    # Add the SSH key to the agent
    ssh-add ~/.ssh/id_rsa

    # Display the SSH key to paste into GitHub
    cat ~/.ssh/id_rsa.pub
    echo "Your SSH key has been generated. Copy the above key and add it to your GitHub account."
    echo "You can add the SSH key on GitHub by visiting: https://github.com/settings/ssh/new"
fi

