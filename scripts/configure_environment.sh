#!/bin/bash

set -e

# Import shared configurations and logging functions
source "$(dirname "$0")/logs.sh"
source "$(dirname "$0")/constants.sh"

PROJECT_DIR=$(cd "$(dirname $0)/.." && pwd)

# Function to configure environment variables for CUDA and llama.cpp
configure_environment() {
    log "Configuring environment variables..."

    # Add CUDA paths to .zshrc if not already present
    if ! grep -q "export PATH=/usr/local/cuda-12/bin" "$ZSHRC"; then
        log "Adding CUDA to PATH in $ZSHRC..."
        echo "export PATH=/usr/local/cuda-12/bin:\$PATH" >> "$ZSHRC"
    else
        warn "CUDA PATH already configured in $ZSHRC."
    fi

    if ! grep -q "export LD_LIBRARY_PATH=/usr/local/cuda-12/lib64" "$ZSHRC"; then
        log "Adding CUDA to LD_LIBRARY_PATH in $ZSHRC..."
        echo "export LD_LIBRARY_PATH=/usr/local/cuda-12/lib64:\$LD_LIBRARY_PATH" >> "$ZSHRC"
    else
        warn "CUDA LD_LIBRARY_PATH already configured in $ZSHRC."
    fi

    # Configure CMAKE_ARGS for llama.cpp with GPU support
    if command -v nvidia-smi &>/dev/null; then
        log "Detecting GPU compute capability..."
        COMPUTE_CAPABILITY=$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader | tr -d '.')
        if ! grep -q "export CMAKE_ARGS=\"-DCMAKE_CUDA_ARCHITECTURES=${COMPUTE_CAPABILITY}\"" "$ZSHRC"; then
            log "Adding CMAKE_ARGS for llama.cpp in $ZSHRC..."
            echo "export CMAKE_ARGS=\"-DCMAKE_CUDA_ARCHITECTURES=${COMPUTE_CAPABILITY}\"" >> "$ZSHRC"
        else
            warn "CMAKE_ARGS already configured in $ZSHRC."
        fi
    else
        warn "No NVIDIA GPU detected. Skipping GPU-specific configurations."
    fi

    

    log "Environment variables configured successfully. Please restart your terminal or run 'source ~/.zshrc'."
}

# Configure PYTHONPATH for ZSH
configure_pythonpath() {
    echo "Configuring PYTHONPATH for MAI project..."
    # Add PYTHONPATH to ~/.zshrc if it doesn't exist
    if ! grep -q "export PYTHONPATH=" ~/.zshrc; then
        echo "Adding PYTHONPATH to ~/.zshrc"
        echo "export PYTHONPATH=\$PYTHONPATH:$PROJECT_DIR/src/mai" >> ~/.zshrc
    else
        warn "PYTHONPATH is already set in ~/.zshrc"
    fi
}

configure_huggingface_home() {
    echo "Configuring Huggingface Home for MAI project..."
    if ! grep -q "export HF_HOME=" ~/.zshrc; then
        echo "Adding HF_HOME to ~/.zshrc"
        echo "export HF_HOME=$PROJECT_DIR/mai/huggingface" >> ~/.zshrc
    else
        warn "HF_HOME is already set in ~/.zshrc"
    fi
}

configure_pythonpath
configure_environment
configure_huggingface_home
