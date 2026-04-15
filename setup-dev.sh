#!/usr/bin/env bash

set +e
set -o pipefail

DRY_RUN=false
LOG_FILE="$HOME/setup-dev-$(date +%Y%m%d_%H%M%S).log"

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --help)
            echo "Usage: $0 [--dry-run] [--help]"
            echo "  --dry-run  Preview what would be installed without making changes"
            echo "  --help     Show this help message"
            exit 0
            ;;
    esac
done

ARCH=$(dpkg --print-architecture)
TMPDIR=$(mktemp -d /tmp/setup-dev.XXXXXX)
trap 'rm -rf "$TMPDIR"' EXIT

log() { echo "$@" | tee -a "$LOG_FILE"; }

run_cmd() {
    if $DRY_RUN; then
        log "  [DRY RUN] $*"
        return 0
    fi
    "$@"
}

SUCCESS=()
FAILED=()
SKIPPED=()

report_success() { SUCCESS+=("$1"); }
report_fail() { FAILED+=("$1"); }
report_skip() { SKIPPED+=("$1"); }

is_installed() { command -v "$1" &>/dev/null; }
dir_exists() { [ -d "$1" ]; }

run_install() {
    local NAME=$1
    shift
    log "---- Installing $NAME ----"
    if run_cmd "$@"; then
        report_success "$NAME"
    else
        report_fail "$NAME"
    fi
}

download_and_run() {
    local NAME=$1
    local URL=$2
    shift 2
    log "---- Installing $NAME via remote script ----"
    local script="$TMPDIR/${NAME}-install.sh"
    if ! run_cmd curl -fsSL "$URL" -o "$script"; then
        report_fail "$NAME"
        return 1
    fi
    if run_cmd bash "$script" "$@"; then
        report_success "$NAME"
    else
        report_fail "$NAME"
    fi
}

log ""
log "🚀 Updating system"

run_cmd sudo apt update
run_cmd sudo apt upgrade -y

########################################################
# Base dependencies
########################################################

run_install "Base dependencies" sudo apt install -y \
    curl wget git build-essential software-properties-common \
    apt-transport-https ca-certificates gnupg lsb-release unzip fontconfig

########################################################
# VS CODE
########################################################

if is_installed code; then
    report_skip "VSCode"
else
    log "Installing VSCode"

    run_cmd wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
        | run_cmd gpg --dearmor > "$TMPDIR/packages.microsoft.gpg"

    run_cmd sudo install -o root -g root -m 644 "$TMPDIR/packages.microsoft.gpg" \
        /usr/share/keyrings/

    run_cmd bash -c "echo 'deb [arch=$ARCH signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main' \
        | sudo tee /etc/apt/sources.list.d/vscode.list"

    run_cmd sudo apt update

    run_install "VSCode" sudo apt install -y code
fi

########################################################
# ZED
########################################################

if is_installed zed; then
    report_skip "Zed IDE"
else
    download_and_run "Zed IDE" https://zed.dev/install.sh
fi

########################################################
# TERMINALS
########################################################

if is_installed alacritty; then
    report_skip "Alacritty"
else
    run_install "Alacritty" sudo apt install -y alacritty
fi

if is_installed kitty; then
    report_skip "Kitty"
else
    run_install "Kitty" sudo apt install -y kitty
fi

if is_installed ghostty; then
    report_skip "Ghostty"
else
    log "Installing Ghostty"

    if run_cmd sudo add-apt-repository -y ppa:ghostty-dev/ghostty && \
       run_cmd sudo apt update && \
       run_cmd sudo apt install -y ghostty; then
        report_success "Ghostty"
    else
        log "Ghostty PPA not available, trying fallback"

        if run_cmd wget -O "$TMPDIR/ghostty.tar.gz" \
            "https://github.com/ghostty-org/ghostty/releases/latest/download/ghostty-${ARCH}-linux.tar.gz" && \
           run_cmd tar -xzf "$TMPDIR/ghostty.tar.gz" -C "$TMPDIR" && \
           run_cmd sudo mv "$TMPDIR"/ghostty*/ghostty /usr/local/bin/; then
            report_success "Ghostty (binary)"
        else
            report_fail "Ghostty"
        fi
    fi
fi

########################################################
# FASTFETCH
########################################################

if is_installed fastfetch; then
    report_skip "Fastfetch"
else
    log "Installing Fastfetch"
    run_cmd sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
    run_cmd sudo apt update
    run_install "Fastfetch" sudo apt install -y fastfetch
fi

########################################################
# DOCKER
########################################################

if is_installed docker; then
    report_skip "Docker"
else
    log "Installing Docker"

    run_cmd sudo install -m 0755 -d /etc/apt/keyrings

    run_cmd bash -c "curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg"

    run_cmd bash -c "echo 'deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable' \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"

    run_cmd sudo apt update

    run_install "Docker" sudo apt install -y \
        docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin

    run_cmd sudo usermod -aG docker "$USER"
fi

########################################################
# OBSIDIAN
########################################################

if is_installed obsidian; then
    report_skip "Obsidian"
else
    log "Installing Obsidian"

    URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
        | grep browser_download_url | grep "${ARCH}.deb" | cut -d '"' -f 4)

    if [ -z "$URL" ]; then
        report_fail "Obsidian"
    else
        if run_cmd wget "$URL" -O "$TMPDIR/obsidian.deb" && \
           run_cmd sudo apt install -y "$TMPDIR/obsidian.deb"; then
            report_success "Obsidian"
        else
            report_fail "Obsidian"
        fi
    fi
