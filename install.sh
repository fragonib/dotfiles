#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
purple='\033[0;35m'
normal='\033[0m'

_w() {
  local -r text="${1:-}"
  echo -e "$text"
}
_a() { _w " > $1"; }
_e() { _a "${red}$1${normal}"; }
_s() { _a "${green}$1${normal}"; }
_q() { read -rp "🤔 $1: " "$2"; }

_w "  ┌──────────────────────────────────────────┐"
_w "~ │ 🚀 Welcome to the ${green}dotfiles${normal} installer! │ ~"
_w "  └──────────────────────────────────────────┘"
_w
_q "Confirm to install dotfiles (default ~/.dotfiles)" INSTALL_PATH
INSTALL_PATH=${INSTALL_PATH:-~/.dotfiles}
[ ! -d $INSTALL_PATH ] && git clone https://github.com/fragonib/.dots.git $INSTALL_PATH
cd $INSTALL_PATH

_a "Initializing submodules"
git submodule update --init --recursive

_a "Initializing dotly"
DOTFILES_PATH="$INSTALL_PATH" DOTLY_PATH="$INSTALL_PATH/modules/dotly" "$INSTALL_PATH/modules/dotly/bin/dot" self install
_a "Initializing dotly"
DOTFILES_PATH="$INSTALL_PATH" DOTLY_PATH="$INSTALL_PATH/modules/dotly" "$INSTALL_PATH/modules/dotly/bin/dot" symlinks apply

_a "Initializing zim"
zsh $INSTALL_PATH/modules/dotly/modules/zimfw/zimfw.zsh install

_a "Installing archlinux packages..."
grep -v '#' ./os/linux/archlinux-packages | yay -S --noconfirm

_a "Installing packages..."
DOTFILES_PATH="$INSTALL_PATH" DOTLY_PATH="$INSTALL_PATH/modules/dotly" "$INSTALL_PATH/modules/dotly/bin/dot" package import

# Install vim-plug
curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &> /dev/null

_a "Initializing vim…"
# Install neovim plugins
if type /usr/bin/nvim >/dev/null 2>&1; then
    /usr/bin/nvim +'PlugInstall --sync' +qall
fi

# Install vim plugins
if type /usr/bin/vim >/dev/null 2>&1; then
    /usr/bin/vim +'PlugInstall --sync' +qall
fi
_a "Installing k9s skin..."
curl -q https://raw.githubusercontent.com/derailed/k9s/master/skins/stock.yml --output ~/.k9s/skin.yml &> /dev/null

if [ "`grep user $HOME/.gitconfig-additional`" == "" ]; then
    _q "Do you want to add your credentials to your .gitconfig? (Y/n) " q

    if [ "$q" == "Y" ] || [ "$q" == "y" ] || [ "$q" == "" ]; then
        _q "Name" username
        _q "Email" email

        echo "[user]" >> $HOME/.gitconfig-additional
        echo "    name = " $username >> $HOME/.gitconfig-additional
        echo "    email = " $email >> $HOME/.gitconfig-additional
    fi
fi

_w "🎉 dotfiles installed correctly! 🎉"
_w "Please, restart your terminal to see the changes"