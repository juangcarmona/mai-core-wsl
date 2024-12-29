#!/bin/bash

set -e

# Import logging functions and shared constants
source "$(dirname "$0")/logs.sh"
source "$(dirname "$0")/constants.sh"

# Function to detect NVIDIA GPU
detect_gpu() {
    log "Detecting NVIDIA GPU..."
    if command -v nvidia-smi &> /dev/null; then
        HAS_GPU=true
        log "NVIDIA GPU detected."
    else
        HAS_GPU=false
        warn "No NVIDIA GPU detected. Skipping CUDA installation."
    fi
}

# Function to install NVIDIA CUDA Toolkit
install_cuda() {
    if [[ "$HAS_GPU" == true ]]; then
        log "Installing NVIDIA CUDA Toolkit..."
        
        log "Adding NVIDIA package repository..."
        CUDA_KEYRING_DEB="$MAI_TEMP/cuda-keyring_1.1-1_all.deb"
        wget -O "$CUDA_KEYRING_DEB" https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb || error "Failed to download CUDA keyring."
        sudo dpkg -i "$CUDA_KEYRING_DEB" || error "Failed to install CUDA keyring."
        
        log "Installing CUDA Toolkit..."
        sudo apt-get update -y
        sudo apt-get install -y cuda-toolkit-12-5 || error "Failed to install CUDA Toolkit."
        
        log "CUDA Toolkit installed successfully."
    else
        warn "Skipping CUDA installation as no GPU was detected."
    fi
}

# Function to configure environment variables
configure_cuda_env() {
    if [[ "$HAS_GPU" == true ]]; then
        log "Configuring environment variables for CUDA..."
        ZSHRC="$HOME/.zshrc"
        {
            echo "export PATH=/usr/local/cuda-12/bin:\$PATH"
            echo "export LD_LIBRARY_PATH=/usr/local/cuda-12/lib64:\$LD_LIBRARY_PATH"
            echo "export CUDACXX=/usr/local/cuda-12/bin/nvcc"
            echo "export CMAKE_ARGS=\"-DGGML_CUDA=on -DCMAKE_CUDA_ARCHITECTURES=all-major\""
        } >> "$ZSHRC"

        log "Environment variables configured. Reloading environment variables..."
        echo "    source $ZSHRC"
    fi
}

# Main logic
main() {
    detect_gpu
    install_cuda
    configure_cuda_env
}

main
