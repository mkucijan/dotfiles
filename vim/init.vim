set nocompatible

"let g:python_host_prog = '/usr/bin/python'
"let g:loaded_python_provider = 1
"let g:python3_host_prog = '/usr/bin/python3'
  
"let &t_SI = "\x1b[6 q"
"let &t_SR = "\x1b[4 q"
"let &t_EI = "\x1b[0 q"


"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath = &runtimepath
source /home/mkucijan/dotfiles/vim/vimrc.vim
"source /home/mkucijan/dotfiles/vim/visSum.vim
call plug#begin('~/.vim/plugged')

" turn of if spacing is wrong
" Plug 'tpope/vim-sleuth'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
"
" Plug 'ripxorip/aerojump.nvim', { 'do': ':UpdateRemotePlugins' }
"
" Plug 'justinmk/vim-sneak'
" Plug 'junegunn/vim-slash'
" " Plug 'https://github.com/easymotion/vim-easymotion'
"
" Plug 'https://github.com/skywind3000/asyncrun.vim'
" Plug 'https://github.com/scrooloose/nerdtree'
"
Plug 'christoomey/vim-tmux-navigator'

Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'https://github.com/joshdick/onedark.vim'
" Plug 'https://github.com/sheerun/vim-polyglot'
" Plug 'https://github.com/tpope/vim-fugitive'
" Plug 'https://github.com/mattn/webapi-vim'

" Plug 'https://github.com/wesQ3/vim-windowswap'

" Plug 'w0rp/ale' " using flake8
" Plug 'ludovicchabant/vim-gutentags' " create, maintain tags (using universal-ctags)
" Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" Plug 'janko-m/vim-test'


" Plug 'Valloric/YouCompleteMe',
"             \ { 'do': './install.py --clang-completer --rust-completer --java-completer --ts-completer --go-completer' }

"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Plug 'rust-lang/rust.vim'
" Plug 'racer-rust/vim-racer'
" Plug 'sebastianmarkow/deoplete-rust'

"Plug 'Shougo/neosnippet.vim'
"Plug 'Shougo/neosnippet-snippets'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-bash' }
Plug 'junegunn/fzf.vim'

" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

"Plug 'aurieh/discord.nvim', { 'do': ':UpdateRemotePlugins'}

" Track the engine.
" Plug 'SirVer/ultisnips'
" " Snips
" Plug 'honza/vim-snippets'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" let g:UltiSnipsExpandTrigger="<c-q>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"
" " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"


" Preview search-and-replace
" Plug 'markonm/traces.vim'
" let g:traces_preserve_view_state = 1

" Undo tree
" Plug 'mbbill/undotree'
" noremap U :UndotreeToggle<CR>
" let g:undotree_SetFocusWhenToggle = 1
" let g:undotree_WindowLayout = 3

" Comment line(s) using t key
Plug 'tomtom/tcomment_vim'
let g:tcomment_maps = 0
nnoremap <silent> t :TComment<CR>j
vnoremap <silent> t :TComment<CR>

call plug#end()

"let g:discord_clientid = 411234500836851714
"let $PYTHONUNBUFFERED=1

" LSP
"set hidden


" Fzf search and destroy
source $DOTFILES_HOME/dotfiles/vim/fzf.vim


" Aerojump
"nmap <Leader>as <Plug>(AerojumpSpace)
"nmap <Leader>ab <Plug>(AerojumpBolt)
"nmap <Leader>aa <Plug>(AerojumpFromCursorBolt)
"nmap <Leader>ad <Plug>(AerojumpDefault) "

" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"     \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
"     \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
"     \ 'python': ['/usr/local/bin/pyls'],
"     \ 'ruby': ['/usr/local/bin/solargraph', 'stdio'],
"     \ }
"
"
" let g:neoformat_rust_rustfmt = {
"    \ 'exe': 'rustfmt',
"    \ 'args': ['--edition', '2018', '--unstable-features'],
"    \ 'stdin': 1,
"    \ }
" nnoremap <silent> <space>f :Neoformat<CR>
" vnoremap <silent> <space>f :Neoformat<CR>
"
"
" augroup load_ycm
"       " Load plugin when entering insert mode.
"       au! InsertEnter *
"         \   call plug#load('YouCompleteMe')
"         \ | call youcompleteme#Enable()
"         \ | setl formatoptions-=o
" 		\ | au! load_ycm
" augroup END
" let g:ycm_confirm_extra_conf = 0
" let g:ycm_show_diagnostics_ui = 0
" let g:ycm_global_ycm_extra_conf = '$DOTFILES_HOME/dotfiles/vim/ycm_extra_conf.py'
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>', '<Tab>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>', '<S-Tab>']
" map <silent> <space>j :YcmCompleter GoTo<CR>
" map <silent> q :YcmCompleter GetDoc<CR>
" map <silent> <C-q> :YcmCompleter GoTo<CR>
" let g:ycm_rust_src_path = '/home/mkucijan/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
"


" let b:ale_fixers = ['prettier', 'eslint']
" let g:ale_linters = {'rust': ['rls']}
" let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
" let g:ale_cpp_clangcheck_options = '-std=c++14'
" nmap ]w <plug>(ale_next_wrap)
" nmap [w <plug>(ale_previous_wrap)
" hi link ALEError Default
" hi link ALEWarning Default



" let g:rustfmt_autosave = 1
" let g:rustfmt_emit_files = 1
" let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'
"let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"


" " deoplete.nvim, deoplete-jedi
" let g:deoplete#sources = {'_': ['ale', 'foobar']}
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#sources#jedi#show_docstring = 1
" let g:deoplete#enable_ignore_case = 1
" let g:deoplete#enable_smart_case = 1
" let g:deoplete#sources#rust#racer_binary='/home/mkucijan/.cargo/bin/racer'
" let g:deoplete#sources#rust#rust_source_path='/home/mkucijan/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
" let g:deoplete#sources#rust#documentation_max_height=20
"
" let g:deoplete#sources#rust#disable_keymap = 1
" let g:racer_experimental_completer = 1
" let g:racer_no_default_keymappings = 1
" let g:tagbar_type_rust = {
"   \   'ctagstype' : 'rust',
"   \   'sort' : '0',
"   \   'kinds' : [ 'm:modules', 'c:consts', 'T:types', 'g:enums',
"   \               's:structs', 't:traits', 'i:impls', 'f:functions' ]
"   \ }
" autocmd FileType rust
"   \   setl colorcolumn=100
"   \ | setl sw=4 ts=4 expandtab
"   \ | compiler cargo
"   \ | inoremap <buffer><expr><CR> "\<CR>" . <SID>complete_braces()


" Disable the candidates in Comment/String syntaxes.
" call deoplete#custom#source('_',
"            \ 'disabled_syntaxes', ['Comment', 'String'])

"gutentags
"let g:gutentags_gtags_dbpath = $DOTFILES_HOME/.vim/tags
" let gutentags_enabled = 0
" let g:gutentags_project_root = ['.root']
" let g:gutentags_ctags_exclude = ['*CMakeFiles*', '.ycm_extra_conf.py']



" " tagbar
" let g:rust_use_custom_ctags_defs = 1  " if using rust.vim
" let g:tagbar_type_rust = {
"   \ 'ctagsbin' : '/usr/local/bin/ctags',
"   \ 'ctagstype' : 'rust',
"   \ 'kinds' : [
"       \ 'n:modules',
"       \ 's:structures:1',
"       \ 'i:interfaces',
"       \ 'c:implementations',
"       \ 'f:functions:1',
"       \ 'g:enumerations:1',
"       \ 't:type aliases:1:0',
"       \ 'v:constants:1:0',
"       \ 'M:macros:1',
"       \ 'm:fields:1:0',
"       \ 'e:enum variants:1:0',
"       \ 'P:methods:1',
"   \ ],
"   \ 'sro': '::',
"   \ 'kind2scope' : {
"       \ 'n': 'module',
"       \ 's': 'struct',
"       \ 'i': 'interface',
"       \ 'c': 'implementation',
"       \ 'f': 'function',
"       \ 'g': 'enum',
"       \ 't': 'typedef',
"       \ 'v': 'variable',
"       \ 'M': 'macro',
"       \ 'm': 'field',
"       \ 'e': 'enumerator',
"       \ 'P': 'method',
"   \ },
" \ }
" tagbar
" let g:tagbar_autofocus = 1


" let g:deoplete#sources.python3 = ['LanguageClient']



" " ale, flake8 settings
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_insert_leave = 1


" skins

let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'onedark'
let g:airline#extensions#branch#enabled = 1

" navi
" set rtp+=/home/mkucijan/.fzf/bin/fzf
" set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf



" Complete braces on <CR> in a sensible way
function! s:complete_braces()
  let line = getline('.')
  let col = col('.')
  if col < 1000 && col == len(line) + 1 && matchstr(line, '\%' . (col-1) . 'c.') == '{'
    return "}\<C-o>k\<C-o>A\<CR>"
  endif
  return ""
endfunction
inoremap <buffer><expr><CR> "\<CR>" . <SID>complete_braces()

" " Start ranger and open the chosen file
" function! s:ranger()
"   exec "silent !ranger --choosefiles=/tmp/chosenfile --selectfile="
"         \ . expand("%:p")
"   if filereadable('/tmp/chosenfile')
"     exec system('sed -ie "s/ /\\\ /g" /tmp/chosenfile')
"     exec 'argadd ' . system('cat /tmp/chosenfile | tr "\\n" " "')
"     exec 'edit ' . system('head -n1 /tmp/chosenfile')
"     call system('rm -f /tmp/chosenfile')
"   endif
"   redraw!
" endfunction
" nnoremap <silent> - :call <SID>ranger()<CR>



if (empty($TMUX))
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
function TrBg()
if !has("gui_running")
if (has("autocmd"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
    colorscheme onedark
  augroup END
endif
endif
endfunction

colorscheme onedark

" nnoremap <silent> <F4> :TagbarToggle<CR>
" autocmd Filetype python nnoremap <silent> <F3> :py3f %<CR>

"map <C-n> :NERDTreeToggle<CR>
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif




" COC
" TextEdit might fail if hidden is not set.
"set hidden

" Some servers have issues with backup files, see #649.
"set nobackup
"set nowritebackup

" Give more space for displaying messages.
"set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
"set updatetime=300

" Don't pass messages to |ins-completion-menu|.
"set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
"set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

" Use <c-space> to trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
"if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif

" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>

"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
"nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)

"augroup mygroup
"  autocmd!
  " Setup formatexpr specified filetype(s).
"  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
"  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
"nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
"nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"xmap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap if <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
"command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
"nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
"nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
"nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
"nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
"nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
"nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
"nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
