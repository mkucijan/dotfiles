# dotfiles

Cross-platform terminal setup (zsh, tmux, Neovim, git, mise tools) for Arch, Debian/Raspberry Pi, the Pixel 7 Debian chroot, Termux and macOS.

- **chezmoi** renders `home/` into `$HOME` (templates by OS, arch, hostname and stackable `profiles`: base, dev, agent, ui — see below).
- **mise** installs pinned CLI tools and runtimes from `~/.config/mise/config.toml` + `mise.lock` (linux-x64, linux-arm64, macos-arm64).
- tmux and zsh plugins are pinned git checkouts (`.chezmoiexternal.toml` + `run_onchange_after_10-pin-plugins.sh.tmpl`); no TPM.
- Neovim: Lua + lazy.nvim (`lazy-lock.json`), built-in LSP enabled only for servers that are installed.
- The old setup (bspwm/polybar/rofi rice, old zsh/tmux/vim/alacritty configs, deploy scripts, package lists) is **not** on `main` anymore: it is preserved at tag [`legacy-2024`](https://github.com/mkucijan/dotfiles/tree/legacy-2024). Bring pieces back as needed with `git show legacy-2024:<path>`.

## Profiles

Install is split into stackable profiles. `base` is always on; add others space-separated.

| Profile | What it adds | Typical hosts |
|---|---|---|
| `base` | zsh + starship/atuin/zoxide/fzf, tmux, core CLI (rg, fd, bat, eza, delta, lazygit, jq, dust, btop), git + gh, `bw`/`bws` + `secrets-sync`, `~/.ssh/config.d/tailnet`. Neovim as `$EDITOR` with **zero plugins** (shared core options/keymaps, netrw, builtin `:find`/`:grep`) | Pi, Termux, servers |
| `dev` | full Neovim plugin set (lazy.nvim, blink.cmp, treesitter, conform, fzf-lua, oil...) on top of the same core; built-in LSP; toolchains + LSPs/formatters via mise: node, python + uv, pnpm, go, tree-sitter, lua-language-server, stylua, ruff, shellcheck, shfmt, pyright, typescript(-language-server), bash-language-server, xh, tealdeer; `build-essential`/`base-devel` | arch, macOS, dev boxes |
| `rust` | Rust via rustup through mise (stable + rust-analyzer, rustfmt, clippy). Opt-in because it is ~1.5 GB and slow to install on ARM boards; `DOTFILES_RUST=1` is a shortcut for adding it | arch, macOS |
| `agent` | AI CLIs from `home/.chezmoidata/agents.toml` (now: Grok CLI) + their config (`~/.grok/config.toml` merged, Hindsight MCP), `hindsight` CLI | anywhere you run agents |
| `ui` | Alacritty config, tmux open-URL binding; packages: alacritty, JetBrains Mono Nerd font, Bitwarden desktop (pacman / brew casks; Debian: alacritty + font only) | arch, macOS |

Defaults: arch and macOS get `base dev rust agent ui`, everything else `base`. Legacy `DOTFILES_ROLE` still works (`server`/`phone` -> `base`, `desktop` -> all five).
The choice is stored in `~/.config/chezmoi/chezmoi.toml` (`profiles = "..."`); change it later with
`DOTFILES_PROFILES="base dev" chezmoi init --apply` (or re-run `install.sh` with the env var).

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/mkucijan/dotfiles/main/install.sh | DOTFILES_PROFILES="base" sh
curl -fsSL https://raw.githubusercontent.com/mkucijan/dotfiles/main/install.sh | DOTFILES_PROFILES="base dev agent" sh
# from a checkout (e.g. testing a branch):
git clone -b modern https://github.com/mkucijan/dotfiles ~/dotfiles && cd ~/dotfiles
DOTFILES_SRC=$PWD DOTFILES_PROFILES="base dev agent ui" sh install.sh
```

Lock files are seed-only: `mise.lock` and `nvim/lazy-lock.json` are copied from the repo on first install and whenever the repo version changes (then `mise install` / `:Lazy restore` run), but the tools own them afterwards, so `chezmoi verify` stays clean. To upgrade: `mise run up`, then copy the new locks back into the repo (`mise lock --platform linux-x64,linux-arm64,macos-arm64` for mise).

## Daily use

| | |
|---|---|
| `chezmoi edit ~/.config/zsh/.zshrc` / `chezmoi apply` | edit and deploy |
| `chezmoi diff` | preview |
| `mise run up` | update dotfiles, tools, nvim plugins |
| `mise run test-bootstrap` | run install.sh in a clean container (`DOTFILES_PROFILES`, `IMAGE`, `PLATFORM`) |
| `$ZDOTDIR/local.zsh`, `~/.config/tmux/local.conf`, `~/.config/git/local` | untracked per-machine overrides |

Secrets never go in this repo. `~/.grok/config.toml` is merged (modify template), so Grok can keep writing to it.

## Hindsight (memory)

`hindsight` CLI is pinned in mise (`github:vectorize-io/hindsight`), with a `cloud` profile pointing at Hindsight Cloud and `HINDSIGHT_BANK=personal`. Put the API key in an untracked file once per device:

```sh
install -m 600 /dev/null ~/.config/hindsight/api_key && $EDITOR ~/.config/hindsight/api_key
hindsight memory recall "$HINDSIGHT_BANK" "test"
chezmoi apply   # enables the hindsight MCP server in ~/.grok/config.toml (Authorization header filled from the key file at apply time)
```

## Secrets: Bitwarden Secrets Manager (bws)

Secret *values* never live in this repo. `home/.chezmoidata/secrets.toml` maps **bws secret keys -> local targets** (files, env vars, AWS profiles; `{host}` = hostname, optional `hosts`/`os` filters). chezmoi renders that into `~/.local/bin/secrets-sync`, which runs `bws secret list -o json | jq` and writes the targets with mode 0600. It reads the machine-account token from `$BWS_ACCESS_TOKEN` or `~/.config/bws/token` (0600, untracked). No token, no `bws`, or a missing secret: one-line notice, existing files kept, exit 0. Values are never printed.

`bw` (personal vault) stays installed for your own passwords (`bwu`/`bwl`), but is **not** used by this flow.

Secret names to create in Secrets Manager (project `kuc`, readable by machine account `grok-bot` or a per-device one):

| bws secret key | Written to | Used by |
|---|---|---|
| `hindsight` | `~/.config/hindsight/api_key` (0600) | `hindsight` CLI (`HINDSIGHT_API_KEY`), Grok MCP `Authorization` header |
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

## SSH client config

chezmoi manages `~/.ssh/config.d/tailnet` using Tailscale MagicDNS names — **MagicDNS must be enabled on each device** (arch on port 2222 — port 22 there is Tailscale SSH for the browser terminal only — plus rpi, pixel, pixel7 and `Host *` defaults). Your own `~/.ssh/config` is **not** overwritten: a modify script keeps `Include config.d/*` as the first line (creating the file if absent, idempotent), so local entries survive (first match wins in ssh, so a local `Host` block after the Include can't override a managed one; put overrides in another `config.d/` file sorted before `tailnet`). Keys and `known_hosts` are never tracked.

## Adding a new device

Every device follows the same standard:

1. **Join the tailnet** with MagicDNS on (`tailscale up --accept-dns`); its MagicDNS name is the SSH HostName.
2. **OpenSSH with key auth on port 2222 alongside 22**: `/etc/ssh/sshd_config.d/10-ports.conf` with `Port 22` + `Port 2222` and `PasswordAuthentication no`. Termux/Android uses its sshd on **8022**. Tailscale SSH (port 22 via tailscale) stays only as the browser-terminal backup.
3. **Authorize keys**: add the box's and arch's `~/.ssh/id_ed25519.pub` to the device's `~/.ssh/authorized_keys`.
4. **Add a `Host` entry** to `home/private_dot_ssh/private_config.d/tailnet` (→ `~/.ssh/config.d/tailnet`) and push.
5. **Profiles**: pick them at install (`DOTFILES_PROFILES=...`); servers/phones `base`, workstations add `dev agent ui`.
6. **Secrets**: create a bws machine token for it, save to `~/.config/bws/token` (0600), run `mise run secrets`; if it needs AWS, create scoped `aws-<host>-access-key-id` / `aws-<host>-secret-access-key` (never the `kuc` admin keys).

## Adding an AI tool (agent profile)

1. Add an `[[agents]]` entry to `home/.chezmoidata/agents.toml`: `name`, `check` (already installed?), `install` (idempotent, must not edit shell rc files), optional `path` (prepended to PATH by zshenv).
2. If it has config, add `home/dot_<tool>/` (use a `modify_` template if the tool rewrites its own config, like `dot_grok/modify_config.toml`) and list it under the `agent` block in `home/.chezmoiignore`.
3. MCP servers: reuse the Hindsight pattern in `dot_grok/modify_config.toml` (key from an untracked file at apply time, never committed).
