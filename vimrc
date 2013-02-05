" Pathogen testing
call pathogen#infect($BUNDLE_ROOT) 

" Change the default leader key
let mapleader = ","
let maplocalleader = ","

" Enable file type detection, all three modes
" detection, indent, plugin.  See :help filetype
filetype plugin indent on

" Turn on syntax highlighting, using defaults
" See :help syntax
syntax on

set laststatus=2
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [FE=%{&fileencoding}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set autoindent
set number
set numberwidth=4
set incsearch
set showcmd

" Turn on search highlighting
set hlsearch

" Use the man.vim plugin if its available
runtime! ftplugin/man.vim

" colorscheme asmdev
" colorscheme norwaytoday
if (&term == "rxvt-unicode") || ($COLORTERM =~ 'rxvt.*')
	" the first check catches normal urxvt, the second catches screen
	" inside urxvt
	set bg=dark
	colorscheme solarized
elseif	&term =~ "xterm-256color"
	colorscheme xoria256
elseif  &term =~ "screen-256color"
	colorscheme xoria256
	set <xUp>=[1;*A
	set <xDown>=[1;*B
	set <xLeft>=[1;*D
	set <xRight>=[1;*C
else
	colorscheme ir_black
endif

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

" 2011-12-28
" Change the default NERDTree quick help key so I can still reverse search
let g:NERDTreeMapHelp = 'H'

" 2011-12-31
" Set the default size of the NERDTree window
let g:NERDTreeWinSize = 36

" 2012-01-14
" Map :NERDTreeFind to an easily accessible key sequence
nnoremap <silent> <Leader>r :NERDTreeFind<CR>

" 2012-04-26
" Map :NERDTree to something easier to type
nnoremap <silent> <Leader>nt :NERDTree<CR>

" 2011-12-31
" Disable netrw
" :help netrw-noload
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" 2011-12-25
" Trying to use buffers instead of tab pages
set hidden

" 2012-01-09
" Bufexplorer settings
let g:bufExplorerDetailedHelp = 1
let g:bufExplorerSortBy = 'fullpath'
let g:bufExplorerShowTabBuffer = 0
let g:bufExplorerShowRelativePath = 1
let g:bufExplorerJumpToCurBufLine = 1

" 2012-01-09
" Window movement commands
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" 2011-12-30
" Easier access to :Kwbd command from plugin/kwbd.vim
nnoremap <silent> <Leader>bd :Kwbd<CR>
nnoremap <silent> <Leader>bw :Kwbw<CR>

" 2012-11-20
" Easier tab jumping
for i in range(1,12)
	exec printf("nnoremap <silent> <F%d> :%dtabn<CR>", i, i)
endfor

" 2011-12-15
" Vimwiki Configuration
let wiki_0 = {}
let wiki_0.path = '~/Dropbox/vimwiki/markup'
let wiki_0.path_html = '~/Dropbox/vimwiki/html'
let wiki_0.nested_syntaxes = {
			\ 'python': 'python',
			\ 'ansi-c': 'c',
			\ 'perl': 'perl',
			\ 'shell': 'sh',
			\ 'config': 'config',
			\ 'vimscript': 'vim',
			\ 'java': 'java' }
let wiki_0.auto_export = 0
let wiki_0.syntax = 'markdown'

let g:vimwiki_list = [ wiki_0 ]
let g:vimwiki_camel_case = 0
let g:vimwiki_folding = 0
let g:vimwiki_fold_lists = 0

" Fixup some vimwiki colors
hi link VimwikiNoExistsLink Comment

" 2012-12-20 Embedded syntax highlighting for markdown filetype via tpope's
" vim-markdown: https://github.com/tpope/vim-markdown
let g:markdown_fenced_languages = [ "python", "ruby", "sh", "ocaml", "c", "config", "java", "scheme" ]
let g:markdown_folding = 1

" 2012-12-20 I almost always am looking at bash code
let g:is_bash = 1

" 2011-02-11
" Emacs style command line editing slightly modified
" :help emacs-keys
" 2012-01-26
" Trying to figure the cmd line mappings for macvim
" Mappings for the gui are in gvimrc
" :he macmeta
" :he gui-extras
if !has("gui_running")
	" start of line
	cnoremap <C-a> <Home>
	" delete character under cursor
	cnoremap <C-d> <Del>
	" end of line
	cnoremap <C-e> <End>
	" back one word
	cnoremap <Esc>b	<S-Left>
	" forward one word
	cnoremap <Esc>f	<S-Right>
	" Delete one word to the right
	cnoremap <Esc>d	<S-Right><C-w>
	" delete one word to the left
	cnoremap <Esc><C-?> <C-w>
endif

" 2011-01-11
" Map / and ? while in visual mode to search for the highlighted text
vnoremap / y/<C-R>=escape('<C-R>"', '/\[]')<CR><CR>
" Escaping `?' is necessary with backward searching
vnoremap ? y?<C-R>=escape('<C-R>"', '?/\[]')<CR><CR>

" 2012-03-19
" Make * in visual mode just highlight all occurances instead of jumping to
" the next match.  Similar to the suggestions here:
" http://vim.wikia.com/wiki/Highlight_all_search_pattern_matches
vnoremap <silent> * y:let @/='<C-R>=escape('<C-R>"', '?/\[]')<CR>'<CR>:set hlsearch<CR>

" 2012-01-27
" Make copying to the clipboard easier
if has("clipboard")
	vmap <Leader>c "*y
endif

" 2011-04-15
" Map <Leader>n to toggle line numbers on and off.  I find this useful for when
" I need to copy and paste data out of a vim window
nmap <silent> <Leader>n :exec &number ? ":set nonu" : ":set nu"<CR>

" 2011-05-06
" Some ideas taken from
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
nnoremap ,<Space> :nohl<CR>
nnoremap <Tab> %

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

" 2011-12-13
" Control where ".netrwhist" gets written.  If this variable is not set then
" netrw tries to figure it out itself.
" See /opt/local/share/vim/vim73/autoload/netrw.vim
let g:netrw_home = $HOME . "/.netrwhist"

" 2012-07-24
" http://stackoverflow.com/questions/2586984/how-can-i-swap-positions-of-two-open-files-in-splits-in-vim
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction
nnoremap <silent> <leader>mw :call MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call DoWindowSwap()<CR>

" 2012-07-24
" Source a local vimrc to allow environment specific overrides
let g:local_rc_file = $HOME . "/.vimrc.local"
if filereadable(g:local_rc_file)
	exec printf("source %s", g:local_rc_file)
endif

" 2012-08-01
" Just noticed this "recentering" while using the ocaml plugin to view types,
" but its really annoying.
" http://vim.wikia.com/wiki/Avoid_scrolling_when_switch_buffers
" When switching buffers, preserve window view.
if v:version >= 700
    au BufLeave *.ml,*.mli let b:winview = winsaveview()
    au BufEnter *.ml,*.mli if exists('b:winview') | call winrestview(b:winview) | endif
endif

" 2012-08-16
" Keep find myself wanting a shortcut to echo the path of the current file
" while not in NERDTree.  Note that this conflicts with mappings I have setup
" for NERDTree buffers that basically do the same thing (except they are
" operating on a NERDTree node, not a buffer).  But thats fine because
" NERDTree will override this global mapping and it "just works".
nnoremap <silent> <leader>e :echo expand("%")<CR>
nnoremap <silent> <leader>E :echo expand("%:p")<CR>
