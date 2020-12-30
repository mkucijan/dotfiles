#!/bin/bash


newperms() { # Set special sudoers settings for install (or after).
        sed -i "/#YOLKIN/d" /etc/sudoers
        echo "$* #YOLKIN" >> /etc/sudoers ;
}

prompt_install() {
	echo -n "$1 is not installed. Would you like to install it? (y/n) " >&2
	old_stty_cfg=$(stty -g)
	stty raw -echo
	answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
	stty $old_stty_cfg && echo
    if [ -z "$2" ]; then
        $1=$2
    fi
	if echo "$answer" | grep -iq "^y" ;then
		# This could def use community support
		if [ -x "$(command -v apt)" ]; then
			sudo apt install $1 -y

		elif [ -x "$(command -v pacman)" ]; then
			sudo pacman -S $1

		elif [ -x "$(command -v brew)" ]; then
			brew install $1

		elif [ -x "$(command -v pkg)" ]; then
			sudo pkg install $1

		else
			echo "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again. Tests for package managers are in the deploy script you just ran starting at line 13. Feel free to make a pull request at https://github.com/parth/dotfiles :)" 
		fi 
	fi
}

check_for_software() {
	echo "Checking to see if $1 is installed"
	if ! [ -x "$(command -v $1)" ]; then
		prompt_install $1 $2
	else
		echo "$1 is installed."
	fi
}

check_default_shell() {
	if [ -z "${SHELL##*zsh*}" ] ;then
			echo "Default shell is zsh."
	else
		echo -n "Default shell is not zsh. Do you want to chsh -s \$(which zsh)? (y/n)"
		old_stty_cfg=$(stty -g)
		stty raw -echo
		answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
		stty $old_stty_cfg && echo
		if echo "$answer" | grep -iq "^y" ;then
			chsh -s $(which zsh)
		else
			echo "Warning: Your configuration won't work properly. If you exec zsh, it'll exec tmux which will exec your default shell which isn't zsh."
		fi
	fi
}

echo "We're going to do the following:"
echo "1. Check to make sure you have zsh, vim, and tmux installed"
echo "2. We'll help you install them if you don't"
echo "3. We're going to check to see if your default shell is zsh"
echo "4. We'll try to change it if it's not" 

echo "Let's get started? (y/n)"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
	echo 
else
	echo "Quitting, nothing was changed."
	exit 0
fi


check_for_software zsh
echo 
check_for_software nvim neovim
echo
check_for_software tmux
echo

check_default_shell

echo
echo -n "Would you like to backup your current dotfiles? (y/n) "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
	mv ~/.zshrc ~/.zshrc.old
	mv ~/.tmux.conf ~/.tmux.conf.old
	mv ~/.vimrc ~/.vimrc.old
else
	echo -e "\nNot backing up old dotfiles."
fi

# set links
./set_links.sh

# Install yay, and other deps
if [ -x "$(command -v pacman)" ]; then
	if ![-x "$(command -v yay)"]; then
		cd /tmp
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si
	fi
	if ![-x "$(command -v snap)"]; then
		echo "I aint got snap"
	else
		echo "I got snap"
	fi
fi

# zsh autosuggestions
ZSH_SUGGESTION_PATH=$HOME/.zsh/zsh-autosuggestions
if [ ! -f "$ZSH_SUGGESTIONS_PATH" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_SUGGESTIONS_PATH
fi

# tmuxifier
TMUXIFIER_PATH=$HOME/.tmuxifier
if [ ! -f "$TMUXIFIER_PATH" ]; then
    git clone https://github.com/jimeh/tmuxifier.git $TMUXIFIER_PATH
fi

# echo
# echo -n "Install Rust? (y/n) "
# old_stty_cfg=$(stty -g)
# stty raw -echo
# answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
# stty $old_stty_cfg
# if echo "$answer" | grep -iq "^y" ;then
#     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# else
# 	echo -e "\nSkipping."
# fi

# Neovim plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir -p ~/.vim/backup
mkdir -p ~/.vim/undo
mkdir -p ~/.vim/swap

#
# newperms "%wheel ALL=(ALL) ALL #YOLKIN
# %wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay,/usr/bin/pacman -Syyuw --noconfirm,/usr/bin/systemctl stop transmission.service,/usr/bin/systemctl start transmission.service"

echo
echo "Please log out and log back in for default shell to be initialized."
