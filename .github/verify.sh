#!/usr/bin/env bash
# Post-install checks shared by CI and the throwaway-user test. PROFILES="base dev ..."
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
fail=0; ok() { printf 'PASS %s\n' "$1"; }; bad() { printf 'FAIL %s\n' "$1"; fail=1; }
has_p() { [[ " base $PROFILES " == *" $1 "* ]]; }
ms() { local s=$(date +%s%N); "$@" >/dev/null 2>&1; local r=$?; echo "$(( ($(date +%s%N)-s)/1000000 ))ms"; return $r; }
chezmoi verify && ok "chezmoi verify clean" || { bad "chezmoi verify"; chezmoi diff --no-pager | head -40; }
[[ -z "$(mise ls --missing 2>/dev/null)" ]] && ok "mise ls --missing empty" || { bad "mise missing:"; mise ls --missing; }
t=$(ms zsh -i -c exit) && ok "zsh -i -c exit ($t)" || bad "zsh -i"
t=$(ms sh -c 'tmux -f ~/.config/tmux/tmux.conf -L ci new-session -d -s ci && tmux -L ci kill-server') && ok "tmux ($t)" || bad tmux
t=$(ms nvim --headless +qa) && ok "nvim --headless +qa ($t)" || bad nvim
err=$(nvim --headless +qa 2>&1); [[ -z "$err" ]] && ok "nvim no startup output" || { bad "nvim output"; echo "$err" | head; }
[[ "$(head -1 ~/.ssh/config)" == "Include config.d/*" ]] && ok "ssh config Include first" || bad "ssh Include"
[[ "$(ssh -G arch 2>/dev/null | awk '/^port /{print $2}')" == 2222 ]] && ok "ssh -G arch port 2222" || bad "ssh -G arch"
for b in gh bws git zsh; do command -v $b >/dev/null && ok "$b present" || bad "$b missing"; done
gh --version >/dev/null && bws --version >/dev/null && ok "gh/bws run" || bad "gh/bws run"
secrets-sync >/dev/null 2>&1 && ok "secrets-sync without token exits 0" || bad "secrets-sync"
npl=$(ls ~/.local/share/nvim/lazy 2>/dev/null | wc -l)
if has_p dev; then
  [[ $npl -gt 5 ]] && ok "dev: $npl nvim plugins" || bad "dev: plugins ($npl)"
  command -v node >/dev/null && command -v ruff >/dev/null && command -v lua-language-server >/dev/null && ok "dev: toolchains/LSPs" || bad "dev: toolchains"
else
  [[ $npl -eq 0 && ! -e ~/.config/nvim/lua/plugins ]] && ok "base: no nvim plugins" || bad "base: plugins present ($npl)"
  ! command -v node >/dev/null && ! command -v rustc >/dev/null && ok "base: no dev toolchains" || bad "base: dev toolchains present"
fi
if has_p agent; then
  [[ -x ~/.grok/bin/grok ]] && ~/.grok/bin/grok --version >/dev/null 2>&1 && ok "agent: grok installed" || bad "agent: grok"
  command -v hindsight >/dev/null && ok "agent: hindsight" || bad "agent: hindsight"
else
  [[ ! -e ~/.grok && -z "$(command -v hindsight)" ]] && ok "base: no agent tools" || bad "base: agent tools present"
fi
exit $fail
