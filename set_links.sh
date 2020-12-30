#!/bin/bash

# Fonts, always useful
cp -R -u -p $PWD/fonts $HOME/.fonts

# Terminal conf
ln -sf $PWD/alacritty $HOME/.config/
printf "source '$HOME/dotfiles/zsh/zshrc_manager.sh'" > $HOME/.zshrc
# sudo printf "source '$HOME/dotfiles/zsh/zshrc_manager.sh'" > /root/.zshrc
printf "so $HOME/dotfiles/vim/vimrc.vim" > $HOME/.vimrc
mkdir -p $HOME/.config/nvim
printf "source $HOME/dotfiles/vim/init.vim" > $HOME/.config/nvim/init.vim
printf "source-file $HOME/dotfiles/tmux/tmux.conf" > $HOME/.tmux.conf

# local bins
declare -a BIN_FOLDERS=('cron' 'desktop' 'utils')
mkdir -p $HOME/.local/bin
for bin_folder in ${BIN_FOLDERS[@]}
do
    ln -sf $PWD/scripts/$bin_folder $HOME/.local/bin/
done

# Rest of the conf
declare -a CONFIG_FOLDERS=('bspwm' 'dunst' 'leftwm' 'networkmanager-dmenu' 'mpd' 'nu' 'rofi' 'polybar' 'sxhkd')
echo "Deploy dekstop conf? (y/n)"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    for config_folder in ${CONFIG_FOLDERS[@]}
    do
        ln -sf $PWD/$config_folder $HOME/.config/
    done

    ln -sf $PWD/topgrade.toml $HOME/.config/topgrade.toml

    echo "$PWD/xinitrc" > $HOME/.xinitrc

    # background
    ln -sf $PWD/leftwm/themes/current/background.jpg $HOME/.local/share/bg
fi