" Specify a directory for plugins.
call plug#begin(stdpath('data') . '/plugged')
" languages
Plug 'jparise/vim-graphql'
Plug 'clojure-vim/clojure.vim'
Plug 'bakpakin/fennel.vim'
Plug 'Olical/aniseed', { 'tag': 'v3.11.0' }
Plug 'Olical/conjure', {'tag': 'v4.15.0'}
Plug 'editorconfig/editorconfig-vim'

" vim improvements
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs', { 'tag': 'v2.0.0' }
Plug 'kevinhwang91/nvim-bqf' " quickfix window, investigate

" git
Plug 'tpope/vim-fugitive'
Plug 'TimUntersberger/neogit'
" unix stuff: Delete, Mkdir
Plug 'tpope/vim-eunuch'

" fuzzy finders
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" above is buggy for now
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'NLKNguyen/papercolor-theme'

Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vim-better-default'

Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'ncm2/float-preview.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Neovim 0.5 stuff
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim' " TODO see if this is nicer, then replace the builtin ones
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'


" linter
Plug 'w0rp/ale'
" completion
Plug 'hrsh7th/nvim-compe'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
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
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END


" Nobody cares about position in the file, we have line numbers
let g:airline_section_z = ''
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_filetype_overrides = {
\ }

""""""""
let g:clojure_foldwords = "def,defn,defnc,defmacro,defmethod,defschema,defprotocol,defrecord,comment"
au Filetype clojure let b:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"'}

"""" Load the theme
if (has("termguicolors"))
    set termguicolors
endif
let g:airline_theme='papercolor'
colorscheme PaperColor

"nvim-compe
lua << EOF
  require'conf_compe'
EOF
inoremap <silent><expr> <TAB>  pumvisible() ? "\<C-n>" :  <SID>check_back_space() ? "\<TAB>" :  compe#complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
" inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })



"""""""""""""""""
"
" deoplete and floating windows support
"let g:deoplete#enable_at_startup = 1
"call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})
"" don't automatically show completions, wait for TAB to be pressed
"call deoplete#custom#option('auto_complete', v:false)
"set completeopt-=preview
""let g:float_preview#docked = 0
""let g:float_preview#max_width = 100
""let g:float_preview#max_height = 50
"" <TAB>: completion in popup menus
"inoremap <silent><expr> <TAB>  pumvisible() ? "\<C-n>" :  <SID>check_back_space() ? "\<TAB>" :  deoplete#manual_complete()
"function! s:check_back_space() abort "{{{
"    let col = col('.') - 1
"    return !col || getline('.')[col - 1]  =~ '\s'
"endfunction"}}}
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
set rtp+=/opt/homebrew/opt/fzf
nnoremap <Leader>ff :GFiles<cr>
nnoremap <Leader>fb :Buffers<cr>
nnoremap <Leader>fg :Rg<cr>

"""

" annoying sql autocomplete -- shutup
let g:omni_sql_no_default_maps = 1
" don't barf on very long indent forms
let g:clojure_maxlines = 1000

"""""" ALE asynchronous linter
" clojure linters
let g:ale_linters = {
      \ 'clojure': ['clj-kondo']
      \}

" show the matched syntax
nnoremap <C-z> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") ."> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"" jump off to lua
lua << EOF
  require'init'
EOF
