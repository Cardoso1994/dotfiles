set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry

" set number lines. When in NORMAL mode is absolute number. When in INSERT
" isrelative number.
set number
set relativenumber
autocmd InsertLeave * :set relativenumber
autocmd InsertEnter * :set norelativenumber

" sets vim's working directory to be the same as the file's directory
set autochdir

set backspace=indent,eol,start

" for indents that are 4 space characters
" as for this answer https://stackoverflow.com/a/1878983
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

" adding mouse support
set mouse=a

" setting auto indent
set ai

" highlights column 80
set cc=80
highlight ColorColumn ctermbg=8

set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40

" allowing transparecy
hi Normal guibg=NONE ctermbg=NONE
