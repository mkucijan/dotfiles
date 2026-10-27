-- built-in LSP (0.11+). Servers only enabled if their binary exists, so light hosts stay light.
-- Deferred to the first real buffer so `nvim` startup does not pay for vim.lsp; blink.cmp (1.x) adds
-- its capabilities itself when it loads, so it is not required here (keeps it lazy on InsertEnter).
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, { once = true, callback = function()
  local servers = {
    rust_analyzer = "rust-analyzer", pyright = "pyright-langserver", ruff = "ruff",
    ts_ls = "typescript-language-server", clangd = "clangd", lua_ls = "lua-language-server",
    gopls = "gopls", bashls = "bash-language-server",
  }
  vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
  for name, bin in pairs(servers) do
    if vim.fn.executable(bin) == 1 then vim.lsp.enable(name) end
  end
  vim.diagnostic.config({ virtual_text = true, severity_sort = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local m = function(k, f) vim.keymap.set("n", k, f, { buffer = ev.buf }) end
      m("gd", vim.lsp.buf.definition); m("K", vim.lsp.buf.hover)
      m("<leader>rn", vim.lsp.buf.rename); m("<leader>ca", vim.lsp.buf.code_action)
      local c = vim.lsp.get_client_by_id(ev.data.client_id)
      if c and c:supports_method("textDocument/inlayHint") then vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf }) end
    end,
  })
end })
