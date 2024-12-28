#!/bin/bash

set -e

# Import logging functions and shared constants
source "$(dirname "$0")/logs.sh"
source "$(dirname "$0")/constants.sh"

# Function to install essential Python packages for MAI
install_python_packages() {
    log "Activating virtual environment at $VENV_DIR..."
    if [ -d "$VENV_DIR" ]; then
        source "$VENV_DIR/bin/activate"
    else
        error "Virtual environment not found at $VENV_DIR. Please set it up first."
    fi

    log "Upgrading pip, setuptools, and wheel..."
    pip install --upgrade pip setuptools wheel || error "Failed to upgrade pip, setuptools, or wheel."

    log "Installing essential Python packages for AI development..."

    # Core libraries
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 || error "Failed to install PyTorch."
    pip install transformers datasets huggingface-hub || error "Failed to install Hugging Face libraries."
    pip install sentencepiece || error "Failed to install SentencePiece."
    pip install accelerate || error "Failed to install Accelerate."
    pip install llama-cpp-python || error "Failed to install llama-cpp-python."

    # Additional tools for optimization and deployment
    pip install optimum || error "Failed to install Optimum."
    pip install fastapi uvicorn || error "Failed to install FastAPI and Uvicorn for serving APIs."

    # For creating your own Copilot-like tools
    pip install langchain openai || error "Failed to install LangChain and OpenAI libraries."
    pip install autograd || error "Failed to install Autograd."

    log "Python packages installed successfully in the virtual environment."
    deactivate
}

install_python_packages
