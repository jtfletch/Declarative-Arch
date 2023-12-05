#!/bin/bash

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "yay is not installed. Please install yay first."
    exit 1
fi

# Function to install a package using yay
install_package() {
    package_name="$1"
    echo "Installing $package_name..."
    yay -S --noconfirm "$package_name"
    if [ $? -eq 0 ]; then
        echo "$package_name successfully installed."
    else
        echo "Failed to install $package_name."
        exit 1
    fi
}

# Check if Fish shell is already installed
if ! yay -Qi fish &> /dev/null; then
    # Install Fish shell using yay
    install_package fish
    # Set Fish shell as the default shell
    chsh -s "$(command -v fish)"
else
    echo "Fish shell is already installed."
fi

# Check if xclip is installed
if ! command -v xclip &> /dev/null; then
    # Install xclip
    install_package xclip
fi

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

    # Copy the SSH key to clipboard using xclip
    cat ~/.ssh/id_rsa.pub | xclip -sel clip  # For Linux
    # OR
    # cat ~/.ssh/id_rsa.pub | pbcopy  # For macOS

    echo "Your SSH key has been generated and copied to the clipboard."
    echo "Paste the SSH key into your GitHub account settings."
    
     # Open the GitHub SSH key page in Firefox
    xdg-open "https://github.com/settings/ssh/new" || echo "Unable to open the link. Please visit the link manually."
fi
