" ~/.vimrc

" Encoding & baseline
set encoding=utf-8              " UTF-8 everywhere.
set nocompatible                " Disable vi-compat (implicit when .vimrc exists).
set backspace=indent,eol,start  " Backspace across line breaks and auto-indent.

" XDG: keep viminfo out of $HOME (dirs auto-created below).
" MUST come after 'nocompatible' — setting that option resets 'viminfo' to its
" default, which would silently wipe this line if it ran earlier.
set viminfo+='1000,n~/.local/state/vim/viminfo

" Display
syntax on            " Syntax highlighting.
set colorcolumn=80 | highlight ColorColumn ctermbg=darkgray
set number           " Line numbers.
set cursorline       " Highlight the cursor's line.
set linebreak        " Wrap at word boundaries, not mid-word.
set scrolloff=8      " Keep 8 lines of context above/below cursor.
set sidescrolloff=8  " Keep 8 columns of context left/right.
set showmatch        " Flash the matching bracket when you type one.
set lazyredraw       " Skip redraws during macros — faster bulk edits.
set ttimeoutlen=50   " Short Esc wait so mode switches feel snappy.

" Indentation
set autoindent     " Copy indent from the current line.
set tabstop=4      " Tab displays as 4 spaces.
set shiftwidth=4   " >> and << indent by 4 spaces.
set softtabstop=4  " Tab in insert mode inserts 4 spaces.
set expandtab      " Use spaces, not tab characters.

" Search
set hlsearch    " Highlight all matches.
set incsearch   " Jump to matches as you type.
set ignorecase  " Case-insensitive by default...
set smartcase   " ...unless the pattern has a capital letter.

" Windows & splits
set splitbelow  " Horizontal splits open below.
set splitright  " Vertical splits open to the right.

" Command-line completion
set wildmenu                    " Visual completion menu on the : command line.
set wildmode=longest:full,full  " First Tab: longest match. Next Tabs: cycle.

" Mouse
set mouse=a  " Mouse in all modes.

" Persistent undo, swap, backup
" Trailing // encodes the full path in the filename — prevents clashes between
" same-named files in different dirs. undofile keeps history across sessions.
set undofile
set undodir=~/.local/state/vim/undo//
set directory=~/.local/state/vim/swap//
set backupdir=~/.local/state/vim/backup//

for s:dir in ['undo', 'swap', 'backup']  " Auto-create state dirs on first run.
  let s:path = expand('~/.local/state/vim/' . s:dir)
  if !isdirectory(s:path) | call mkdir(s:path, 'p') | endif
endfor

" Trim trailing whitespace on save.
function! s:TrimTrailingWhitespace()
  let l:view = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

augroup TrimWhitespace
  autocmd!
  autocmd BufWritePre * call s:TrimTrailingWhitespace()
augroup END

" Key mappings
let mapleader = "\<Space>"  " Space as leader.

nnoremap <C-h> <C-w>h  " Left split.
nnoremap <C-j> <C-w>j  " Lower split.
nnoremap <C-k> <C-w>k  " Upper split.
nnoremap <C-l> <C-w>l  " Right split.

nnoremap <silent> <leader>/ :nohlsearch<CR>  " Clear search highlight.
nnoremap <leader>w :w<CR>  " Save.
nnoremap <leader>q :q<CR>  " Quit.
nnoremap <leader>x :x<CR>  " Save + quit (only writes if modified; cf. ZZ).

" Machine-specific overrides (not tracked in dotfiles).
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
