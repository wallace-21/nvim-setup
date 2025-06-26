#!/bin/bash
set -e

# Combined Nvim & Tmux Environment Setup Script
# This script sets up both nvim and tmux configurations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            echo "ubuntu"
        elif command_exists yum; then
            echo "centos"
        elif command_exists pacman; then
            echo "arch"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Install packages based on OS
install_packages() {
    local os=$(detect_os)
    local packages_to_install=()

    # Check what needs to be installed
    if ! command_exists tmux; then
        packages_to_install+=("tmux")
    fi

    if ! command_exists nvim; then
        packages_to_install+=("neovim")
    fi

    if [ ${#packages_to_install[@]} -eq 0 ]; then
        log_success "tmux and neovim are already installed"
        return 0
    fi

    log_info "Installing ${packages_to_install[*]} for $os..."

    case $os in
        ubuntu)
            sudo apt-get update && sudo apt-get install -y "${packages_to_install[@]}"
            ;;
        centos)
            sudo yum install -y "${packages_to_install[@]}"
            ;;
        arch)
            sudo pacman -S "${packages_to_install[@]}"
            ;;
        macos)
            if command_exists brew; then
                brew install "${packages_to_install[@]}"
            else
                log_error "Homebrew not found. Please install Homebrew first or install packages manually."
                return 1
            fi
            ;;
        *)
            log_error "Unsupported OS. Please install tmux and neovim manually."
            return 1
            ;;
    esac

    log_success "Packages installed successfully"
}

# Backup existing config
backup_config() {
    local config_path="$1"
    local config_name="$2"

    if [[ -e "$config_path" ]]; then
        local backup_path="${config_path}.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Existing $config_name found. Creating backup: $backup_path"
        mv "$config_path" "$backup_path"
        log_success "Backup created: $backup_path"
    fi
}

# Setup Nvim Configuration
setup_nvim() {
    log_info "Setting up nvim configuration..."
    local nvim_config_dir="$HOME/.config/nvim"

    if [[ -d "$nvim_config_dir" ]]; then
        log_warning "Nvim config directory already exists at $nvim_config_dir"
        read -p "Do you want to backup and replace it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            backup_config "$nvim_config_dir" "nvim config"
        else
            log_warning "Skipping nvim config setup"
            return 0
        fi
    fi

    if [[ ! -d "$nvim_config_dir" ]]; then
        log_info "Cloning nvim configuration from github.com/wallace-21/init.lua"
        git clone https://github.com/wallace-21/init.lua "$nvim_config_dir"
        log_success "Nvim configuration cloned successfully"
    fi
}

# Setup personal repositories
setup_personal_repos() {
    log_info "Setting up personal repositories..."
    local personal_dir="$HOME/personal"

    # Create personal directory if it doesn't exist
    if [[ ! -d "$personal_dir" ]]; then
        log_info "Creating personal directory at $personal_dir"
        mkdir -p "$personal_dir"
    fi

    # Array of repositories to clone
    declare -A repos=(
        ["eleven-streamer"]="https://github.com/kolkhis/streamer-mode.nvim"
        ["harpoon"]="https://github.com/Theprimeagen/harpoon"
        ["vim-amp"]="https://github.com/jmacdonald/amp"
        ["vim-apm"]="https://github.com/Theprimeagen/vim-apm"
        ["vim-with-me"]="https://github.com/Theprimeagen/vim-with-me"
        ["caleb"]="https://github.com/calebmadrigal/caleb-vim-config"
    )

    # Clone each repository
    for folder in "${!repos[@]}"; do
        local repo_url="${repos[$folder]}"
        local target_dir="$personal_dir/$folder"

        if [[ -d "$target_dir" ]]; then
            log_warning "Directory $target_dir already exists"
            read -p "Do you want to update it? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log_info "Updating $folder..."
                cd "$target_dir"
                git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || log_warning "Failed to update $folder"
                cd - > /dev/null
            else
                log_warning "Skipping $folder"
            fi
        else
            log_info "Cloning $folder from $repo_url"
            git clone "$repo_url" "$target_dir"
            log_success "$folder cloned successfully"
        fi
    done
}

