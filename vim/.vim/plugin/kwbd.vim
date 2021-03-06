" 2011-12-27
" Ripped from:
" http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window, but
" modified to suit my needs

"here is a more exotic version of my original Kwbd script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:DeleteBuffer(cmd)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:ChangeOtherWindows()
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
	let s:buflistedLeft = s:buflistedLeft + 1
        else
	if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
	    let s:bufFinalJump = l:i
	endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute printf("%s! %d", a:cmd, s:kwbdBufNum)
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
endfunction

function s:ChangeOtherWindows()
    if(bufnr("%") == s:kwbdBufNum)
        let prevbufvar = bufnr("#")
        if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
            b #
        else
            bn
        endif
    endif
endfunction

command! Kwbd call <SID>DeleteBuffer('bd')
command! Kwbw call <SID>DeleteBuffer('bw')
"nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>

" Create a mapping (e.g. in your .vimrc) like this:
"nmap <C-W>! <Plug>Kwbd
