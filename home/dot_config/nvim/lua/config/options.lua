local o = vim.opt
o.number = true; o.relativenumber = true; o.signcolumn = "yes"
o.mouse = "a"; o.termguicolors = true; o.undofile = true
o.ignorecase = true; o.smartcase = true
o.expandtab = true; o.shiftwidth = 4; o.tabstop = 4
o.splitright = true; o.splitbelow = true; o.scrolloff = 5
o.updatetime = 300; o.completeopt = { "menu", "menuone", "noselect" }
-- OSC 52 clipboard: works in tmux / over ssh with no xclip
if os.getenv("SSH_TTY") or os.getenv("TMUX") then
  vim.g.clipboard = "osc52"
end
o.clipboard = "unnamedplus"
