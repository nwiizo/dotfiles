set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set number
<<<<<<< HEAD
=======
set cursorline
set cursorcolumn
set virtualedit=onemore
set smartindent
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest
nnoremap j gj
nnoremap k gk
set title
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set list listchars=tab:\▸\-
set expandtab
set tabstop=4
set shiftwidth=4
set showmatch 
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
set noautoindent
set smartindent 
set viminfo='20,\"1000
syntax enable
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

>>>>>>> refs/remotes/origin/master
let g:elite_mode = 1                     " Set arrow-keys to window resize
let g:global_symbol_padding = '  '       " Padding after nerd symbols
let g:tabline_plugin_enable = 0          " Disable built-in tabline
let g:enable_universal_quit_mapping = 0  " Disable normal 'q' mapping
let g:disable_mappings = 0               " Disable config/mappings.vim
