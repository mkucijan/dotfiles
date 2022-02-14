
# Vars
HISTFILE=$DOTFILES_HOME/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt INC_APPEND_HISTORY # To save every command before it is executed 
setopt SHARE_HISTORY # setopt inc_append_history
# Aliases
[ -x "$(command -v nvim)" ] && alias vim="nvim" vimdiff="nvim -d"
[ -x "$(command -v exa)" ] && alias ls="exa"
alias v="nvim -p"
mkdir -p /tmp/log
alias pbcopy="xclip -sel clip"
alias rust-musl-builder='docker run --rm -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder'

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^z' edit-command-line

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char


# This is currently causing problems (fails when you run it anywhere that isn't a git project's root directory)
# alias vs="v `git status --porcelain | sed -ne 's/^ M //p'`"

# Settings
export VISUAL=nvim

export EDITOR=nvim

#source $DOTFILES_HOME/.bashrc

#PATH

source $DOTFILES_HOME/dotfiles/zsh/set_path.sh

# autosuggestions
source $DOTFILES_HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^E' autosuggest-accept

# syntaxhighlight
source $DOTFILES_HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# for skaffold and kubectl https://github.com/spf13/cobra/issues/881
autoload -Uz compinit && compinit -C

# skaffold
source <(skaffold completion zsh)

#kubectl
source <(kubectl completion zsh)


# The next line updates PATH for the Google Cloud SDK.
if [ -f "$DOTFILES_HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$DOTFILES_HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$DOTFILES_HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$DOTFILES_HOME/google-cloud-sdk/completion.zsh.inc"; fi

#fd
FD_OPTIONS="--follow --exclude .git --exclude node_modules"
#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--no-mouse --height 50% --layout=reverse --border --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"

# zoxide
eval "$(zoxide init zsh)"

# bat
export BAT_PAGER="less -R"

# navi
source <(navi widget zsh)

# starship for nushell
export STARSHIP_CONFIG=$DOTFILES_HOME/dotfiles/starship/starship.toml


#github mcfly
#if [[ -r $DOTFILES_HOME/programs/mcfly/mcfly.bash ]]; then
#  source $DOTFILES_HOME/programs/mcfly/mcfly.bash
#fi
# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
#[[ -f $DOTFILES_HOME/npm/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . $DOTFILES_HOME/npm/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
#[[ -f $DOTFILES_HOME/npm/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . $DOTFILES_HOME/npm/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f $DOTFILES_HOME/npm/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . $DOTFILES_HOME/npm/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"  # This loads wasmer



#
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$DOTFILES_HOME/.sdkman"
[[ -s "$DOTFILES_HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$DOTFILES_HOME/.sdkman/bin/sdkman-init.sh"
