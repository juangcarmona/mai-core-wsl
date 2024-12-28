#!/bin/bash

set -e

# Import logging functions
source "$(dirname "$0")/logs.sh"

# Function to install Zsh and Oh My Zsh
install_zsh() {
    log "Checking if Zsh is already installed..."
    if command -v zsh &> /dev/null; then
        log "Zsh is already installed. Skipping installation."
    else
        log "Zsh is not installed. Installing Zsh..."
        sudo apt-get update -y
        sudo apt-get install -y zsh
        log "Zsh installed successfully."
    fi

    log "Setting Zsh as the default shell..."
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        log "Zsh set as the default shell."
    else
        log "Zsh is already the default shell."
    fi

    log "Checking if Oh My Zsh is already installed..."
    if [ -d "$HOME/.oh-my-zsh" ]; then
        warn "Oh My Zsh is already installed. Skipping installation."
    else
        log "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
        log "Oh My Zsh installed successfully."
    fi
}

install_zsh
