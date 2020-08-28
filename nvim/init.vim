" Specify a directory for plugins.
call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'NLKNguyen/papercolor-theme'

Plug 'liuchengxu/vim-better-default'
Plug 'guns/vim-sexp'
Plug 'pechorin/any-jump.vim'
"Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ncm2/float-preview.nvim'
Plug 'jiangmiao/auto-pairs', { 'tag': 'v2.0.0' }
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Olical/conjure', {'tag': 'v4.3.0'}
Plug 'kassio/neoterm'
Plug 'editorconfig/editorconfig-vim'
" Initialize plugin system.
call plug#end()

"""" Load better default and override some of the choices there
runtime! plugin/default.vim
set norelativenumber
set directory^=$HOME/.vimtmp//
set confirm
set swapfile
set updatecount=100
set autoread
autocmd FocusGained * checktime
"""""""""""""""""""

""""""""
au Filetype clojure let b:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"'}

"""" Load the theme
if (has("termguicolors"))
    set termguicolors
endif
let g:airline_theme='papercolor'
colorscheme PaperColor
"""""""""""""""""""
"
" deoplete and floating windows support
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})
" don't automatically show completions, wait for TAB to be pressed
call deoplete#custom#option('auto_complete', v:false)
set completeopt-=preview
"let g:float_preview#docked = 0
"let g:float_preview#max_width = 100
"let g:float_preview#max_height = 50
" <TAB>: completion in popup menus
inoremap <silent><expr> <TAB>  pumvisible() ? "\<C-n>" :  <SID>check_back_space() ? "\<TAB>" :  deoplete#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
""""""""""""""""""

""""""""" custom keybindings
" paredit slurp
imap <buffer> <C-s> <C-o><Plug>(sexp_capture_next_element)
" change tabs with cmd-shift-[ / ], mac-style
noremap <S-D-{> <Cmd>tabp<cr>
noremap <S-D-}> <Cmd>tabn<cr>

nnoremap <Leader>ff :Files
nnoremap <Leader>fb :Buffers
nnoremap <Leader>fg :Rg

"""

" annoying sql autocomplete -- shutup
let g:omni_sql_no_default_maps = 1

"""""" ALE asynchronous linter
" clojure linters
let g:ale_linters = {
      \ 'clojure': ['clj-kondo']
      \}
