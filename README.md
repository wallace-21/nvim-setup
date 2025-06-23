# Neovim Environment Setup Script

A shell script to automatically set up your Neovim development environment with essential configurations and plugin repositories.

## Overview

This script automates the setup of:
- Main Neovim configuration from a personal repository
- Collection of useful Neovim plugins and tools for development
- Organized directory structure for easy management

## What It Does

### 1. Neovim Configuration
- Clones the main configuration from `github.com/wallace-21/init.lua`
- Installs to `~/.config/nvim/`
- Backs up existing configurations safely

### 2. Personal Plugin Collection
Creates `~/personal/` directory and clones the following repositories:

| Plugin | Repository | Description |
|--------|------------|-------------|
| **eleven-streamer** | [kolkhis/streamer-mode.nvim](https://github.com/kolkhis/streamer-mode.nvim) | Streamer mode functionality |
| **harpoon** | [Theprimeagen/harpoon](https://github.com/Theprimeagen/harpoon) | Quick file navigation |
| **vim-amp** | [jmacdonald/amp](https://github.com/jmacdonald/amp) | Vim amplifier utilities |
| **vim-apm** | [Theprimeagen/vim-apm](https://github.com/Theprimeagen/vim-apm) | Actions per minute tracking |
| **vim-with-me** | [Theprimeagen/vim-with-me](https://github.com/Theprimeagen/vim-with-me) | Collaborative editing |
| **caleb** | [calebmadrigal/caleb-vim-config](https://github.com/calebmadrigal/caleb-vim-config) | Additional Vim configuration |

## Prerequisites

- **Git**: Required for cloning repositories
- **Unix-like system**: Linux, macOS, or WSL
- **Bash shell**: Script is written in Bash
- **Ripgrep**: Required before running the script

## Installation

### Quick Setup

```bash
# Download the script
curl -O https://raw.githubusercontent.com/your-repo/nvim-setup.sh

# Make it executable
chmod +x nvim-setup.sh

# Run the setup
./nvim-setup.sh
```

### Manual Setup

1. **Download the script**: Save `nvim-setup.sh` to your preferred location
2. **Make executable**: `chmod +x nvim-setup.sh`
3. **Run**: `./nvim-setup.sh`

## Features

### Safety Features
- ✅ **Backup Protection**: Automatically backs up existing configurations
- ✅ **Interactive Prompts**: Asks for confirmation before overwriting
- ✅ **Error Handling**: Exits safely on errors to prevent partial setups
- ✅ **Dependency Checking**: Verifies Git installation before proceeding

### User Experience
- 🎨 **Colored Output**: Clear visual feedback with colored status messages
- 📝 **Detailed Logging**: Informative messages throughout the process
- 🔄 **Update Support**: Can update existing repositories
- 📊 **Summary Report**: Shows what was installed and where

## Directory Structure

After running the script, your setup will look like:

```
~/.config/nvim/          # Main Neovim configuration
~/personal/              # Personal plugin collection
├── eleven-streamer/     # Streamer mode plugin
├── harpoon/            # File navigation
├── vim-amp/            # Vim utilities
├── vim-apm/            # APM tracking
├── vim-with-me/        # Collaborative editing
└── caleb/              # Additional config
```

## Troubleshooting

### Common Issues

**Git not found:**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install git

# macOS
brew install git

# Arch Linux
sudo pacman -S git
```

**Permission denied:**
```bash
chmod +x nvim-setup.sh
```

**Directory already exists:**
- The script will prompt you to backup/update existing directories
- Choose 'y' to backup and replace, or 'N' to skip

### Mason LSP Issues

If you encounter issues with language servers (like `gopls`), ensure you have the required language tools installed:

**For Go development:**
```bash
# Check Go version (needs 1.18+)
go version

# Update if needed
sudo rm -rf /usr/local/go
wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
```

## Customization

### Adding More Repositories

Edit the `repos` array in the script:

```bash
declare -A repos=(
    ["your-plugin"]="https://github.com/user/repo"
    # ... existing repos
)
```

### Changing Directories

Modify these variables at the top of the script:

```bash
NVIM_CONFIG_DIR="$HOME/.config/nvim"
PERSONAL_DIR="$HOME/personal"
```

## Usage Tips

### After Installation

1. **Start Neovim**: `nvim`
2. **Install language servers**: `:Mason` then install needed LSPs
3. **Update plugins**: Use your plugin manager's update command
4. **Customize**: Edit configurations in `~/.config/nvim/`

## License

This setup script is provided as-is for personal use. Individual repositories have their own licenses.

---

**Happy Coding!** 🚀
