#!/bin/bash

set -e

# Import logging functions and shared constants
source "$(dirname "$0")/logs.sh"
source "$(dirname "$0")/constants.sh"

install_utilities() {
    # Function to install essential system utilities (Few should be already there):    
    # - tree => Visualize directory structures in a tree format (I can't live without it)
    # - htop => Interactive system resource monitor
    # - curl => Tool to transfer data from or to a server
    # - wget => Download files from the web
    # - unzip => Extract ZIP files
    # - git => Version control system
    # - jq => Command-line JSON processor
    # - neofetch => Display system information in terminal

    log "Updating package list..."
    sudo apt update -y || error "Failed to update package list."
    log "Installing essential utilities..."
    sudo apt install -y tree htop curl wget unzip git jq neofetch python3-dev
    log "All utilities installed successfully!" 
}

install_utilities
