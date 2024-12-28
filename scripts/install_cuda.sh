#!/bin/bash

set -e

# Import logging functions and shared constants
source "$(dirname "$0")/logs.sh"
source "$(dirname "$0")/constants.sh"

# Function to install NVIDIA CUDA Toolkit and cuDNN
install_cuda_and_cudnn() {
    log "Updating package list..."
    sudo apt-get update -y || error "Failed to update package list."

    log "Installing prerequisites..."
    sudo apt-get install -y build-essential dkms || error "Failed to install prerequisites."

    # CUDA Toolkit installation
    log "Adding NVIDIA package repository..."
    TEMP_FILE="$MAI_TEMP/cuda-keyring_1.1-1_all.deb"
    if [ ! -f "$TEMP_FILE" ]; then
        log "Downloading CUDA keyring..."
        wget -O "$TEMP_FILE" https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb || error "Failed to download NVIDIA package repository."
    else
        log "CUDA keyring already downloaded. Skipping download."
    fi
    sudo dpkg -i "$TEMP_FILE" || error "Failed to add NVIDIA package repository."

    log "Installing CUDA Toolkit..."
    if dpkg-query -W -f='${Status}' cuda-toolkit-12-5 2>/dev/null | grep -q "install ok installed"; then
        log "CUDA Toolkit is already installed. Skipping installation."
    else
        sudo apt-get update -y
        sudo apt-get install -y cuda-toolkit-12-5 || error "Failed to install CUDA Toolkit."
    fi

    # cuDNN installation
    log "Adding cuDNN package repository..."
    CUDNN_TEMP="$MAI_TEMP/cudnn-local-repo.deb"
    if [ ! -f "$CUDNN_TEMP" ]; then
        log "Downloading cuDNN repository..."
        wget -O "$CUDNN_TEMP" "https://developer.download.nvidia.com/compute/cudnn/9.6.0/local_installers/cudnn-local-repo-ubuntu2204-9.6.0_1.0-1_amd64.deb" || error "Failed to download cuDNN repository."
    else
        log "cuDNN repository already downloaded. Skipping download."
    fi
    sudo dpkg -i "$CUDNN_TEMP" || error "Failed to add cuDNN repository."
    sudo cp /var/cudnn-local-repo-ubuntu2204-9.6.0/cudnn-local-*-keyring.gpg /usr/share/keyrings/cudnn-local-9.6-keyring.gpg

    # Update apt sources and fix conflicts
    CUDNN_LIST="/etc/apt/sources.list.d/cudnn-local.list"
    if [ -f "$CUDNN_LIST" ]; then
        log "Fixing keyring conflict in $CUDNN_LIST..."
        sudo sed -i 's|signed-by=.*|signed-by=/usr/share/keyrings/cudnn-local-9.6-keyring.gpg|' "$CUDNN_LIST"
    fi

    log "Installing cuDNN..."
    if dpkg-query -W -f='${Status}' cudnn 2>/dev/null | grep -q "install ok installed"; then
        log "cuDNN is already installed. Skipping installation."
    else
        sudo apt-get update
        sudo apt-get install -y cudnn || error "Failed to install cuDNN."
    fi

    log "Installing cuDNN for CUDA 12..."
    if dpkg-query -W -f='${Status}' cudnn-cuda-12 2>/dev/null | grep -q "install ok installed"; then
        log "cuDNN for CUDA 12 is already installed. Skipping installation."
    else
        sudo apt-get install -y cudnn-cuda-12 || error "Failed to install cuDNN for CUDA 12."
    fi

    log "CUDA Toolkit and cuDNN installed successfully."

    # Configure environment variables
    log "Configuring environment variables for CUDA..."
    ZSHRC="$HOME/.zshrc"
    {
        echo "export PATH=/usr/local/cuda-12/bin:\$PATH"
        echo "export LD_LIBRARY_PATH=/usr/local/cuda-12/lib64:\$LD_LIBRARY_PATH"
        echo "export CUDACXX=/usr/local/cuda-12/bin/nvcc"
        echo "export CMAKE_ARGS=\"-DGGML_CUDA=on -DCMAKE_CUDA_ARCHITECTURES=all-major\""
    } >> "$ZSHRC"
    log "Environment variables configured. Please restart your terminal or source $ZSHRC."
}

install_cuda_and_cudnn