# Install TPM (Tmux Plugin Manager)
install_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [[ -d "$tpm_dir" ]]; then
        log_info "TPM already exists. Updating..."
        cd "$tpm_dir" && git pull
    else
        log_info "Cloning TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi

    log_success "TPM installed/updated successfully"
}

# Clone tmux configuration repository
clone_tmux_repo() {
    local repo_dir="$HOME/.config/tmux-config"

    if [[ -d "$repo_dir" ]]; then
        log_info "Tmux repository already exists. Updating..."
        cd "$repo_dir" && git pull
    else
        log_info "Cloning tmux configuration repository..."
        git clone https://github.com/wallace-21/tmux.git "$repo_dir"
    fi

    log_success "Tmux repository cloned/updated successfully"
    echo "$repo_dir"
}

# Install tmux configuration from repository
install_tmux_config() {
    local repo_dir=$(clone_tmux_repo)

    if [[ -f "$repo_dir/.tmux.conf" ]]; then
        backup_config "$HOME/.tmux.conf" "tmux config"
        log_info "Installing tmux configuration from repository..."
        cp "$repo_dir/.tmux.conf" ~/.tmux.conf
        log_success "Tmux configuration installed from repository"
    else
        log_error "Configuration file not found in repository!"
        exit 1
    fi
}

# Install tmux plugins
install_tmux_plugins() {
    log_info "Installing tmux plugins..."

    # Kill any existing tmux sessions to avoid conflicts
    tmux kill-server 2>/dev/null || true

    # Start tmux in detached mode and install plugins
    tmux new-session -d -s plugin_install
    tmux send-keys -t plugin_install "~/.tmux/plugins/tpm/scripts/install_plugins.sh" Enter

    # Wait a moment for installation
    sleep 3

    # Kill the temporary session
    tmux kill-session -t plugin_install 2>/dev/null || true

    log_success "Plugins installation initiated"
}

# Main installation function
main() {
    echo -e "${BLUE}"
    echo "========================================"
    echo "   Combined Nvim & Tmux Setup Script"
    echo "========================================"
    echo -e "${NC}"

    # Check for git
    if ! command_exists git; then
        log_error "Git is required but not installed. Please install git first."
        exit 1
    fi

    # Install required packages
    install_packages

    # Setup Nvim
    echo
    log_info "=== NVIM SETUP ==="
    setup_nvim
    setup_personal_repos

    # Setup Tmux
    echo
    log_info "=== TMUX SETUP ==="
    install_tpm
    install_tmux_config
    install_tmux_plugins

    # Final summary
    echo
    echo -e "${BLUE}========================================"
    echo "           Setup Complete!"
    echo "========================================"
    echo -e "${NC}"

    echo -e "${GREEN}Nvim Setup:${NC}"
    echo "• Configuration: $HOME/.config/nvim"
    echo "• Personal repositories: $HOME/personal"
    echo "  - eleven-streamer, harpoon, vim-amp, vim-apm, vim-with-me, caleb"
    echo
    echo -e "${GREEN}Tmux Setup:${NC}"
    echo "• Configuration: $HOME/.tmux.conf"
    echo "• Repository: https://github.com/wallace-21/tmux"
    echo
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Start nvim to trigger plugin installation"
    echo "2. Start tmux: ${GREEN}tmux new-session -s main${NC}"
    echo "3. In tmux, press ${GREEN}Ctrl+a + I${NC} (capital i) to install plugins if needed"
    echo "4. Press ${GREEN}Ctrl+a + r${NC} to reload tmux configuration"
    echo
    echo -e "${BLUE}Tmux key bindings reminder:${NC}"
    echo "• Prefix key: ${GREEN}Ctrl+a${NC} (instead of Ctrl+b)"
    echo "• Split horizontal: ${GREEN}Ctrl+a + -$"
    echo "• Resize panes: ${GREEN}Ctrl+a + h/j/k/l${NC}"
    echo "• Toggle zoom: ${GREEN}Ctrl+a + m${NC}"
    echo
    echo -e "${GREEN}Your development environment is ready!${NC}"
}

# Run with error handling
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi{NC}"
    echo "• Split vertical: ${GREEN}Ctrl+a + =${NC}"
    echo "• Reload config: ${GREEN}Ctrl+a + r${NC}
