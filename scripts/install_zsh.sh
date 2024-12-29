#!/bin/bash

set -e

# Import logging functions
source "$(dirname "$0")/logs.sh"

NEED_RESTART=false  # Flag to determine if a restart is needed

# Check if Zsh is installed
log "Checking if Zsh is already installed..."
if command -v zsh &> /dev/null; then
    log "Zsh is already installed."
else
    log "Zsh is not installed. Installing Zsh..."
    sudo apt-get update -y
    sudo apt-get install -y zsh
    log "Zsh installed successfully."
    NEED_RESTART=true
fi

# Check if Oh My Zsh is installed
log "Checking if Oh My Zsh is already installed..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Oh My Zsh is already installed."
else
    log "Installing Oh My Zsh..."
    # Install Oh My Zsh in unattended mode
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || error "Oh My Zsh installation failed."
    log "Oh My Zsh installed successfully."
    NEED_RESTART=true
fi

# Exit and warn user if installation was performed
if [ "$NEED_RESTART" = true ]; then
    warn "IMPORTANT: Zsh and/or Oh My Zsh were installed."
    warn "To activate Zsh as your shell, restart your terminal or run: ${CYAN}zsh${NC}"
    warn "Once restarted, re-run the installation script to continue."
    zsh
    chsh -s $(which zsh)
    exit 1
fi

log "Zsh and Oh My Zsh are already installed and configured. Continuing..."
