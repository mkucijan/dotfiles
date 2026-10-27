#!/bin/sh
# One-time migration from the old symlink/stub layout. Moves, never deletes.
set -eu
ts=$(date +%Y%m%d%H%M%S)
mv_bak() { [ -e "$1" ] && [ ! -L "$1" ] && mv "$1" "$1.legacy-$ts" && echo "moved $1 -> $1.legacy-$ts" || true; }
# nvim refuses to start with both init.vim and init.lua
mv_bak "$HOME/.config/nvim/init.vim"
# with ZDOTDIR=~/.config/zsh the old ~/.zshrc is no longer read; keep it for reference
mv_bak "$HOME/.zshrc"
mv_bak "$HOME/.tmux.conf"
# alacritty used to be a symlink into the repo
[ -L "$HOME/.config/alacritty" ] && mv "$HOME/.config/alacritty" "$HOME/.config/alacritty.legacy-$ts" || true
