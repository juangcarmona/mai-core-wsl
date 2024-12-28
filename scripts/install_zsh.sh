#!/bin/bash

set -e

# Import logging functions
source "$(dirname "$0")/logs.sh"

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
    chsh -s "$(which zsh)" "$(whoami)" || error "Failed to set Zsh as the default shell."
    log "Zsh set as the default shell."
else
    log "Zsh is already the default shell."
fi

log "Checking if Oh My Zsh is already installed..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    warn "Oh My Zsh is already installed. Skipping installation."
else
    log "Installing Oh My Zsh..."
    # Forcing unattended installation
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || error "Oh My Zsh installation failed."
    log "Oh My Zsh installed successfully."
fi

# Inform the user about the next steps
warn "IMPORTANT: Zsh and Oh My Zsh have been installed and configured as the default shell."
warn "To activate Zsh, please restart your terminal or manually run:"
warn "           ${CYAN}zsh${NC}"
warn "Then continue the setup process by re-running the installation script."
