#!/usr/bin/env bash

set +e

SUCCESS=()
FAILED=()
SKIPPED=()

report_success () { SUCCESS+=("$1"); }
report_fail () { FAILED+=("$1"); }
report_skip () { SKIPPED+=("$1"); }

run_install () {
    NAME=$1
    shift
    echo "---- Installing $NAME ----"
    "$@"
    if [ $? -eq 0 ]; then
        report_success "$NAME"
    else
        report_fail "$NAME"
    fi
}

echo "🚀 Updating system"

sudo apt update
sudo apt upgrade -y

########################################################
# Base dependencies
########################################################

run_install "Base dependencies" sudo apt install -y \
curl wget git build-essential software-properties-common \
apt-transport-https ca-certificates gnupg lsb-release unzip fontconfig

########################################################
# VS CODE
########################################################

echo "Installing VSCode"

wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
| gpg --dearmor > packages.microsoft.gpg

sudo install -o root -g root -m 644 packages.microsoft.gpg \
/usr/share/keyrings/

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
| sudo tee /etc/apt/sources.list.d/vscode.list

sudo apt update

run_install "VSCode" sudo apt install -y code

########################################################
# ZED
########################################################

run_install "Zed IDE" bash -c "curl -fsSL https://zed.dev/install.sh | sh"

########################################################
# TERMINALS
########################################################

run_install "Alacritty" sudo apt install -y alacritty

echo "Installing Ghostty"

sudo add-apt-repository -y ppa:ghostty-dev/ghostty

sudo apt update

if sudo apt install -y ghostty; then
    report_success "Ghostty"
else
    echo "Ghostty PPA not available, trying fallback"

    wget -O ghostty.tar.gz \
    https://github.com/ghostty-org/ghostty/releases/latest/download/ghostty-x86_64-linux.tar.gz

    if [ $? -eq 0 ]; then
        tar -xzf ghostty.tar.gz
        sudo mv ghostty*/ghostty /usr/local/bin/
        rm -rf ghostty*
        report_success "Ghostty (binary)"
    else
        report_fail "Ghostty"
    fi
fi

########################################################
# DOCKER
########################################################

echo "Installing Docker"

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
| sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

run_install "Docker" sudo apt install -y \
docker-ce docker-ce-cli containerd.io \
docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER

########################################################
# OBSIDIAN (auto detect latest)
########################################################

echo "Installing Obsidian"

URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
| grep browser_download_url | grep amd64.deb | cut -d '"' -f 4)

if [ -z "$URL" ]; then
    report_fail "Obsidian"
else
    wget $URL -O obsidian.deb
    sudo apt install -y ./obsidian.deb
    rm obsidian.deb
    report_success "Obsidian"
fi

########################################################
# CLI TOOLS
########################################################

run_install "CLI tools" sudo apt install -y \
bat ripgrep fd-find jq fzf btop tmux

########################################################
# LSD
########################################################

echo "Installing lsd"

LSD_VERSION="1.1.2"

wget https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/lsd_${LSD_VERSION}_amd64.deb

if sudo dpkg -i lsd_${LSD_VERSION}_amd64.deb; then
    report_success "lsd"
else
    report_fail "lsd"
fi

rm lsd_${LSD_VERSION}_amd64.deb

########################################################
# ZSH + OH MY ZSH
########################################################

run_install "zsh" sudo apt install -y zsh

echo "Installing Oh My Zsh"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    report_success "Oh My Zsh"
else
    report_skip "Oh My Zsh"
fi

########################################################
# POWERLEVEL10K
########################################################

echo "Installing Powerlevel10k"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

if [ $? -eq 0 ]; then
    report_success "Powerlevel10k"
else
    report_fail "Powerlevel10k"
fi

########################################################
# ZSH PLUGINS
########################################################

git clone https://github.com/zsh-users/zsh-autosuggestions \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

########################################################
# STARSHIP
########################################################

run_install "Starship" bash -c "curl -sS https://starship.rs/install.sh | sh -s -- -y"

########################################################
# UV
########################################################

run_install "uv (python manager)" bash -c "curl -Ls https://astral.sh/uv/install.sh | sh"

########################################################
# LAZYGIT
########################################################

echo "Installing lazygit"

LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f 4)

curl -Lo lazygit.tar.gz \
https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz

tar xf lazygit.tar.gz lazygit

sudo install lazygit /usr/local/bin

rm lazygit lazygit.tar.gz

report_success "lazygit"

########################################################
# LAZYDOCKER
########################################################

run_install "lazydocker" bash -c "curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash"

########################################################
# NERD FONTS
########################################################

echo "Installing Nerd Fonts"

mkdir -p ~/.local/share/fonts
cd /tmp

fonts=(JetBrainsMono FiraCode Hack SourceCodePro UbuntuMono)

for font in "${fonts[@]}"
do
    wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip
    unzip $font.zip -d $font
    cp $font/*.ttf ~/.local/share/fonts/
    rm -rf $font $font.zip
done

fc-cache -fv

report_success "Nerd Fonts"

########################################################
# FINAL REPORT
########################################################

echo ""
echo "============================"
echo " INSTALLATION REPORT"
echo "============================"

echo ""
echo "SUCCESS:"
for item in "${SUCCESS[@]}"; do
    echo "  ✓ $item"
done

echo ""
echo "FAILED:"
for item in "${FAILED[@]}"; do
    echo "  ✗ $item"
done

echo ""
echo "SKIPPED:"
for item in "${SKIPPED[@]}"; do
    echo "  - $item"
done

echo ""
echo "⚠️  Recommended: reboot your system"
echo "Then run:"
echo "p10k configure"
echo ""
