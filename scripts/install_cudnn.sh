#!/bin/bash

set -e

# Import logging functions and shared constants
source "$(dirname "$0")/logs.sh"
source "$(dirname "$0")/constants.sh"

log "Adding cuDNN package repository..."
CUDNN_REPO_DEB="$MAI_TEMP/cudnn-local-repo.deb"
wget -O "$CUDNN_REPO_DEB" "https://developer.download.nvidia.com/compute/cudnn/9.6.0/local_installers/cudnn-local-repo-ubuntu2204-9.6.0_1.0-1_amd64.deb" || error "Failed to download cuDNN repository."
sudo dpkg -i "$CUDNN_REPO_DEB" || error "Failed to install cuDNN repository."

log "Copying cuDNN GPG key..."
sudo cp /var/cudnn-local-repo-ubuntu2204-9.6.0/cudnn-local-*-keyring.gpg /usr/share/keyrings/cudnn-local-9.6-keyring.gpg || error "Failed to copy cuDNN GPG key."

log "Fixing keyring conflict in cuDNN repository list..."
CUDNN_LIST="/etc/apt/sources.list.d/cudnn-local.list"
sudo sed -i 's|signed-by=.*|signed-by=/usr/share/keyrings/cudnn-local-9.6-keyring.gpg|' "$CUDNN_LIST" || error "Failed to fix keyring conflict."

log "Installing cuDNN..."
sudo apt-get update -y
sudo apt-get install -y cudnn || error "Failed to install cuDNN."

log "Installing cuDNN for CUDA 12..."
sudo apt-get install -y cudnn-cuda-12 || error "Failed to install cuDNN for CUDA 12."

log "cuDNN installed successfully."
