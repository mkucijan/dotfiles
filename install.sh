#!/bin/sh
# One-line bootstrap: curl -fsSL https://raw.githubusercontent.com/mkucijan/dotfiles/main/install.sh | sh
# Idempotent and non-interactive. Env: DOTFILES_SRC (local checkout), DOTFILES_ROLE, NO_PKGS=1
set -eu
log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
SUDO=""; [ "$(id -u)" = 0 ] || { command -v sudo >/dev/null 2>&1 && SUDO="sudo"; }

if [ -n "${PREFIX:-}" ] && [ -d /data/data/com.termux ]; then OS=termux
else case "$(uname -s)" in Darwin) OS=macos ;; *) OS=linux ;; esac; fi
log "platform: $OS/$(uname -m)"

if [ "${NO_PKGS:-0}" != 1 ]; then
  log "base packages"
  case $OS in
    termux) pkg install -y git zsh tmux curl mise neovim atuin ;;
    macos)  command -v brew >/dev/null || NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install git zsh tmux ;;
    linux)  if command -v pacman >/dev/null; then $SUDO pacman -S --needed --noconfirm git zsh tmux curl base-devel
            elif command -v apt-get >/dev/null; then $SUDO apt-get update -qq && DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -yqq git zsh tmux curl ca-certificates build-essential
            elif command -v dnf >/dev/null; then $SUDO dnf install -y git zsh tmux curl gcc make
            else log "unknown distro, skipping packages"; fi ;;
  esac
fi

export PATH="$HOME/.local/bin:$PATH"
command -v mise >/dev/null 2>&1 || { log "installing mise"; curl -fsSL https://mise.run | sh; }

log "chezmoi apply"
ROLE_ARG=""; [ -n "${DOTFILES_ROLE:-}" ] && ROLE_ARG="--promptString role=$DOTFILES_ROLE"
if [ -n "${DOTFILES_SRC:-}" ]; then
  mise exec chezmoi@latest -- chezmoi init --apply --promptDefaults $ROLE_ARG --source "$DOTFILES_SRC"
else
  mise exec chezmoi@latest -- chezmoi init --apply --promptDefaults $ROLE_ARG mkucijan
fi

log "tools (mise install)"
mise install --yes || log "some tools failed; rerun 'mise install'"
command -v nvim >/dev/null 2>&1 || eval "$(mise activate sh)"
command -v nvim >/dev/null 2>&1 && { log "nvim plugins"; nvim --headless '+Lazy! restore' +qa >/dev/null 2>&1 || true; }

case "$(basename "${SHELL:-sh}")" in zsh) ;; *) [ "$OS" = termux ] && chsh -s zsh || chsh -s "$(command -v zsh)" 2>/dev/null || log "run: chsh -s $(command -v zsh)";; esac
log "done. Start a new shell (or tmux kill-server) to pick up the config."
