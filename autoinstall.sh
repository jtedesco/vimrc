#!/bin/sh

# Check that some argument was provided
if [ $# -eq "0" ] # should check for no arguments
then
    echo "\n\tUsage: autoinstall.sh <INSTALL_TO_PATH>\n"
    exit $E_OPTERROR
fi

INSTALL_TO=$1
echo "Downloading to $1..."

warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

[ -e "$INSTALL_TO/vimrc" ] && die "$INSTALL_TO/vimrc already exists."
[ -e "~/.vim" ] && die "~/.vim already exists."
[ -e "~/.vimrc" ] && die "~/.vimrc already exists."

cd "$INSTALL_TO"
git clone git://github.com/nvie/vimrc.git
cd vimrc

# Download vim plugin bundles
git submodule init
git submodule update

# Compile command-t for the current platform
cd vim/ruby/command-t
(ruby extconf.rb && make clean && make) || warn "Ruby compilation failed. Ruby not installed, maybe?"

# Symlink ~/.vim and ~/.vimrc
echo "Installing vim configuration to ~/"
cd ~
ln -s "$INSTALL_TO/vimrc/vimrc" .vimrc
ln -s "$INSTALL_TO/vimrc/vim" .vim
touch ~/.vim/user.vim

echo "Installed and configured .vim, have fun."
