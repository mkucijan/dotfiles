" Fzf search and destroy

source $DOTFILES_HOME/dotfiles/vim/functions.vim

" {{{ Project-wide search

let g:search_ignore_dirs = ['.git', 'node_modules']

" TODO: git grep when under repository
" Choose grep backend, use ripgrep if available
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --hidden\ --follow
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ -n\ --with-filename\ -I\ -R
  set grepformat=%f:%l:%m
endif

" Without bang, search is relative to cwd, otherwise relative to current file
command -nargs=* -bang -complete=file Grep call <SID>execute_search("Grep", <q-args>, <bang>0)
command -nargs=* -bang -complete=file GrepFzf call <SID>execute_search("GrepFzf", <q-args>, <bang>0)

" :grep + grepprg + quickfix list
nnoremap <F7><F7> :call <SID>prepare_search_command("", "Grep")<CR>
nnoremap <F7>w :call <SID>prepare_search_command("word", "Grep")<CR>
nnoremap <F7>s :call <SID>prepare_search_command("selection", "Grep")<CR>
nnoremap <F7>/ :call <SID>prepare_search_command("search", "Grep")<CR>
vnoremap <silent> <F7> :call <SID>prepare_search_command("selection", "Grep")<CR>

" ctrlsf.vim (uses ack, ag or rg under the hood)
nnoremap <S-F7><F7> :call <SID>prepare_search_command("", "GrepSF")<CR>
nnoremap <S-F7>w :call <SID>prepare_search_command("word", "GrepSF")<CR>
nnoremap <S-F7>s :call <SID>prepare_search_command("selection", "GrepSF")<CR>
nnoremap <S-F7>/ :call <SID>prepare_search_command("search", "GrepSF")<CR>
vnoremap <silent> <S-F7> :call <SID>prepare_search_command("selection", "GrepSF")<CR>

" fzf-vim + ripgrep
nnoremap <leader><F7><F7> :call <SID>prepare_search_command("", "GrepFzf")<CR>
nnoremap <leader><F7>w :call <SID>prepare_search_command("word", "GrepFzf")<CR>
nnoremap <leader><F7>s :call <SID>prepare_search_command("selection", "GrepFzf")<CR>
nnoremap <leader><F7>/ :call <SID>prepare_search_command("search", "GrepFzf")<CR>
vnoremap <silent> <leader><F7> :call <SID>prepare_search_command("selection", "GrepFzf")<CR>

" fzf command
noremap <A-c> :call fzf#vim#commands()<CR>

" Execute search for particular command (Grep, GrepSF, GrepFzf)
function s:execute_search(command, args, is_relative)
  if empty(a:args)
    call functions#s:echo_warning("Search text not specified")
    return
  endif

  let extra_args = []
  let using_ripgrep = &grepprg =~ '^rg'

  " Set global mark to easily get back after we're done with a search
  normal mF

  " Exclude well known ignore dirs
  " This is useful for GNU grep, that does not respect .gitignore
  let ignore_dirs = s:get_var('search_ignore_dirs')
  for l:dir in ignore_dirs
    if using_ripgrep
      call add(extra_args, '--glob ' . shellescape(printf("!%s/", l:dir)))
    else
      call add(extra_args, '--exclude-dir ' . shellescape(printf("%s", l:dir)))
    endif
  endfor

  " Change cwd temporarily if search is relative to the current file
  if a:is_relative
    exe "cd " . expand("%:p:h")
  endif

  " Execute :grep + grepprg search, show results in quickfix list
  if a:command ==# 'Grep'
    " Perform search
    silent! exe "grep! " . join(extra_args) . " " . a:args
    redraw!

    " If matches are found, open quickfix list and focus first match
    " Do not open with copen, because we have qf list automatically open on search
    if len(getqflist())
      cc
    else
      cclose
      call functions#s:echo_warning("No match found")
    endif
  endif

  " Execute search using fzf.vim + grep/ripgrep
  if a:command ==# 'GrepFzf'
    " Run in fullscreen mode, with preview at the top
    call fzf#vim#grep(printf("%s %s --color=always %s", &grepprg, join(extra_args), a:args),
          \ 1,
          \ fzf#vim#with_preview('up:60%'),
          \ 1)
  endif

  " Restore cwd back
  if a:is_relative
    exe "cd -"
  endif
endfunction

function s:execute_search_ctrlsf(args, is_relative)
  if empty(a:args)
    call s:echo_warning("Search text not specified")
    return
  endif

  " Show CtrlSF search pane in new tab
  tab split
  let t:is_ctrlsf_tab = 1

  " Change cwd, but do it window-local
  " Do not restore cwd, because ctrlsf#Search is async
  " Just close tab, when you're done with a search
  if a:is_relative
    exe "lcd " . expand("%:p:h")
  endif

  " Create new scratch buffer
  enew
  setlocal bufhidden=delete nobuflisted

  " Execute search
  call ctrlsf#Search(a:args)
