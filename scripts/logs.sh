#!/bin/bash

# Color codes for output
BLUE='\033[38;5;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
NC='\033[0m'
RED='\033[0;31m'
YELLOW='\033[38;5;214m'

# Logging functions
log() {
    echo -e "${GREEN}[MAI]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}
