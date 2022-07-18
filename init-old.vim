" {{{1 Vim auto save
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup save
  au!
  au FocusLost * wall
augroup END
"set nohidden
set nobackup
set noswapfile
set nowritebackup
set autoread
set autowrite
set autowriteall
