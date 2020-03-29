set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry

set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry

set encoding=utf-8
set t_Co=256


set cursorline

set tabstop=4 softtabstop=0 shiftwidth=4 smarttab
set backspace=indent,eol,start

" set number lines. When in NORMAL mode is absolute number. When in INSERT
" isrelative number.
set number
set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" sets vim's working directory to be the same as the file's directory
set autochdir

set backspace=indent,eol,start
" for indents that are 4 space characters
" as for this answer https://stackoverflow.com/a/1878983
" set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab
set tabstop=4 softtabstop=4 shiftwidth=4
" Charactere placeholder for tabulation [2 char]
let _tab_placeholder='»·'
" Charactere placeholder for space [1 char]
let _space_placeholder='·'
execute "set list listchars=tab:". _tab_placeholder .",trail:". _space_placeholder

" adding mouse support
set mouse=a

" setting auto indent
set ai

" highlights column 80
set cc=80
highlight ColorColumn ctermbg=8

set cursorline
hi CursorLine term=bold cterm=bold guibg=IndianRed

" allowing transparecy
hi NonText ctermbg=none
hi Normal guibg=NONE ctermbg=NONE

" NERDTree config
nmap <Space>. :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

" Buffergator config
nmap <Space>, :BuffergatorToggle<CR>
let g:buffergator_viewport_split_policy="B"
let g:buffergator_hsplit_size=5
