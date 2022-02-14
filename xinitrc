#!/bin/sh

# xinitrc runs automatically when you run startx.

# There are some small but important commands that need to be run when we start
# the graphical environment. There is a link to this file in ~/.xprofile
# because that file is run automatically if someone uses a display manager
# (login screen) and so they are needed there. To prevent doubling up commands,
# I source them here with the line below.

if [ -f "${XDG_CONFIG_HOME:-$HOME/dotfiles}/zsh/set_path.sh" ]; then
    . "${XDG_CONFIG_HOME:-$HOME/dotfiles}/zsh/set_path.sh"
fi
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
# export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
# dbus-update-activation-environment --systemd DISPLAY
export SSH_AUTH_SOCK

source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

export _JAVA_AWT_WM_NONREPARENTING=1

# ssh-agent
# exec dwm

# exec ssh-agent dbus-launch leftwm

sxhkd &
exec ssh-agent dbus-launch bspwm
