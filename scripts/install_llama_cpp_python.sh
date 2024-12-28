#!/bin/bash

set -e

# Import logging functions and shared constants
source "$(dirname "$0")/logs.sh"
source "$(dirname "$0")/constants.sh"

# Function to install llama-cpp-python in a virtual environment
install_llama_cpp_python() {
    log "Checking prerequisites for Python virtual environments..."
    
    # Ensure the python3-venv package is installed
    if ! dpkg -l | grep -q python3-venv; then
        warn "The package python3-venv is missing. Installing it now..."
        sudo apt-get update -y || error "Failed to update package list."
        sudo apt-get install -y python3-venv || error "Failed to install python3-venv."
    fi
    
    # Check if virtual environment already exists
    if [ -d "$VENV_DIR" ]; then
        warn "Virtual environment already exists at $VENV_DIR. Skipping creation."
    else
        log "Creating virtual environment for llama-cpp-python at $VENV_DIR..."
        python3 -m venv "$VENV_DIR" || error "Failed to create virtual environment."
    fi

    log "Activating virtual environment..."
    source "$VENV_DIR/bin/activate" || error "Failed to activate virtual environment."

    log "Installing or updating llama-cpp-python..."
    pip install --upgrade pip setuptools wheel || error "Failed to upgrade pip, setuptools, or wheel."
    
    # Install llama-cpp-python without cache to ensure clean installation
    pip install llama-cpp-python --no-cache-dir || error "Failed to install llama-cpp-python."

    if command -v nvidia-smi &>/dev/null; then
        log "NVIDIA GPU detected, configuring for CUDA..."
        COMPUTE_CAPABILITY=$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader | tr -d '.')
        export CMAKE_ARGS="-DCMAKE_CUDA_ARCHITECTURES=${COMPUTE_CAPABILITY}"
        pip install llama-cpp-python --force-reinstall --no-cache-dir || error "Failed to reinstall llama-cpp-python with CUDA support."
    else
        warn "No NVIDIA GPU detected. Skipping CUDA configuration."
    fi

    deactivate
    log "llama-cpp-python installed successfully in the virtual environment at $VENV_DIR."
}

install_llama_cpp_python
