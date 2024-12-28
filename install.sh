#!/bin/bash

set -e

# Determine the root directory of the project
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

# Import logging functions and shared constants
source "$SCRIPTS_DIR/logs.sh"
source "$SCRIPTS_DIR/constants.sh"

# Ensure sudo credentials are requested at the start
sudo -v

# Function to execute a script and check for errors
run_script() {
    local script_path=$1
    log "Executing: $script_path..."
    if bash "$script_path"; then
        log "$script_path executed successfully."
    else
        error "Error occurred while executing $script_path. Exiting."
    fi
}

# Define script paths
INSTALL_ZSH="$SCRIPTS_DIR/install_zsh.sh"
INSTALL_UTILITIES="$SCRIPTS_DIR/install_utilities.sh"
IMPORT_USEFUL_ALIASES="$SCRIPTS_DIR/import_useful_aliases.sh"
INSTALL_CUDA="$SCRIPTS_DIR/install_cuda.sh"
INSTALL_LLAMA_CPP="$SCRIPTS_DIR/install_llama_cpp.sh"
INSTALL_LLAMA_CPP_PYTHON="$SCRIPTS_DIR/install_llama_cpp_python.sh"
CONFIGURE_ENVIRONMENT="$SCRIPTS_DIR/configure_environment.sh"
INSTALL_PYTHON_PACKAGES="$SCRIPTS_DIR/install_python_packages.sh"


# Print banner
print_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════╗"
    echo "║                   MAI                    ║"
    echo "║        My Artificial Intelligence        ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Main execution
main() {
    print_banner

    log "Starting MAI setup..."
    run_script "$INSTALL_ZSH"
    run_script "$INSTALL_UTILITIES"
    run_script "$IMPORT_USEFUL_ALIASES"
    run_script "$INSTALL_CUDA"
    run_script "$INSTALL_LLAMA_CPP" 
    run_script "$INSTALL_LLAMA_CPP_PYTHON"
    run_script "$CONFIGURE_ENVIRONMENT"
    run_script "$INSTALL_PYTHON_PACKAGES"


echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════╗"
echo -e "║         ${GREEN}MAI setup completed successfully!  ${BLUE}       ║"
echo -e "${BLUE}╔═══════════════════════════════════════════════════╗"
echo -e "${BLUE}║${YELLOW}✨ Thank you for using MAI! ✨${BLUE}                     ║"
echo -e "${BLUE}║${YELLOW}Give it a star on GitHub! 🌟${BLUE}                       ║"
echo -e "${BLUE}║${CYAN}Repo: https://github.com/juangcarmona/mai${BLUE}          ║"
echo -e "${BLUE}║${GREEN}Contribute! Fork, PR, or share your ideas. 🤖${BLUE}      ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"


    warn "╔══════════════════════════════════════════════╗"
    warn "║ ${YELLOW}FIRST                                        ${NC}║"
    warn "║ Please restart your terminal or run:         ║"
    warn "║   ${CYAN}source ~/.zshrc${NC}                            ║"
    warn "║ To apply environment changes.                ║"
    warn "╚══════════════════════════════════════════════╝"

    warn "╔══════════════════════════════════════════════╗"
    warn "║ ${YELLOW}To verify your installation status:        ${NC}║"
    warn "║                                              ║"
    warn "║ ${CYAN}chmod +x $DISPLAY_MAI_INFO &&             "
    warn "║ ${CYAN}$DISPLAY_MAI_INFO                      "
    warn "╚══════════════════════════════════════════════╝"

}


main
