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
" Plug 'TimUntersberger/neogit'
" unix stuff: Delete, Mkdir
Plug 'tpope/vim-eunuch'

" fuzzy finders
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim'
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

""""" completion

set completeopt=menuone,noinsert,noselect
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
inoremap <silent><expr> <TAB>  pumvisible() ? "\<C-n>" :  <SID>check_back_space() ? "\<TAB>" :  "\<C-x>\<C-o>"
inoremap <silent><expr> <S-TAB>  pumvisible() ? "\<C-p>" :  "\<S-TAB>"


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
set wildcharm=<tab> " so that it can be used below
nnoremap <Leader>fe :e %:h<tab>
nnoremap <Leader>ff :GFiles<cr>
nnoremap <Leader>fb :Buffers<cr>
nnoremap <Leader>fg :Rg<cr>

"""

" annoying sql autocomplete -- shutup
let g:omni_sql_no_default_maps = 1
" don't barf on very long indent forms
let g:clojure_maxlines = 1000

"""""" ALE asynchronous linter
let g:ale_linters = {
      \ 'clojure': ['clj-kondo']
      \}

" show the matched syntax
nnoremap <C-z> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") ."> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" restart lsp
function! LSPRestart()
    lua vim.lsp.stop_client(vim.lsp.get_active_clients())
    edit
endfunction
command LSPRestart call LSPRestart()

"
"jump off to lua
lua << EOF
  require'init'
EOF
