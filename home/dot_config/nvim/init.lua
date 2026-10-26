-- Neovim >= 0.11 config (Lua, lazy.nvim, built-in LSP). Legacy init.vim lives in legacy/vim/.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.lsp")