endfunction

" Initiate search, prepare command using selected backend and context for the search
" Contexts are: word, selection, last search pattern
function s:prepare_search_command(context, backend)
  let text = a:context ==# 'word' ? expand("<cword>")
        \ : a:context ==# 'selection' ? s:get_selected_text()
        \ : a:context ==# 'search' ? @/
        \ : ''

  " Properly escape search text
  " Remove new lines (when several lines are visually selected)
  let text = substitute(text, "\n", "", "g")

  " Escape backslashes
  let text = escape(text, '\')

  " Put in double quotes
  let text = escape(text, '"')
  let text = empty(text) ? text : '"' . text . '"'


  " Grep/ripgrep/ctrlsf args
  " Always search literally, without regexp
  " Use word boundaries when context is 'word'
  let args = [a:backend ==# 'GrepSF' ? '-L' : '-F']
  if a:context ==# 'word'
    call add(args, a:backend ==# 'GrepSF' ? '-W' : '-w')
  endif

  " Compose ":GrepXX" command to put on a command line
  let search_command = ":\<C-u>" . a:backend
  let search_command .= empty(args) ? ' ' : ' ' . join(args, ' ') . ' '
  let search_command .= '-- ' . text

  " Put actual command in a command line, but do not execute
  " User would initiate a search manually with <CR>
  call feedkeys(search_command, 'n')
endfunction

" }}}


function s:echo_warning(message)
  echohl WarningMsg
  echo a:message
  echohl None
endfunction

function s:Noop()
endfunction

function s:get_var(...)
  let varName = a:1

  if exists('w:' . varName)
    return w:{varName}
  elseif exists('b:' . varName)
    return b:{varName}
  elseif exists('g:' . varName)
    return g:{varName}
  else
    return exists('a:2') ? a:2 : ''
  endif
endfunction


" PLUGIN: fzf.vim{{{

let g:fzf_layout = { 'down': '~40%' }

" Populate quickfix list with selected files
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  botright copen
  cc
endfunction

" Ctrl-q allows to select multiple elements an open them in quick list
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Add namespace for fzf.vim exported commands
let g:fzf_command_prefix = 'Fzf'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" File path completion in Insert mode using fzf
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-buffer-line)

" Use preview when FzfFiles runs in fullscreen
command! -nargs=? -bang -complete=dir FzfFiles
      \ call fzf#vim#files(<q-args>, <bang>0 ? fzf#vim#with_preview('up:60%') : {}, <bang>0)

" Mappings
nnoremap <silent> <leader>o :FzfFiles<CR>
nnoremap <silent> <leader>O :FzfFiles!<CR>
cnoremap <silent> <C-p>  :FzfHistory:<CR>
cnoremap <silent> <C-_> <ESC>:FzfHistory/<CR>
nnoremap <silent> <leader>b  :FzfBuffers<CR>
nnoremap <silent> <leader>m  :FzfMarks<CR>
nnoremap <silent> <F1> :FzfHelptags<CR>
inoremap <silent> <F1> <ESC>:FzfHelptags<CR>
noremap <silent> <leader>; :FzfCommands<CR>
nnoremap <silent> <leader>l :FzfBLines<CR>
inoremap <silent> <F3> <ESC>:FzfSnippets<CR>
inoremap <silent> <A-c> <ESC>:FzfSnippets<CR>

" fzf.Tags uses existing 'tags' file or generates it otherwise
nnoremap <silent> <leader>t :FzfTags<CR>
xnoremap <silent> <leader>t "zy:FzfTags <C-r>z<CR>

" fzf.BTags generate tags on-fly for current file
nnoremap <silent> <leader>T :FzfBTags<CR>
xnoremap <silent> <leader>T "zy:FzfBTags <C-r>z<CR>

" Show list of change in fzf
" Some code is borrowed from ctrlp.vim and tweaked to work with fzf
command FzfChanges call s:fzf_changes()

function! s:fzf_changelist()
  redir => result
  silent! changes
  redir END

  return map(split(result, "\n")[1:], 'tr(v:val, "	", " ")')
endf

function! s:fzf_changeaccept(line)
  let info = matchlist(a:line, '\s\+\(\d\+\)\s\+\(\d\+\)\s\+\(\d\+\).\+$')
  call cursor(get(info, 2), get(info, 3))
  silent! norm! zvzz
endfunction

function! s:fzf_changes()
  return fzf#run(fzf#wrap({
        \ 'source':  reverse(s:fzf_changelist()),
        \ 'sink': function('s:fzf_changeaccept'),
        \ 'options': '+m +s --nth=3..'
        \ }))
endfunction


" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" }}}


nnoremap <silent> <leader>gla :FzfCommits<CR>
nnoremap <silent> <leader>glf :FzfBCommits<CR>
