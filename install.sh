#!/bin/bash

# This script installs the necessary dependencies for the project.
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Icons
CHECK="✅"
CROSS="❌"
ARROW="➜"
STAR="⭐"
GIT="🐙"
CURL="🌐"
NVIM="🚀"
CONFIG="⚙️"
PLUG="🔌"
PKG="📦"

# Clear screen and show header
clear
echo -e "${CYAN}${BOLD}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║           Abel Santillan Rodriguez (abelsr)                ║"
echo "║              Dotfiles Installation Script                  ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "${BLUE}${ARROW} Starting installation process...${NC}"
echo ""

# Check if git is installed
echo -e "${YELLOW}[1/5]${NC} ${GIT} Checking git installation..."
if ! command -v git &> /dev/null
then
    echo -e "${RED}${CROSS} Git could not be found${NC}"
    echo -e "${YELLOW}${ARROW} Please install git first and try again.${NC}"
    exit 1
else
    echo -e "${GREEN}${CHECK} Git is installed${NC}"
fi
echo ""

# Install curl if not installed
echo -e "${YELLOW}[2/5]${NC} ${CURL} Checking curl installation..."
if ! command -v curl &> /dev/null
then
    echo -e "${YELLOW}${ARROW} Curl not found, installing...${NC}"
    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install -y curl
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y curl
    fi
    echo -e "${GREEN}${CHECK} Curl installed successfully${NC}"
else
    echo -e "${GREEN}${CHECK} Curl is already installed${NC}"
fi
echo ""

# Install nvim if not installed
echo -e "${YELLOW}[3/5]${NC} ${NVIM} Checking Neovim installation..."
if ! command -v nvim &> /dev/null
then
    echo -e "${YELLOW}${ARROW} Neovim not found, installing...${NC}"
    # For Debian-based systems
    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install -y neovim
    # For Red Hat-based systems
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y neovim
    else
        echo -e "${RED}${CROSS} Could not detect package manager${NC}"
        echo -e "${YELLOW}${ARROW} Please install Neovim manually.${NC}"
        exit 1
    fi
    echo -e "${GREEN}${CHECK} Neovim installed successfully${NC}"
else
    echo -e "${GREEN}${CHECK} Neovim is already installed${NC}"
fi
echo ""

# Copying nvim configuration to the user's config directory
echo -e "${YELLOW}[4/5]${NC} ${CONFIG} Copying Neovim configuration..."
mkdir -p ~/.config/nvim
cp -r nvim/* ~/.config/nvim/
echo -e "${GREEN}${CHECK} Configuration files copied to ~/.config/nvim/${NC}"
echo ""

# Install vim-plug for nvim (after copying config)
echo -e "${YELLOW}[5/5]${NC} ${PLUG} Setting up vim-plug..."
PLUG_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [ ! -f "$PLUG_PATH" ]; then
    echo -e "${YELLOW}${ARROW} Downloading vim-plug...${NC}"
    curl -fLo "$PLUG_PATH" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo -e "${GREEN}${CHECK} vim-plug installed successfully${NC}"
else
    echo -e "${GREEN}${CHECK} vim-plug is already installed${NC}"
fi
echo ""

# Install nvim plugins
echo -e "${MAGENTA}${PKG} Installing Neovim plugins...${NC}"
echo -e "${CYAN}   This may take a few moments...${NC}"
echo ""
nvim --headless +"source ~/.config/nvim/Plugins/plugins.vim" +"PlugInstall --sync" +qall 2>/dev/null || {
    echo -e "${YELLOW}${ARROW} Retrying plugin installation...${NC}"
    nvim --headless +"PlugInstall --sync" +qall
}
echo ""
echo -e "${GREEN}${CHECK} All plugins installed successfully${NC}"
echo ""
echo -e "${GREEN}${BOLD}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║              ${STAR} Installation Completed! ${STAR}                 ║"
echo "║                                                            ║"
echo "║  Your Neovim environment is ready to use.                  ║"
echo "║  Run 'nvim' to start editing!                              ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"