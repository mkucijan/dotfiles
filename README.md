# dotfiles

Cross-platform terminal setup (zsh, tmux, Neovim, git, mise tools) for Arch, Debian/Raspberry Pi, the Pixel 7 Debian chroot, Termux and macOS.

- **chezmoi** renders `home/` into `$HOME` (templates by OS, arch, hostname and `role` = desktop/server/phone).
- **mise** installs pinned CLI tools and runtimes from `~/.config/mise/config.toml` + `mise.lock` (linux-x64, linux-arm64, macos-arm64).
- tmux and zsh plugins are pinned git checkouts (`.chezmoiexternal.toml` + `run_onchange_after_10-pin-plugins.sh.tmpl`); no TPM.
- Neovim: Lua + lazy.nvim (`lazy-lock.json`), built-in LSP enabled only for servers that are installed.
- Old desktop rice (bspwm, polybar, rofi, ...) and the old configs live in `legacy/`, untouched.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/mkucijan/dotfiles/main/install.sh | sh
# or from a checkout:
DOTFILES_SRC=$PWD DOTFILES_ROLE=server sh install.sh
```

## Daily use

| | |
|---|---|
| `chezmoi edit ~/.config/zsh/.zshrc` / `chezmoi apply` | edit and deploy |
| `chezmoi diff` | preview |
| `mise run up` | update dotfiles, tools, nvim plugins |
| `mise run test-bootstrap` | run install.sh in a clean container |
| `$ZDOTDIR/local.zsh`, `~/.config/tmux/local.conf`, `~/.config/git/local` | untracked per-machine overrides |

Secrets never go in this repo. `~/.grok/config.toml` is merged (modify template), so Grok can keep writing to it.
