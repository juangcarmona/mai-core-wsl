#!/bin/bash

set -e
# Ensure sudo credentials are requested at the start
sudo -v
# Import logging functions and shared constants
source "$(dirname "$0")/logs.sh"
source "$(dirname "$0")/constants.sh"

install_llama_cpp() {
    local LLAMA_DIR="$REPO_DIR/llama.cpp"
    local BIN_DIR="$LLAMA_DIR/build"

    log "Cloning llama.cpp repository to $LLAMA_DIR..."
    if [ -d "$LLAMA_DIR" ]; then
        warn "llama.cpp repository already exists at $LLAMA_DIR. Pulling latest changes..."
        cd "$LLAMA_DIR"
        git pull || error "Failed to update llama.cpp repository."
    else
        git clone https://github.com/ggerganov/llama.cpp.git "$LLAMA_DIR" || error "Failed to clone llama.cpp repository."
    fi

    log "Installing dependencies..."
    sudo apt-get update
    sudo apt-get install -y libcurl4-openssl-dev || error "Failed to install libcurl dependencies."

    log "Building llama.cpp..."
    cd "$LLAMA_DIR"

    # Clean previous builds
    rm -rf build
    mkdir -p build
    cd build

    log "Configuring build with CMake..."
    if command -v nvidia-smi &>/dev/null; then
        log "NVIDIA GPU detected, building with CUDA support..."
        cmake .. -DLLAMA_CUBLAS=off -DGGML_CUDA=on -DLLAMA_CURL=on || error "CMake configuration failed for CUDA."
    else
        warn "No NVIDIA GPU detected. Building without CUDA support."
        cmake .. -DLLAMA_CURL=on || error "CMake configuration failed."
    fi

    log "Compiling llama.cpp..."
    make || error "Failed to compile llama.cpp."

    log "llama.cpp compiled successfully. CLI and server binaries are available in $LLAMA_DIR/build."

    # Add $BIN_DIR to PATH
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        log "Adding $BIN_DIR to PATH..."
        export PATH="$BIN_DIR:$PATH"

        # Persist in ~/.zshrc
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$ZSHRC"
        log "PATH updated in $ZSHRC."
    else
        warn "$BIN_DIR is already in PATH."
    fi
}

install_llama_cpp
