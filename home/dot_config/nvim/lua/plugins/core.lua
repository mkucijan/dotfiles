return {
  { "Mofiqul/vscode.nvim", lazy = false, priority = 1000, config = function() vim.cmd.colorscheme("vscode") end },
  { "nvim-lualine/lualine.nvim", event = "VeryLazy", opts = { options = { theme = "auto", icons_enabled = vim.env.TERMUX_VERSION == nil } } },
  { "christoomey/vim-tmux-navigator", lazy = false },
  { "tpope/vim-fugitive", cmd = { "G", "Git", "Gdiffsplit" } },
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", opts = {} },
  { url = "https://codeberg.org/andyg/leap.nvim", keys = { { "s", "<Plug>(leap)", mode = { "n", "x", "o" } } } },
  { "stevearc/oil.nvim", lazy = false, opts = {}, keys = { { "-", "<cmd>Oil<cr>" } } },
  { "ibhagwan/fzf-lua", cmd = "FzfLua", keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>" }, { "<leader>g", "<cmd>FzfLua live_grep<cr>" },
      { "<leader>b", "<cmd>FzfLua buffers<cr>" }, { "<leader>fc", "<cmd>FzfLua helptags<cr>" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>" } }, opts = {} },
  { "folke/trouble.nvim", cmd = "Trouble", opts = {}, keys = {
      { "<leader>mm", "<cmd>Trouble diagnostics toggle<cr>" }, { "gR", "<cmd>Trouble lsp_references toggle<cr>" } } },
  { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },
  { "akinsho/toggleterm.nvim", version = "*", keys = { { "<c-t>", "<cmd>ToggleTerm<cr>", mode = { "n", "i", "t" } } }, opts = {} },
  { "saghen/blink.cmp", version = "1.*", event = "InsertEnter", opts = { keymap = { preset = "default" }, fuzzy = { implementation = "prefer_rust" } } },
  { "stevearc/conform.nvim", event = "BufWritePre", opts = {
      formatters_by_ft = { rust = { "rustfmt" }, python = { "ruff_format" }, lua = { "stylua" }, c = { "clang-format" }, cpp = { "clang-format" } },
      format_on_save = { timeout_ms = 1000, lsp_format = "fallback" } } },
  { "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate",
    cond = vim.fn.executable("tree-sitter") == 1 or vim.fn.executable("cc") == 1 },
}
