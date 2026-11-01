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
o.path:append("**"); o.wildignore:append({ "*/.git/*", "*/node_modules/*", "*/target/*" })
if vim.fn.executable("rg") == 1 then o.grepprg = "rg --vimgrep --smart-case"; o.grepformat = "%f:%l:%c:%m" end
vim.g.netrw_banner = 0; vim.g.netrw_liststyle = 3
