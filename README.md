# abelsr's Dotfiles

This repository contains my personal configuration files (dotfiles) for **Neovim**, **Kitty**, **Fastfetch**, and a full dev environment setup script.

## 🚀 Installation

### Dotfiles (Neovim, Kitty, Fastfetch)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/abelsr/dotfiles/main/install.sh)
```

Or clone and run manually:

```bash
git clone https://github.com/abelsr/dotfiles.git && cd dotfiles && ./install.sh
```

This installs and configures:
* **Neovim** and its plugins
* **Kitty** terminal (Catppuccin Mocha theme)
* **Fastfetch** and its configuration

### Full dev environment

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/abelsr/dotfiles/main/setup-dev.sh)
```

Or with a dry run first:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/abelsr/dotfiles/main/setup-dev.sh) --dry-run
```

This sets up:
* **Editors**: VS Code, Zed
* **Terminals**: Alacritty, Kitty, Ghostty
* **Docker** (CE + Compose)
* **Shell**: Zsh + Oh My Zsh + Powerlevel10k + plugins
* **CLI tools**: bat, ripgrep, fd, jq, fzf, btop, tmux, lsd, lazygit, lazydocker, starship, uv
* **Apps**: Obsidian
* **Nerd Fonts**: JetBrainsMono, FiraCode, Hack, SourceCodePro, UbuntuMono

## 🛠️ Neovim Configuration

The Neovim configuration is modularized in the `nvim/` folder and includes:

### 🔌 Main Plugins

Managed with [vim-plug](https://github.com/junegunn/vim-plug):

* **File Navigation**: `NERDTree`
* **Autocompletion & Intelligence**: `Coc.nvim`, `GitHub Copilot`
* **Interface & Style**: `vim-airline`, `Dracula theme`, `vim-devicons`
* **Tabs/Buffers Management**: `barbar.nvim`
* **Utilities**: `NERD Commenter`, `Auto-pairs`, `Split-term`
* **Git**: `gitsigns.nvim`

### ⌨️ Keybindings

Some of the most useful custom shortcuts defined in `nvim/Keybindings/keybindings.vim`:

| Shortcut | Action |
| :--- | :--- |
| `Ctrl + S` | Save file |
| `Ctrl + W` | Close window/buffer |
| `Ctrl + B` | Open/Close NERDTree |
| `Ctrl + J` | Open integrated terminal |
| `Ctrl + Z` | Undo |
| `Ctrl + F` | Search |
| `Ctrl + Alt + K` | Comment/Uncomment lines |
| `Ctrl + Alt + R` | Reload configuration (`init.vim`) |
| `Ctrl + Arrows` | Move between windows |
| `Ctrl + Shift + Arrows` | Resize windows |

### 🎨 Theme

* **Theme**: Dracula
* **Icons**: Requires a [Nerd Font](https://www.nerdfonts.com/) installed in your terminal to correctly visualize icons.

## 🐱 Kitty Configuration

Catppuccin Mocha themed terminal with:
* JetBrainsMono Nerd Font
* Powerline tab bar (bottom)
* Pane splits and vim-style navigation (`alt+h/j/k/l`)
* Resize panes with `ctrl+alt+h/j/k/l`

## 🖥️ Fastfetch Configuration

Box-style system summary with Kitty image logo, showing user, distro, kernel, terminal, shell, IP, CPU, GPU, VRAM, iGPU, RAM, disk, and colors.

## 📂 Project Structure

```text
dotfiles/
├── fastfetch/          # Fastfetch configuration
│   └── config.jsonc
├── install.sh          # Dotfiles installation script
├── kitty/              # Kitty terminal configuration
│   └── kitty.conf
├── nvim/
│   ├── init.vim        # Main configuration
│   ├── Keybindings/    # Key mappings
│   ├── Plugins/        # Plugin list
│   └── Themes/         # Theme configuration
├── setup-dev.sh        # Full dev environment setup
└── README.md
```

## 📝 License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
