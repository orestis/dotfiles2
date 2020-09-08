" Specify a directory for plugins.
call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

Plug 'NLKNguyen/papercolor-theme'

Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vim-better-default'
Plug 'machakann/vim-highlightedyank'
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
let g:vim_better_default_key_mapping = 0
let g:vim_better_default_backup_on = 1
runtime! plugin/default.vim
set norelativenumber
set directory^=$HOME/.vimtmp//
set confirm
set updatecount=100
set autoread
set foldmethod=syntax
autocmd FocusGained * checktime
"""""""""""""""""""


" Nobody cares about position in the file, we have line numbers
let g:airline_section_z = ''
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_filetype_overrides = {
\ }

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
autocmd FileType clojure imap <buffer> <C-right> <C-o><Plug>(sexp_capture_next_element)
autocmd FileType clojure imap <buffer> <C-left> <C-o><Plug>(sexp_emit_tail_element)

autocmd FileType clojure nmap <buffer> <C-right> <Plug>(sexp_capture_next_element)
autocmd FileType clojure nmap <buffer> <C-left> <Plug>(sexp_emit_tail_element)

" change tabs with cmd-shift-[ / ], mac-style
noremap <S-D-{> <Cmd>tabp<cr>
noremap <S-D-}> <Cmd>tabn<cr>
" yank til end of line
nnoremap Y y$
" Bash like
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-h> <BS>
inoremap <C-d> <Delete>
" Command mode shortcut
cnoremap <C-h> <BS>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Delete>

" FZF
nnoremap <Leader>ff :GFiles<cr>
nnoremap <Leader>fb :Buffers<cr>
nnoremap <Leader>fg :Rg<cr>

"""

" annoying sql autocomplete -- shutup
let g:omni_sql_no_default_maps = 1

"""""" ALE asynchronous linter
" clojure linters
let g:ale_linters = {
      \ 'clojure': ['clj-kondo']
      \}
