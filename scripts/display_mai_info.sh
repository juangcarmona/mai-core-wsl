#!/bin/bash

set -e

# Import shared logging and constants
source "$(dirname "$0")/logs.sh"
source "$(dirname "$0")/constants.sh"

# Ensure sudo credentials are requested at the start
sudo -v

# Function to display system information
display_system_info() {
    echo -e "${BLUE}============================================="
    echo -e "                MAI System Info               "
    echo -e "=============================================${NC}"

    log "Gathering system information..."

    # Operating System
    OS_NAME=$(lsb_release -d | awk -F":" '{print $2}' | xargs)
    echo -e "${GREEN}Operating System:${NC} $OS_NAME"

    # Kernel Version
    KERNEL_VERSION=$(uname -r)
    echo -e "${GREEN}Kernel Version:${NC} $KERNEL_VERSION"

    # Python Version
    if command -v python3 &>/dev/null; then
        PYTHON_VERSION=$(python3 --version 2>&1)
        echo -e "${GREEN}Python Version:${NC} $PYTHON_VERSION"
    else
        echo -e "${YELLOW}Python:${NC} Not installed"
    fi

    # CUDA Version
    if command -v nvcc &>/dev/null; then
        CUDA_VERSION=$(nvcc --version | grep release | awk '{print $6}' | sed 's/,//')
        echo -e "${GREEN}CUDA Version:${NC} $CUDA_VERSION"
    else
        echo -e "${YELLOW}CUDA:${NC} Not installed"
    fi

    # NVIDIA Driver Version
    if command -v nvidia-smi &>/dev/null; then
        NVIDIA_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)
        echo -e "${GREEN}NVIDIA Driver Version:${NC} $NVIDIA_VERSION"
    else
        echo -e "${YELLOW}NVIDIA Driver:${NC} Not detected"
    fi

    # GPU Information
    if command -v nvidia-smi &>/dev/null; then
        GPU_INFO=$(nvidia-smi --query-gpu=name --format=csv,noheader)
        echo -e "${GREEN}GPU:${NC} $GPU_INFO"

        GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
        echo -e "${GREEN}GPU Temperature:${NC} ${GPU_TEMP}°C"
    else
        echo -e "${YELLOW}GPU:${NC} Not detected"
    fi

    # Disk Space
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $4}')
    echo -e "${GREEN}Available Disk Space:${NC} $DISK_USAGE"

    # Memory Usage
    MEMORY=$(free -h | awk 'NR==2 {print $7}')
    echo -e "${GREEN}Available Memory:${NC} $MEMORY"

    # Virtual Environment
    if [ -d "$VENV_DIR" ]; then
        source "$VENV_DIR/bin/activate"
        PACKAGE_COUNT=$(pip list | wc -l)
        echo -e "${GREEN}Virtual Environment:${NC} Active at $VENV_DIR"

        if pip show llama-cpp-python &>/dev/null; then
            echo -e "${GREEN}llama-cpp-python:${NC} Installed"
        else
            echo -e "${YELLOW}llama-cpp-python:${NC} Not installed"
        fi

        deactivate
    else
        echo -e "${YELLOW}Virtual Environment:${NC} Not configured"
    fi

    # llama.cpp

    if [ -d "$LLAMA_DIR" ]; then
        if command -v llama-cli &>/dev/null; then
            echo -e "${GREEN}llama.cpp:${NC} Installed and functional."
        else
            echo -e "${YELLOW}llama.cpp:${NC} Detected but binary not found in PATH."
            echo -e "${YELLOW}Hint:${NC} Check the build directory and PATH settings."
        fi
    else
        echo -e "${RED}llama.cpp:${NC} Not installed. Run the installation script to install it."
    fi

    # Git Version
    if command -v git &>/dev/null; then
        GIT_VERSION=$(git --version | awk '{print $3}')
        echo -e "${GREEN}Git Version:${NC} $GIT_VERSION"
    else
        echo -e "${YELLOW}Git:${NC} Not installed"
    fi

    # Docker Version and Status
    if command -v docker &>/dev/null; then
        DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
        echo -e "${GREEN}Docker Version:${NC} $DOCKER_VERSION"

        # Check if Docker daemon is accessible
        if docker info &>/dev/null; then
            echo -e "${GREEN}Docker Status:${NC} Running"
        else
            echo -e "${YELLOW}Docker Status:${NC} Not running or not accessible"
        fi
    else
        echo -e "${YELLOW}Docker:${NC} Not installed"
    fi


    # Network Information
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
    echo -e "${GREEN}Local IP Address:${NC} $IP_ADDRESS"
    if ping -c 1 google.com &>/dev/null; then
        echo -e "${GREEN}Internet Connectivity:${NC} Connected"
    else
        echo -e "${RED}Internet Connectivity:${NC} Disconnected"
    fi

    # System Uptime
    UPTIME=$(uptime -p)
    echo -e "${GREEN}System Uptime:${NC} $UPTIME"

    # Zsh and Oh My Zsh
    if command -v zsh &>/dev/null; then
        ZSH_VERSION=$(zsh --version | awk '{print $2}')
        echo -e "${GREEN}Zsh Version:${NC} $ZSH_VERSION"
        if [ -d "$HOME/.oh-my-zsh" ]; then
            echo -e "${GREEN}Oh My Zsh:${NC} Installed"
        else
            echo -e "${YELLOW}Oh My Zsh:${NC} Not installed"
        fi
    else
        echo -e "${YELLOW}Zsh:${NC} Not installed"
    fi

    # System Updates
    UPDATES=$(sudo apt update 2>/dev/null | grep "packages can be upgraded" || echo "No updates available")
    echo -e "${GREEN}System Updates:${NC} $UPDATES"

    # Disk Partition Usage
    echo -e "${GREEN}Disk Usage:${NC}"
    df -h | grep '^/dev'

    echo -e "${BLUE}=============================================${NC}"
}

display_system_info
