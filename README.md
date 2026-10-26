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

## Secrets: Bitwarden (opt-in)

Secrets never live in this repo. chezmoi reads them from Bitwarden only when **all** of these hold: `use_bitwarden = true` in `~/.config/chezmoi/chezmoi.toml`, `bw` is installed (mise; npm build on Termux) and `BW_SESSION` is set. Otherwise the secret files are left as they are (manual fallback) and `chezmoi apply` still succeeds.

One-time setup:

1. Create a free account at https://vault.bitwarden.com (or bitwarden.eu).
2. Import passwords: export from Google Password Manager (passwords.google.com → Settings → Export, gives a CSV), then in the Bitwarden web vault: Tools → Import data → format "Chrome (csv)". **Delete the CSV afterwards** (`shred -u Google\ Passwords.csv`, empty the trash/Downloads).
3. Add items named exactly as below (password field = the secret).
4. On each device:
   ```sh
   bw login                      # once per device (email + master password + 2FA)
   bwu                           # = export BW_SESSION="$(bw unlock --raw)"; bw sync
   chezmoi init --promptBool use_bitwarden=true   # or edit chezmoi.toml data
   mise run secrets              # or: chezmoi apply
   bwl                           # lock again when done
   ```

Item naming convention (one Login item per secret, lowercase, password field holds the value):

| Bitwarden item | Written to | Used by |
|---|---|---|
| `hindsight` | `~/.config/hindsight/api_key` (0600) | `hindsight` CLI (`HINDSIGHT_API_KEY`), Grok MCP `bearer_token_file` |

Add new ones by copying `home/dot_config/private_hindsight/modify_private_api_key`.
