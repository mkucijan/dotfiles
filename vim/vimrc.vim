" General Vim settings
    execute "set t_8f=\e[38;2;%lu;%lu;%lum"
    execute "set t_8b=\e[48;2;%lu;%lu;%lum"
    syntax on
	let mapleader=","
	set autoindent
	set number
    xnoremap p pgvy

    " Source zsh configs
    set shellcmdflag=-ic

    set tags=tags

	set cursorline
	hi Cursor ctermfg=White ctermbg=Yellow cterm=bold guifg=white guibg=yellow gui=bold

	set hlsearch
	nnoremap <C-l> :nohl<CR><C-l>:echo "Search Cleared"<CR>

	nnoremap n nzzzv
	nnoremap N Nzzzv

	nmap <tab> %

    set backspace=indent,eol,start

	nnoremap <Space> za
	nnoremap <leader>z zMzvzz

	nnoremap vv v$

	set listchars=tab:\|\ 
	nnoremap <leader><tab> :set list!<cr>
	set pastetoggle=<F2>
	set mouse=a
	set incsearch


    set expandtab
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set scrolloff=5

    set backup
    set writebackup
    set backupcopy=yes
    au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

    set undodir=$DOTFILES_HOME/.vim/undo//,/tmp
    set backupdir=$DOTFILES_HOME/.vim/backup//,/tmp
    set directory=$DOTFILES_HOME/.vim/swap//,/tmp

    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif


    set path+=**

    " Ignore case when searching unless upper case is used
    set ignorecase
    set smartcase

    vnoremap // y/<C-R>"<CR>
    map <C-c> "+y<CR>
    nnoremap <silent> <esc> :noh<cr><esc>

" Language Specific
	" General
		inoremap <leader>for <esc>Ifor (int i = 0; i < <esc>A; i++) {<enter>}<esc>O<tab>
		inoremap <leader>if <esc>Iif (<esc>A) {<enter>}<esc>O<tab>
		

	" Java
		inoremap <leader>sys <esc>ISystem.out.println(<esc>A);
		vnoremap <leader>sys yOSystem.out.println(<esc>pA);

	" Java
		inoremap <leader>con <esc>Iconsole.log(<esc>A);
		vnoremap <leader>con yOconsole.log(<esc>pA);

	" C++
		inoremap <leader>cout <esc>Istd::cout << <esc>A << std::endl;
		vnoremap <leader>cout yOstd::cout << <esc>pA << std:endl;

	" C
		inoremap <leader>out <esc>Iprintf(<esc>A);<esc>2hi
		vnoremap <leader>out yOprintf(, <esc>pA);<esc>h%a

	" Typescript
		autocmd BufNewFile,BufRead *.ts set syntax=javascript
		autocmd BufNewFile,BufRead *.tsx set syntax=javascript

	" Markup
		inoremap <leader>< <esc>I<<esc>A><esc>yypa/<esc>O<tab>


" File and Window Management 
	"inoremap <leader>w <Esc>:w<CR>
	"nnoremap <leader>w :w<CR>

	"inoremap <leader>q <ESC>:q<CR>
	"nnoremap <leader>q :q<CR>

	"inoremap <leader>x <ESC>:x<CR>
	"nnoremap <leader>x :x<CR>

	nnoremap <leader>e :Ex<CR>
	nnoremap <leader><C-t> :tabnew<CR>:FzfFiles!<CR>
	nnoremap <leader>v :vsplit<CR>:FzfFiles!<CR>
	nnoremap <leader>s :split<CR>:FzfFiles!<CR>

" Return to the same line you left off at
	augroup line_return
		au!
		au BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\	execute 'normal! g`"zvzz' |
			\ endif
	augroup END

" Future stuff
	"Swap line
	"Insert blank below and above

    " datetime
    nnoremap <F5> "=strftime("%c")<CR>P
    inoremap <F5> <C-R>=strftime("%c")<CR>

