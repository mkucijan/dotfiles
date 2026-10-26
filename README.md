# dotfiles

Cross-platform terminal setup (zsh, tmux, Neovim, git, mise tools) for Arch, Debian/Raspberry Pi, the Pixel 7 Debian chroot, Termux and macOS.

- **chezmoi** renders `home/` into `$HOME` (templates by OS, arch, hostname and `role` = desktop/server/phone).
- **mise** installs pinned CLI tools and runtimes from `~/.config/mise/config.toml` + `mise.lock` (linux-x64, linux-arm64, macos-arm64).
- tmux and zsh plugins are pinned git checkouts (`.chezmoiexternal.toml` + `run_onchange_after_10-pin-plugins.sh.tmpl`); no TPM.
- Neovim: Lua + lazy.nvim (`lazy-lock.json`), built-in LSP enabled only for servers that are installed.
- The old setup (bspwm/polybar/rofi rice, old zsh/tmux/vim/alacritty configs, deploy scripts, package lists) is **not** on `main` anymore: it is preserved at tag [`legacy-2024`](https://github.com/mkucijan/dotfiles/tree/legacy-2024). Bring pieces back as needed with `git show legacy-2024:<path>`.

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

## Hindsight (memory)

`hindsight` CLI is pinned in mise (`github:vectorize-io/hindsight`), with a `cloud` profile pointing at Hindsight Cloud and `HINDSIGHT_BANK=personal`. Put the API key in an untracked file once per device:

```sh
install -m 600 /dev/null ~/.config/hindsight/api_key && $EDITOR ~/.config/hindsight/api_key
hindsight memory recall "$HINDSIGHT_BANK" "test"
chezmoi apply   # enables the hindsight MCP server in ~/.grok/config.toml (bearer_token_file)
```
