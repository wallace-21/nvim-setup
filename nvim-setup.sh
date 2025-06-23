#!/bin/bash

# Nvim Environment Setup Script
# This script sets up your nvim configuration and clones required repositories

set -e  # Exit on any error

echo "Setting up nvim environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install git first."
    exit 1
fi

# 1. Clone main nvim configuration
print_status "Setting up nvim configuration..."
NVIM_CONFIG_DIR="$HOME/.config/nvim"

if [ -d "$NVIM_CONFIG_DIR" ]; then
    print_warning "Nvim config directory already exists at $NVIM_CONFIG_DIR"
    read -p "Do you want to backup and replace it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Backing up existing config to $NVIM_CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$NVIM_CONFIG_DIR" "$NVIM_CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
    else
        print_warning "Skipping nvim config setup"
    fi
fi

if [ ! -d "$NVIM_CONFIG_DIR" ]; then
    print_status "Cloning nvim configuration from github.com/wallace-21/init.lua"
    git clone https://github.com/wallace-21/init.lua "$NVIM_CONFIG_DIR"
    print_status "Nvim configuration cloned successfully"
fi

# 2. Create personal directory and clone repositories
print_status "Setting up personal repositories..."
PERSONAL_DIR="$HOME/personal"

# Create personal directory if it doesn't exist
if [ ! -d "$PERSONAL_DIR" ]; then
    print_status "Creating personal directory at $PERSONAL_DIR"
    mkdir -p "$PERSONAL_DIR"
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
    repo_url="${repos[$folder]}"
    target_dir="$PERSONAL_DIR/$folder"

    if [ -d "$target_dir" ]; then
        print_warning "Directory $target_dir already exists"
        read -p "Do you want to update it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Updating $folder..."
            cd "$target_dir"
            git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || print_warning "Failed to update $folder"
            cd - > /dev/null
        else
            print_warning "Skipping $folder"
        fi
    else
        print_status "Cloning $folder from $repo_url"
        git clone "$repo_url" "$target_dir"
        print_status "$folder cloned successfully"
    fi
done

print_status "Setup complete!"
echo
echo "Summary:"
echo "- Nvim configuration: $NVIM_CONFIG_DIR"
echo "- Personal repositories: $PERSONAL_DIR"
echo "  - eleven-streamer"
echo "  - harpoon"
echo "  - vim-amp"
echo "  - vim-apm"
echo "  - vim-with-me"
echo "  - caleb"
echo
print_status "Your nvim environment is ready!"
