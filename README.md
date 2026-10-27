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

## Secrets: Bitwarden Secrets Manager (bws)

Secret *values* never live in this repo. `home/.chezmoidata/secrets.toml` maps **bws secret keys -> local targets** (files, env vars, AWS profiles; `{host}` = hostname, optional `hosts`/`os` filters). chezmoi renders that into `~/.local/bin/secrets-sync`, which runs `bws secret list -o json | jq` and writes the targets with mode 0600. It reads the machine-account token from `$BWS_ACCESS_TOKEN` or `~/.config/bws/token` (0600, untracked). No token, no `bws`, or a missing secret: one-line notice, existing files kept, exit 0. Values are never printed.

`bw` (personal vault) stays installed for your own passwords (`bwu`/`bwl`), but is **not** used by this flow.

Secret names to create in Secrets Manager (project `kuc`, readable by machine account `grok-bot` or a per-device one):

| bws secret key | Written to | Used by |
|---|---|---|
| `hindsight` | `~/.config/hindsight/api_key` (0600) | `hindsight` CLI (`HINDSIGHT_API_KEY`), Grok MCP `bearer_token_file` |
| `gh-token` | `GH_TOKEN` in `~/.config/secrets/env` (0600, sourced by zsh) | `gh` (`~/.config/gh/hosts.yml` stays untracked) |
| `aws-<host>-access-key-id` + `aws-<host>-secret-access-key` | profile `[<host>]` in a marked block of `~/.aws/credentials` (0600; other profiles untouched) | AWS CLI/SDKs (`AWS_PROFILE=<host>`) |

AWS rule: the admin IAM user `kuc` keys stay on **arch only** and are never put in bws. Store only scoped, per-device IAM keys here.

Per device:

```sh
mise install                                   # bws 2.1.0 (github:bitwarden/sdk-sm)
install -Dm600 /dev/null ~/.config/bws/token   # then paste the machine-account token without echo:
read -rs "T?bws token: " && printf %s "$T" > ~/.config/bws/token; unset T; echo
mise run secrets                               # = secrets-sync + re-render ~/.grok/config.toml
```

Termux: bws has no Android build; `pkg install rust && cargo install bws --locked`, or keep the manual key files below.

Manual fallback (no bws): `install -m 600 /dev/null ~/.config/hindsight/api_key && $EDITOR ~/.config/hindsight/api_key`.

Add a secret: create it in bws, then add an entry to `home/.chezmoidata/secrets.toml`.
