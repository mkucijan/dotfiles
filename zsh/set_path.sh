

# local
export PATH=$PATH:$DOTFILES_HOME/.local/bin
# desktop scripts
export PATH=$PATH:$DOTFILES_HOME/.local/bin/desktop
# util scripts
export PATH=$PATH:$DOTFILES_HOME/.local/bin/utils
# polybar scripts
export PATH=$PATH:$DOTFILES_HOME/.config/polybar/scripts

#homebrew
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
export PATH=$PATH:/opt/brew/bin

#flutter
export PATH=$PATH:$DOTFILES_HOME/programs/flutter/bin

# Android
export PATH=$PATH:$DOTFILES_HOME/Android/Sdk/platform-tools

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# kubernetes
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=$PATH:~/.jx/bin

# jenkins x
#source <(jx completion zsh)

# linkerd
export PATH=$PATH:$HOME/.linkerd2/bin


export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"

# programing langugages
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
export PATH="$PATH:$HOME/.cargo/bin"
export NODE_PATH="$NODE_PATH:$HOME/npm/lib/node_modules"
export PATH="$PATH:$HOME/npm/bin"
#export PATH="$HOME/.rbenv/bin:$PATH"
#export PATH="$HOME/.rbenv/shims:$PATH"

export PATH="$DOTFILES_HOME/.deno/bin:$PATH"
export PATH=$PATH:$HOME/programs/depot_tools

#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init --path)"
eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

export WORKON_HOME=$HOME/.virtualenvs
source /usr/bin/virtualenvwrapper.sh
#source $HOME/.local/bin/virtualenvwrapper.sh
#export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"


