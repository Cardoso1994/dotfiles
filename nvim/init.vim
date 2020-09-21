"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime


" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" sets vim's working directory to be the same as the file's directory
set autochdir

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')

" Declare the list of colorschemes.
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/sonokai'
Plug 'sainnhe/edge'
Plug 'sainnhe/gruvbox-material'
Plug 'franbach/miramare'

" Declare the list of plugins.
Plug 'preservim/nerdtree'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'frazrepo/vim-rainbow'
Plug 'tpope/vim-fugitive'
Plug 'chrisbra/csv.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'mboughaba/i3config.vim'
Plug 'jlanzarotta/bufexplorer'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set cursorline

" set number lines.
" When in NORMAL mode is absolute number. When in INSERT isrelative number.
set number
set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" Set lines to the cursor - when moving vertically using j/k
set so=3

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=5

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
 endif

" highlights column 80
set cc=80
highlight ColorColumn ctermbg=8

set cursorline
hi CursorLine term=bold cterm=bold guibg=IndianRed

" Add a bit extra margin to the left
" set foldcolumn=1

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
try
    set undodir=~/.config/nvim/temp_dirs/undodir
    set undofile
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLORS AND FONTS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Enable true color
if (has("termguicolors"))
  set termguicolors
endif

"""""""""""""""""""""""""""""""""""""""
" Colorscheme
"""""""""""""""""""""""""""""""""""""""
syntax enable

" onedark
" colorscheme onedark

" gruvbox
let g:gruvbox_italic=1
let g:gruvbox_bold=1
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_contrast_light="medium"

" gruvbox material
let g:gruvbox_material_palette = 'material'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_visual = 'reverse'
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_cursor = 'red'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_statusline_style = 'original'

" sonokai
" let g:sonokai_style="andromeda"
let g:sonokai_style="shusia"
" let g:sonokai_style="maia"
let g:sonokai_enable_italic=1
" colorscheme sonokai

" forest-night
" colorscheme forest-night

" edge
let g:edge_style="aura"

" allowing transparecy
" hi NonText ctermbg=none
" hi Normal guibg=NONE ctermbg=NONE

"""""""""""""""""""""""""""""""""""
" colorscheme depending time of day
"""""""""""""""""""""""""""""""""""
let hr= (strftime('%H'))
if hr > 8 && hr < 18
    set background=light
    let g:gruvbox_material_background = 'soft'
    colorscheme gruvbox-material
else
    set background=dark
    let g:gruvbox_material_background = 'hard'
    colorscheme gruvbox-material
    " colorscheme miramare
endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILES, BACKUPS AND UNDO
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TEXT, TAB AND INDENT
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Linebreak on 80 characters
set lbr
set tw=79

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

set backspace=indent,eol,start

" Charactere placeholder for tabulation [2 char]
let _tab_placeholder='»·'
" Charactere placeholder for space [1 char]
let _space_placeholder='·'
execute "set list listchars=tab:". _tab_placeholder .",trail:". _space_placeholder


""""""""""""""""""""""""""""""
" VISUAL MODE
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
vnoremap <Tab> >
vnoremap <S-Tab> <

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BUFFERS, WINDOWS AND TABS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
" map <space> /
map <C-space> /

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :b#<bar>bd#<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" vertical split of the same file with sync scrollbind
" i.e. spreads the file in two windows, extending visualization
set splitright splitbelow
nmap <Space>v :set noscrollbind<CR> :vs<CR> <C-l> L zt 3<C-e> :set scb<CR> <C-h> :set scb!<CR>

" resizing vsplits
nnoremap <silent> <M-H> :exe "vertical resize +2"<CR>
nnoremap <silent> <M-L> :exe "vertical resize -2"<CR>

" resizing splits
nnoremap <silent> <M-K> :exe "res +2"<CR>
nnoremap <silent> <M-J> :exe "res -2"<CR>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""
" => lightline
""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'gruvbox_material',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

function LightlineReload()
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction
""""""""""""""""
" => Nerd Tree
""""""""""""""""
nmap <silent><Space>. :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=25
" map <leader>nn :NERDTreeToggle<cr>
" map <leader>nb :NERDTreeFromBookmark<Space>
" map <leader>nf :NERDTreeFind<cr>

""""""""""""""""
" => Buffergator
""""""""""""""""
nmap <silent><Space>, :BuffergatorToggle<CR>
let g:buffergator_viewport_split_policy="B"
let g:buffergator_hsplit_size=5

""""""""""""""""
" => Git gutter
""""""""""""""""
let g:gitgutter_enabled=1
nnoremap <silent> <leader>d :GitGutterToggle<cr>
set updatetime=700

""""""""""""""""
" => Rainbow
""""""""""""""""
let g:rainbow_active = 1

""""""""""""""""
" => Coc
""""""""""""""""
source ~/.config/nvim/coc_config.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OWN MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
" nmap <M-j> mz:m+<cr>`z
" map <M-k> mz:m-2<cr>`z
" vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
" vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" vanilla vim mode of auto closing brackets and alike
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Coc-mappings overwrited by other plugins and mappings
" nmap <space>, :CocCommand explorer <CR>

" quick search
nmap <space><space> /

" redo mapping
nmap <space>u <C-r>

" out of insert mode
imap jk <ESC>

" copy/paste with system clipboard clipboard
vnoremap <C-c> "+y
map <C-p> "+p

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Python section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

" au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f # --- <esc>a
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Shell section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('$TMUX')
    if has('nvim')
        set termguicolors
    else
        set term=screen-256color
    endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Markdown
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let vim_markdown_folding_disabled = 1