fi

########################################################
# CLI TOOLS
########################################################

run_install "CLI tools" sudo apt install -y \
    bat ripgrep fd-find jq fzf btop tmux

########################################################
# LSD
########################################################

if is_installed lsd; then
    report_skip "lsd"
else
    log "Installing lsd"

    LSD_VERSION="1.1.2"

    if run_cmd wget -O "$TMPDIR/lsd.deb" \
        "https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/lsd_${LSD_VERSION}_${ARCH}.deb" && \
       run_cmd sudo dpkg -i "$TMPDIR/lsd.deb"; then
        report_success "lsd"
    else
        report_fail "lsd"
    fi
fi

########################################################
# ZSH + OH MY ZSH
########################################################

if is_installed zsh; then
    report_skip "zsh"
else
    run_install "zsh" sudo apt install -y zsh
fi

if dir_exists "$HOME/.oh-my-zsh"; then
    report_skip "Oh My Zsh"
else
    log "Installing Oh My Zsh"

    if run_cmd bash -c "RUNZSH=no CHSH=no sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""; then
        report_success "Oh My Zsh"
    else
        report_fail "Oh My Zsh"
    fi
fi

########################################################
# POWERLEVEL10K
########################################################

if dir_exists "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"; then
    report_skip "Powerlevel10k"
else
    log "Installing Powerlevel10k"

    if run_cmd git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"; then
        report_success "Powerlevel10k"
    else
        report_fail "Powerlevel10k"
    fi
fi

########################################################
# ZSH PLUGINS
########################################################

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

for plugin_repo in \
    "zsh-users/zsh-autosuggestions" \
    "zsh-users/zsh-syntax-highlighting"; do
    plugin_name=$(basename "$plugin_repo")
    plugin_dir="$ZSH_CUSTOM/plugins/$plugin_name"

    if dir_exists "$plugin_dir"; then
        report_skip "$plugin_name"
    else
        log "Installing $plugin_name"
        if run_cmd git clone "https://github.com/$plugin_repo" "$plugin_dir"; then
            report_success "$plugin_name"
        else
            report_fail "$plugin_name"
        fi
    fi
done

########################################################
# STARSHIP
########################################################

if is_installed starship; then
    report_skip "Starship"
else
    download_and_run "Starship" https://starship.rs/install.sh -- -y
fi

########################################################
# UV
########################################################

if is_installed uv; then
    report_skip "uv (python manager)"
else
    download_and_run "uv (python manager)" https://astral.sh/uv/install.sh
fi

########################################################
# LAZYGIT
########################################################

if is_installed lazygit; then
    report_skip "lazygit"
else
    log "Installing lazygit"

    LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f 4)

    if [ -z "$LAZYGIT_VERSION" ]; then
        report_fail "lazygit"
    else
        LAZYGIT_VER_NUM="${LAZYGIT_VERSION#v}"

        if run_cmd curl -Lo "$TMPDIR/lazygit.tar.gz" \
            "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VER_NUM}_Linux_${ARCH}.tar.gz" && \
           run_cmd tar xf "$TMPDIR/lazygit.tar.gz" -C "$TMPDIR" lazygit && \
           run_cmd sudo install "$TMPDIR/lazygit" /usr/local/bin; then
            report_success "lazygit"
        else
            report_fail "lazygit"
        fi
    fi
fi

########################################################
# LAZYDOCKER
########################################################

if is_installed lazydocker; then
    report_skip "lazydocker"
else
    download_and_run "lazydocker" https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh
fi

########################################################
# NERD FONTS
########################################################

log "Installing Nerd Fonts"

mkdir -p ~/.local/share/fonts

fonts=(JetBrainsMono FiraCode Hack SourceCodePro UbuntuMono)

for font in "${fonts[@]}"; do
    if compgen -G "$HOME/.local/share/fonts/${font}*" >/dev/null; then
        log "  $font already installed, skipping"
        continue
    fi

    if run_cmd wget -O "$TMPDIR/$font.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip" && \
       run_cmd unzip "$TMPDIR/$font.zip" -d "$TMPDIR/$font" && \
       run_cmd cp "$TMPDIR/$font/"*.ttf ~/.local/share/fonts/; then
        log "  $font installed"
    else
        log "  $font failed"
    fi

    rm -rf "$TMPDIR/$font" "$TMPDIR/$font.zip"
done

run_cmd fc-cache -fv

report_success "Nerd Fonts"

########################################################
# FINAL REPORT
########################################################

log ""
log "============================"
log " INSTALLATION REPORT"
log "============================"
log ""
log "Log file: $LOG_FILE"

if $DRY_RUN; then
    log "  (DRY RUN - no changes were made)"
fi

log ""
log "SUCCESS:"
for item in "${SUCCESS[@]}"; do
    log "  ✓ $item"
done

log ""
log "FAILED:"
for item in "${FAILED[@]}"; do
    log "  ✗ $item"
done

log ""
log "SKIPPED:"
for item in "${SKIPPED[@]}"; do
    log "  - $item"
done

log ""
log "⚠️  Recommended: reboot your system"
log "Then run:"
log "p10k configure"
log ""
