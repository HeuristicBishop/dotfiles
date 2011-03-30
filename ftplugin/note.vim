imap <buffer> <Leader>t <C-r>=strftime("%Y-%m-%d")<CR>
imap <buffer> <Leader>T <C-r>=strftime("%Y-%m-%d %H:%M:%S")<CR>
imap <buffer> <Leader>b ▸ 

setlocal tw=80 sw=4 ts=4 softtabstop=4 formatoptions+=t formatoptions-=l
setlocal foldmethod=marker foldminlines=0 conceallevel=3
