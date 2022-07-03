" EwsgitOS © 2022 Ewsgit
" Licensed under the MIT license: https://ewsgit.mit-license.org

set tabstop=4 softtabstop=4 shiftwidth=4
set expandtab
set smartindent
set relativenumber
set nu
set exrc
set nohlsearch
set hidden
set ignorecase
set nowrap
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=4
set signcolumn=yes
set mouse=a

call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'windwp/nvim-ts-autotag'
Plug 'c0r73x/neotags.lua'
" autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" file formatter
Plug 'prettier/vim-prettier'
" statusbar
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'commit': '4542402e34568eb607059e3ff6a3594aaca850fd'}

" color theme
Plug 'gruvbox-community/gruvbox'

call plug#end()

colorscheme gruvbox
highlight Normal guibg=none

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" use the spacebar as the leader key
let mapleader=" "
" grep the current repo
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>s :w<CR>
nnoremap <leader>w :w<CR>

function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
  call timer_start(100, 'ShowDocIfNoDiagnostic')
endfunction

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" hover info
augroup EWSGIT
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
    autocmd CursorHold * :call <SID>show_hover_doc()
    autocmd CursorHoldI * :call <SID>show_hover_doc()
augroup END
