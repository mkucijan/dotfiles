#!/bin/sh
# One-line bootstrap: curl -fsSL https://raw.githubusercontent.com/mkucijan/dotfiles/main/install.sh | sh
# Idempotent and non-interactive.
# Env: DOTFILES_PROFILES="base dev agent ui" (stackable; base is always on), DOTFILES_SRC (local checkout),
#      NO_PKGS=1 (skip OS packages). Legacy: DOTFILES_ROLE=server|desktop|phone.
set -eu
log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
SUDO=""; [ "$(id -u)" = 0 ] || { command -v sudo >/dev/null 2>&1 && SUDO="sudo"; }

if [ -n "${PREFIX:-}" ] && [ -d /data/data/com.termux ]; then OS=termux
else case "$(uname -s)" in Darwin) OS=macos ;; *) OS=linux ;; esac; fi

# ---- profiles: env > legacy role > stored chezmoi data > host default ----
P="${DOTFILES_PROFILES:-}"
if [ -z "$P" ] && [ -n "${DOTFILES_ROLE:-}" ]; then
  case $DOTFILES_ROLE in desktop) P="base dev agent ui" ;; *) P="base" ;; esac
fi
CZ_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.toml"
[ -z "$P" ] && [ -r "$CZ_CFG" ] && P=$(sed -n 's/^ *profiles *= *"\(.*\)"/\1/p' "$CZ_CFG" | head -1)
if [ -z "$P" ]; then
  if [ "$OS" = macos ] || [ "$(uname -n)" = arch ]; then P="base dev agent ui"; else P="base"; fi
fi
P="base $(echo "$P" | tr ',' ' ')"
export DOTFILES_PROFILES="$P"
has_p() { case " $P " in *" $1 "*) return 0 ;; *) return 1 ;; esac; }
log "platform: $OS/$(uname -m)  profiles: $(echo $P | tr ' ' '\n' | awk '!s[$0]++' | tr '\n' ' ')"

if [ "${NO_PKGS:-0}" != 1 ]; then
  log "OS packages"
  case $OS in
    termux) pkg install -y git zsh tmux curl mise neovim atuin gh
            has_p dev && pkg install -y nodejs-lts python clang rust
            true ;;
    macos)  command -v brew >/dev/null || NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install git zsh tmux
            has_p ui && { brew install --cask alacritty font-jetbrains-mono-nerd-font bitwarden || log "some casks failed"; }
            true ;;
    linux)  if command -v pacman >/dev/null; then
              pk="git zsh tmux curl unzip"
              has_p dev && pk="$pk base-devel"
              has_p ui && pk="$pk alacritty ttf-jetbrains-mono-nerd bitwarden xdg-utils"
              $SUDO pacman -S --needed --noconfirm $pk
            elif command -v apt-get >/dev/null; then
              pk="git zsh tmux curl ca-certificates unzip"
              has_p dev && pk="$pk build-essential"
              has_p ui && pk="$pk alacritty fonts-jetbrains-mono xdg-utils"   # bitwarden desktop: flatpak/AppImage, not in Debian
              $SUDO apt-get update -qq && DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -yqq $pk
            elif command -v dnf >/dev/null; then
              pk="git zsh tmux curl unzip"; has_p dev && pk="$pk gcc gcc-c++ make"
              $SUDO dnf install -y $pk
            else log "unknown distro, skipping packages"; fi ;;
  esac
fi

export PATH="$HOME/.local/bin:$PATH"
command -v mise >/dev/null 2>&1 || { log "installing mise"; curl -fsSL https://mise.run | sh; }

log "chezmoi apply"
if [ -n "${DOTFILES_SRC:-}" ]; then
  mise exec chezmoi@latest -- chezmoi init --apply --promptDefaults --source "$DOTFILES_SRC"
else
  mise exec chezmoi@latest -- chezmoi init --apply --promptDefaults mkucijan
fi

log "tools (mise install)"
mise install --yes || log "some tools failed; rerun 'mise install'"
export PATH="${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims:$PATH"
# re-render templates that depend on tools installed just now (e.g. lookPath "gh" in git config)
log "chezmoi re-apply"
mise exec chezmoi@latest -- chezmoi apply || log "chezmoi apply failed; rerun it"

case "$(basename "${SHELL:-sh}")" in zsh) ;; *)
  if [ "$OS" = termux ]; then chsh -s zsh
  else ZSH_BIN=$(command -v zsh)
    # chsh prompts for a password; prefer passwordless sudo when available
    { [ -n "$SUDO" ] && $SUDO -n chsh -s "$ZSH_BIN" "$(id -un)" 2>/dev/null; } || chsh -s "$ZSH_BIN" </dev/null 2>/dev/null || log "run: chsh -s $ZSH_BIN"
  fi ;;
esac
log "done. Start a new shell (or tmux kill-server) to pick up the config."
