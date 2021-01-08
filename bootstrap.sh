#!/bin/bash
set -eu

(
read -p "Press <enter> to setup your dotfiles ..."

dest=~/.dotfiles

if ! [ -d "$dest" ]; then
  git clone https://github.com/mkucijan/dotfiles $dest
  cd $dest
  ./deploy.sh
else
  echo "'$dest' is already present - pulling latest"
  cd $dest && git pull --rebase
fi
) < /dev/tty

