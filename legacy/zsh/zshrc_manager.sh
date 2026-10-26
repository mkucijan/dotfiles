#time_out () { perl -e 'alarm shift; exec @ARGV' "$@"; }
export DOTFILES_HOME=/home/mkucijan
# Run tmux if exists

#export TERM=xterm-256color
# if command -v tmux>/dev/null; then
#	[ -z $TMUX ] && exec tmux
#else 
#	echo "tmux not installed. Run ./deploy to configure dependencies"
#fi

#echo "Updating configuration"
#(cd ~/dotfiles && time_out 3 git pull && time_out 3 git submodule update --init --recursive)
# (cd $DOTFILES_HOME/dotfiles && git pull && git submodule update --init --recursive)
source $DOTFILES_HOME/dotfiles/zsh/zshrc.sh
# source $DOTFILES_HOME/dotfiles/zsh/antigen_config.sh
eval "$(starship init zsh)"
#mkdir -p $HOME/.config/nu
#cp $DOTFILES_HOME/dotfiles/nu/config.toml  $HOME/.config/nu/config.toml
#cp $DOTFILES_HOME/dotfiles/nu/keybindings.yml  $HOME/.config/nu/keybindings.yml
#cp $DOTFILES_HOME/dotfiles/starship/starship.toml  $HOME/.config/starship.toml
