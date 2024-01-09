set shell=/bin/zsh
let mapleader = "\<space>"


call plug#begin()

" Plug 'github/copilot.vim'

" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'ggandor/leap.nvim'


" GUI
Plug 'christoomey/vim-tmux-navigator'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
"Plug 'https://github.com/joshdick/onedark.vim'
Plug 'tomasiser/vim-code-dark'

" Windows
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Util
Plug 'airblade/vim-rooter'
Plug 'folke/trouble.nvim'
Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' }

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
Plug 'hrsh7th/cmp-path', {'branch': 'main'}
Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
Plug 'ray-x/lsp_signature.nvim'
Plug 'gfanto/fzf-lsp.nvim'
Plug 'lvimuser/lsp-inlayhints.nvim'

" Only because nvim-cmp _requires_ snippets
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'


" Syntactic language support
Plug 'cespare/vim-toml', {'branch': 'main'}
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'
Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'

" git
Plug 'https://github.com/tpope/vim-fugitive'

" treesitter
" Plug 'nvim-treesitter/nvim-treesitter'

" debugger
Plug 'mfussenegger/nvim-dap'

" terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.*'}

" Comment line(s) using t key
Plug 'tomtom/tcomment_vim'
let g:tcomment_maps = 0
nnoremap <silent> t :TComment<CR>j
vnoremap <silent> t :TComment<CR>

call plug#end()

if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    set inccommand=nosplit
    noremap <C-q> :confirm qall<CR>
end

" GUI
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 1
" let g:airline_theme = 'onedark'
let g:airline_theme = 'codedark'
let g:codedark_conservative=0
let g:codedark_italics=1
let g:codedark_transparent=1


" LSP configuration
lua << END
local cmp = require'cmp'

local lspconfig = require'lspconfig'
cmp.setup({
  snippet = {
    -- REQUIRED by nvim-cmp. get rid of it once we can
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-g>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    -- ['<Tab>'] = cmp.mapping.confirm({
    --   behavior = cmp.ConfirmBehavior.Insert,
    --   select = false,
    -- }),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  sources = cmp.config.sources({
    -- TODO: currently snippets from lsp end up getting prioritized -- stop that!
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  }),
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '',
              buffer = 'Ω',
              path = '',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
  experimental = {
    ghost_text = true,
  },
})


-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--         { name = 'path' }
--     }, {
--         { name = 'cmdline' }
--     })
-- })
cmp.setup.cmdline(':', {
  sources = {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = {}
      }
    }
  } 
})


-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- inlay hints
require("lsp-inlayhints").setup()

-- Setup lspconfig.
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- Get signatures (and _only_ signatures) when in argument lists.
  require "lsp_signature".on_attach({
    doc_lines = 0,
    handler_opts = {
      border = "none"
    },
  })

  -- inlay hints
  require("lsp-inlayhints").on_attach(client, bufnr)
  buf_set_keymap('n', '<F2>', ":lua require'lsp-inlayhints'.toggle()<CR>", opts)
  buf_set_keymap('n', '<c-h>', ":lua require'lsp-inlayhints'.toggle()<CR>", opts)
end

-- setup fzf lsp
require'fzf_lsp'.setup()

-- rust analyzer
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
         command = "clippy"
      },
      procMacro = {
        enable = true,
        ignored = {
            leptos_macro = {
                -- optional: --
                -- "component",
                "server",
            },
        },

      },
      imports = {
        granularity = {
              group = "module",
        },
        prefix = "self",
      },
      cargo = {
        allFeatures = true,
      },
      completion = {
        postfix = {
          enable = false,
        },
      },
    },
  },
  capabilities = capabilities,
}
-- lsp sql
lspconfig.sqlls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}
-- lsp python
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
-- lsp js/ts
lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- `clangd`.
lspconfig.clangd.setup {
  capabilities = capabilities,
}

-- lsp haskell
lspconfig.hls.setup{
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  capabilities = capabilities,
  haskell = {
    cabalFormattingProvider = "cabalfmt",
    formattingProvider = "ormolu"
  }
}



