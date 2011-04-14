" Enable file type detection, all three modes
" detection, indent, plugin.  See :help filetype
filetype plugin indent on

" Turn on syntax highlighting, using defaults
" See :help syntax
syntax on

set laststatus=2
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set autoindent
set number
set numberwidth=4
set incsearch

" Turn on search highlighting
set hlsearch

" Use the man.vim plugin if its available
runtime! ftplugin/man.vim

" colorscheme asmdev
" colorscheme norwaytoday
if &term =~ ".*256color"
	colorscheme xoria256
else
	colorscheme ir_black
endif

" 2010-05-12
" Override the highlight settings for NERD_tree.  This is mainly because
" ir_black colorscheme looks terrible with treeRO linked to WarningMsg
hi link treeRO Normal

" 2011-02-08
" Set the NERDTree status line such that it always shows the full path of the
" currently selected node.  I realize this is a little inefficient at the moment
" since it calls GetSelected() twice, but I cannot figure out a way to get
" around that at the moment.  This status line pretty much makes my
" path_copy.vim NERDTree plugin useless, but whatever.
" let g:NERDTreeStatusline='%{has_key(g:NERDTreeFileNode.GetSelected(), "path") ? g:NERDTreeFileNode.GetSelected().path.str() : b:NERDTreeRoot.path.str()}'
let g:NERDTreeStatusline = '%{ getcwd() }'

" 2011-04-14
" Use the fancy arrows for the NERDtree interface and turn off the AutoCenter
" feature
let g:NERDTreeDirArrows  = 1
let g:NERDTreeAutoCenter = 0

" 2011-02-11
" Emacs style command line editing slightly modified
" :help emacs-keys
" start of line
:cnoremap <C-a>		<Home>
" delete character under cursor
:cnoremap <C-d>		<Del>
" end of line
:cnoremap <C-e>		<End>
" back one word
:cnoremap <Esc>b	<S-Left>
" forward one word
:cnoremap <Esc>f	<S-Right>
" Delete one word to the right
:cnoremap <Esc>d	<S-Right><C-w>
" delete one word to the left
:cnoremap <Esc><C-?>	<C-w>

" Set the tabline to our custom function
set tabline=%!DrawTabLine()

" 2010-05-18
" Playing around with moving tabs
" tab numbers run from 1 to n
function! MoveTabLeft()
	let current = tabpagenr()
	if current == 1
		let current = tabpagenr('$') + 1
	endif
	execute "tabmove" (current-2)
endfunction

function! MoveTabRight()
	let current = tabpagenr()
	if current == tabpagenr('$')
		let current = 0
	endif
	execute "tabmove" current
endfunction

" Map Control-Left and Control-Right
" to dragging a tab left or right
nmap <silent> <C-Left> :call MoveTabLeft()<CR>
nmap <silent> <C-Right> :call MoveTabRight()<CR>

" Map Control-h and Control-l
" to moving left and right through the open tabs
nmap <silent> <C-h> :tabp<CR>
nmap <silent> <C-l> :tabn<CR>

" 2010-12-30
" Fix for control left and right moving of tabs within screen.
" It seems that the keycodes only work for xterm due to vim's
" builtin_xterm termcap codes.
if &term =~ 'screen\|screen-256color'
	set <C-Left>=[1;5D
	set <C-Right>=[1;5C
endif

" Map Alt-1 (at least on my mac) such that it opens the quick fix window
" and then prepares a vimgrep for me w/o jumping to the first
" match it finds
:nmap <ESC>1 :copen<CR>:vimgrep ##j **/*<Left><Left><Left><Left><Left><Left><Left>

" 2011-01-11
" Map / and ? while in visual mode to search for the highlighted text
:vmap / y/<C-R>=escape('<C-R>"', '/\')<CR><CR>
:vmap ? y/<C-R>=escape('<C-R>"', '/\')<CR><CR>

" 2010-09-24
" Added newer python syntax highlighting script
" Enable all the syntax options in it (.vim/syntax/python.vim)
let python_highlight_all = 1
let python_highlight_indent_errors = 0
let python_highlight_space_errors = 0

" 2011-03-30
" Vim's error highlighting of vimscript isn't always correct, turn it off
" :help ft-vim-syntax
let g:vimsyn_noerror = 1

" 2010-10-03
" Make shortcuts for jumping directly to a specific tab
" We're mapping <Leader> (which defaults to \) followed by {number} (where
" number is in the range 1-9) to jump to that numbered tab
for i in range(1,9)
	execute "nmap <silent> <Leader>" . i . " :tabnext " . i . "<CR>"
endfor

" 2011-03-15
" Playing around with better ways to get shell output into vim
" http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
function! s:ExecuteInShell(command)
	let command = join(map(split(a:command), 'expand(v:val)'))
	let winnr = bufwinnr('^' . command . '$')
	silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
	setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
	echo 'Execute ' . command . '...'
	silent! execute 'silent %!'. command
	silent! execute 'resize ' . line('$')
	silent! redraw
	silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
	silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
	echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
