local map = vim.keymap.set
-- carried over from init.vim
map("n", "<leader><leader>", "<c-^>")
map("n", "<left>", ":bp<CR>", { silent = true })
map("n", "<right>", ":bn<CR>", { silent = true })
for _, k in ipairs({ "<up>", "<down>" }) do map({ "n", "i" }, k, "<nop>") end
map("i", "<left>", "<nop>"); map("i", "<right>", "<nop>")
map("v", "<C-c>", '"+y')
map("n", "t", "gccj", { remap = true, desc = "toggle comment" })
map("v", "t", "gc", { remap = true })
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- built-ins shared by every profile (dev plugins override some of these: oil on "-", tmux-navigator on C-hjkl)
map("n", "-", "<cmd>Explore<cr>", { desc = "file browser (netrw)" })
for _, k in ipairs({ "h", "j", "k", "l" }) do map("n", "<C-" .. k .. ">", "<C-w>" .. k) end
map("n", "<leader>ff", ":find ", { desc = "find file (builtin)" })
map("n", "<leader>g", ":silent grep! ", { desc = "grep (rg via grepprg)" })