-- leap
require('leap').add_default_mappings()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

-- treesitter
--   require('nvim-treesitter.configs').setup {
--     ensure_installed = { "lua", "rust", "toml" },
--     auto_install = true,
--     highlight = {
--       enable = true,
--       additional_vim_regex_highlighting=false,
--       disable = { "c", "rust" }
--     },
--     ident = { enable = true },
--     rainbow = {
--       enable = true,
--       extended_mode = true,
--       max_file_lines = nil,
--     }
--   }


-- file tree
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
-- NVIM TREE KEY MAPPINGS
vim.api.nvim_set_keymap('n', '<F3>', ':NvimTreeToggle<CR>', { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', '<F4>', ':NvimTreeFindFileToggle<CR>', { noremap = false, silent = true })


-- telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
      ["<C-j>"] = "move_selection_next",
      ["<C-k>"] = "move_selection_previous",
      }
    }
  },
  pickers = {
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      theme = "dropdown",
      layout_config = {
        width = 0.5
      },
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        }
      }

    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')


-- highlights
require("trouble").setup {
-- your configuration comes here
-- or leave it empty to use the default settings
-- refer to the configuration section below
}

-- progress icon 
require"fidget".setup{
  align = {
    bottom = false,            -- align fidgets along bottom edge of buffer
    right = true,             -- align fidgets along right edge of buffer
  },
}


-- debugger
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}

dap.configurations.rust = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}

dap.configurations.c = dap.configurations.rust
dap.configurations.cpp = dap.configurations.rust

-- terminal
require("toggleterm").setup{
  open_mapping = [[<c-Tab>]],
  hide_numbers = true
}
-- vim.api.nvim_set_keymap('n', '<c-Tab>', ':ToggleTerm<CR>', { noremap = false, silent = true })


local lsp_or_leptos = function()
	-- Handle to the current buffer
	local filetype = vim.filetype.match({ buf = 0 })
	if filetype == "rust" then
		-- Get all lines within the buffer
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		local probably_leptos_project = false
		-- true if any line contains "leptos"
		for _, line in ipairs(lines) do
			if line:match("leptos") then
				probably_leptos_project = true
			end
		end

		if probably_leptos_project == true then
			vim.cmd.write() -- Write the buffer,

			-- remove 'silent' if you want to see errors and all that.
			vim.cmd([[silent !leptosfmt % -t 2]]) -- '%' expands to [path to current buffer]
			vim.notify("Formatted with leptosfmt!", vim.log.levels.INFO)
			return
		end
	end
	vim.lsp.buf.format()
end

vim.keymap.set("n", "<leader>'", lsp_or_leptos)

END


" rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'


" Completion
" Better completion
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300



" =============================================================================
" # Editor settings
" =============================================================================
set encoding=utf-8
" Ignore case when searching unless upper case is used
set ignorecase
set smartcase
set number
set autoindent
set cursorline
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set scrolloff=5
set mouse=n

" Background on preview color
" highlight Pmenu ctermbg=darkblue guibg=darkblue
" Colors
colorscheme codedark

" backup
set backup
set writebackup
set backupcopy=yes
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

set undodir=$DOTFILES_HOME/.vim/undo//,/tmp
set backupdir=$DOTFILES_HOME/.vim/backup//,/tmp
set directory=$DOTFILES_HOME/.vim/swap//,/tmp

" Copy paste
map <C-c> "+y<CR>


" =============================================================================
" # Keyboard shortcuts
" =============================================================================

" Fzf search and destroy
source $DOTFILES_HOME/dotfiles/vim/fzf.vim
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>fc <cmd>Telescope help_tags<cr>
nnoremap <leader>fw <cmd>Telescope grep_string<cr>


" trouble highlight bindings
nnoremap <leader>mm <cmd>TroubleToggle<cr>
nnoremap <leader>mw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>md <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>mq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>ml <cmd>TroubleToggle loclist<cr>
noremap gR <cmd>TroubleToggle lsp_references<cr>


" Terminal bindings
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>

" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>


" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>
