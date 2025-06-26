# Development Environment Setup Script

A comprehensive shell script to automatically set up your complete development environment with Neovim and Tmux configurations, plugins, and essential tools.

## Overview

This script automates the setup of:
- **Neovim configuration** with essential plugins and development tools
- **Tmux configuration** with productivity-focused key bindings and plugins
- **Cross-platform package installation** (tmux, neovim)
- **Organized directory structure** for easy management

## What It Does

### 1. Package Installation
- Automatically detects your OS (Ubuntu, CentOS, Arch, macOS)
- Installs tmux and neovim if not already present
- Uses appropriate package manager for your system

### 2. Neovim Configuration
- Clones the main configuration from [`wallace-21/init.lua`](https://github.com/wallace-21/init.lua)
- Installs to `~/.config/nvim/`
- Backs up existing configurations safely

### 3. Personal Plugin Collection
Creates `~/personal/` directory and clones essential Neovim repositories:

| Plugin | Repository | Description |
|--------|------------|-------------|
| **eleven-streamer** | [kolkhis/streamer-mode.nvim](https://github.com/kolkhis/streamer-mode.nvim) | Streamer mode functionality |
| **harpoon** | [Theprimeagen/harpoon](https://github.com/Theprimeagen/harpoon) | Quick file navigation |
| **vim-amp** | [jmacdonald/amp](https://github.com/jmacdonald/amp) | Vim amplifier utilities |
| **vim-apm** | [Theprimeagen/vim-apm](https://github.com/Theprimeagen/vim-apm) | Actions per minute tracking |
| **vim-with-me** | [Theprimeagen/vim-with-me](https://github.com/Theprimeagen/vim-with-me) | Collaborative editing |
| **caleb** | [calebmadrigal/caleb-vim-config](https://github.com/calebmadrigal/caleb-vim-config) | Additional Vim configuration |

### 4. Tmux Configuration
- Clones configuration from [`wallace-21/tmux`](https://github.com/wallace-21/tmux)
- Installs TPM (Tmux Plugin Manager)
- Automatically installs and configures plugins:
  - **vim-tmux-navigator**: Seamless navigation between vim and tmux
  - **tmux-themepack**: Beautiful powerline theme (cyan)
  - **tmux-resurrect**: Session persistence
  - **tmux-continuum**: Automatic session saving/restoring

## Prerequisites

- **Git**: Required for cloning repositories
- **Unix-like system**: Linux, macOS, or WSL
- **Bash shell**: Script is written in Bash
- **sudo access**: For package installation (if packages are missing)

## Installation

### Quick Setup

```bash
# One-line install from repository
curl -fsSL https://raw.githubusercontent.com/wallace-21/tmux/main/setup.sh | bash

# Or download and run manually
curl -O https://raw.githubusercontent.com/wallace-21/tmux/main/setup.sh
chmod +x setup.sh
./setup.sh
```

### Manual Setup

1. **Clone the repository**: `git clone https://github.com/wallace-21/tmux.git`
2. **Navigate to directory**: `cd tmux`
3. **Make executable**: `chmod +x setup.sh`
4. **Run setup**: `./setup.sh`

## Features

### Safety Features
- ✅ **Backup Protection**: Automatically backs up existing configurations with timestamps
- ✅ **Interactive Prompts**: Asks for confirmation before overwriting
- ✅ **Error Handling**: Exits safely on errors to prevent partial setups
- ✅ **Dependency Checking**: Verifies Git installation before proceeding
- ✅ **Cross-platform Support**: Works on Ubuntu, CentOS, Arch Linux, and macOS

### User Experience
- 🎨 **Colored Output**: Clear visual feedback with colored status messages
- 📝 **Detailed Logging**: Informative messages throughout the process
- 🔄 **Update Support**: Can update existing repositories and configurations
- 📊 **Comprehensive Summary**: Shows what was installed and where
- ⚡ **One-command Setup**: Complete environment setup with single script

## Directory Structure

After running the script, your setup will look like:

```
~/.config/nvim/              # Main Neovim configuration
~/.config/tmux-config/       # Tmux configuration repository
~/.tmux.conf                 # Tmux configuration file
~/.tmux/plugins/             # Tmux plugins directory
~/personal/                  # Personal plugin collection
├── eleven-streamer/         # Streamer mode plugin
├── harpoon/                # File navigation
├── vim-amp/                # Vim utilities
├── vim-apm/                # APM tracking
├── vim-with-me/            # Collaborative editing
└── caleb/                  # Additional config
```

## Tmux Key Bindings

The tmux configuration includes these productivity-focused key bindings:

| Key Combination | Action |
|----------------|--------|
| `Ctrl+a` | Prefix key (instead of default `Ctrl+b`) |
| `Prefix + -` | Split window horizontally |
| `Prefix + =` | Split window vertically |
| `Prefix + r` | Reload tmux configuration |
| `Prefix + m` | Toggle pane zoom (maximize/minimize) |

### Pane Resizing (Repeatable)
| Key | Action |
|-----|--------|
| `Prefix + h` | Resize pane left by 5 units |
| `Prefix + j` | Resize pane down by 5 units |
| `Prefix + k` | Resize pane up by 5 units |
| `Prefix + l` | Resize pane right by 5 units |

### Copy Mode Bindings
| Key | Action |
|-----|--------|
| `v` | Begin visual selection (in copy mode) |
| `y` | Copy selection (in copy mode) |

## Getting Started

### After Installation

**For Neovim:**
1. Start Neovim: `nvim`
2. Install language servers: `:Mason` then install needed LSPs
3. Update plugins: Use your plugin manager's update command
4. Customize: Edit configurations in `~/.config/nvim/`

**For Tmux:**
1. Start a new tmux session: `tmux new-session -s main`
2. Press `Ctrl+a + I` (capital i) to install plugins if needed
3. Press `Ctrl+a + r` to reload configuration
4. Use `Ctrl+a + ?` to see all key bindings

### Quick Tmux Usage
- **Create session**: `tmux new-session -s mysession`
- **Attach to session**: `tmux attach-session -t mysession`
- **List sessions**: `tmux list-sessions`
- **Split horizontally**: `Ctrl+a + -`
- **Split vertically**: `Ctrl+a + =`
- **Navigate panes**: Use mouse or vim-tmux-navigator

## Troubleshooting

### Common Issues

**Git not found:**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install git

# macOS (install Homebrew first)
brew install git

# Arch Linux
sudo pacman -S git
```

**Permission denied:**
```bash
chmod +x setup.sh
```

**Packages not installing:**
- Ensure you have sudo access
- Check your internet connection
- Verify your package manager is working

**Tmux plugins not working:**
- Ensure TPM is installed correctly
- Press `Ctrl+a + I` to install plugins manually
- Check plugin documentation for specific requirements

**Neovim LSP issues:**
If you encounter issues with language servers, ensure you have the required tools:

```bash
# For Go development (example)
go version  # Should be 1.18+

# For Node.js tools
node --version
npm --version
```

### Key Bindings Not Working
- Verify tmux configuration is loaded: `Ctrl+a + r`
- Check for conflicting key bindings
- Ensure you're using the correct prefix key (`Ctrl+a`)

## Customization

### Adding More Neovim Repositories

Edit the `repos` array in the script:

```bash
declare -A repos=(
    ["your-plugin"]="https://github.com/user/repo"
    # ... existing repos
)
```

### Changing Directories

Modify these variables in the script:

```bash
NVIM_CONFIG_DIR="$HOME/.config/nvim"
PERSONAL_DIR="$HOME/personal"
```

### Tmux Customization

You can modify the tmux configuration by:
- Editing `~/.tmux.conf` directly
- Changing theme: Modify the `@themepack` setting
- Adding more plugins: Add `set -g @plugin 'plugin-name'` lines
- Adjusting key bindings: Use `bind` and `unbind` commands

## Supported Platforms

- **Ubuntu/Debian**: `apt-get`
- **CentOS/RHEL**: `yum`
- **Arch Linux**: `pacman`
- **macOS**: `brew` (Homebrew required)

## Contributing

Feel free to submit issues and pull requests to improve the setup script or configurations.

## License

This setup script is provided as-is for personal use. Individual repositories and plugins have their own licenses.

---

**Happy Coding!** 🚀

*Complete development environment setup in one command - from zero to hero!*
