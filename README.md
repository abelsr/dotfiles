# abelsr's Dotfiles

This repository contains my personal configuration files (dotfiles), mainly focused on **Neovim** and **Fastfetch**.

## 🚀 Installation

The repository includes an automated installation script to facilitate the process.

1. Clone the repository:

   ```bash
   git clone https://github.com/abelsr/dotfiles.git
   cd dotfiles
   ```

2. Run the installation script:

   ```bash
   ./install.sh
   ```

   This script will install:
   *   **Neovim** and its plugins.
   *   **Fastfetch** and its configuration.

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

## 🖥️ Fastfetch Configuration

Includes a custom configuration for **Fastfetch** located in `fastfetch/config.jsonc`, providing a clean and informative system summary.

## 📂 Project Structure

```text
dotfiles/
├── fastfetch/          # Fastfetch configuration
│   └── config.jsonc
├── install.sh          # Installation script
├── nvim/
│   ├── init.vim        # Main configuration
│   ├── Keybindings/    # Key mappings
│   ├── Plugins/        # Plugin list
│   └── Themes/         # Theme configuration
└── README.md
```

## 📝 License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

