" Specify a directory for plugins.
call plug#begin(stdpath('data') . '/plugged')
" languages
Plug 'jparise/vim-graphql'
Plug 'clojure-vim/clojure.vim'
Plug 'bakpakin/fennel.vim'
Plug 'Olical/aniseed' 
Plug 'Olical/conjure' 
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
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-live-grep-raw.nvim'
Plug 'fannheyward/telescope-coc.nvim'

" above is buggy for now
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

Plug 'NLKNguyen/papercolor-theme'

Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vim-better-default'

Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'ncm2/float-preview.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Neovim 0.5 stuff
""Plug 'neovim/nvim-lspconfig'
""Plug 'glepnir/lspsaga.nvim' " TODO see if this is nicer, then replace the builtin ones
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'nvim-treesitter/playground'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'pwntester/octo.nvim'

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
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
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


let g:conjure#mapping#doc_word = "<localleader>K"
let g:conjure#client#clojure#nrepl#test#runner = "kaocha"
let g:conjure#highlight#enabled = v:true

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

" edit next to the file
nnoremap <Leader>fe :e %:h<tab>

" FZF
" set rtp+=/opt/homebrew/opt/fzf
" set wildcharm=<tab> " so that it can be used below
" nnoremap <Leader>fe :e %:h<tab>
" nnoremap <Leader>ff :GFiles<cr>
" nnoremap <Leader>fb :Buffers<cr>
" nnoremap <Leader>fg :Rg<cr>
"

" telescope
"
"
"

nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fg <cmd>lua require('telescope').extensions.live_grep_raw.live_grep_raw()<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fr <cmd>Telescope coc references<cr>
nnoremap <leader>fs <cmd>Telescope coc document_symbols<cr>

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
" function! LSPLog()
"     lua vim.cmd(":e"..vim.lsp.get_log_path())
" endfunction
" command LSPLog call LSPLog()
" function! LSPDev()
"     lua vim.lsp.stop_client(vim.lsp.get_active_clients())
"     lua require('lspconfig').clojure_lsp_dev.autostart()
" endfunction
" command LSPDev call LSPDev()

"
"
function FugitiveToggle() abort
  try
    exe filter(getwininfo(), "get(v:val['variables'], 'fugitive_status', v:false) != v:false")[0].winnr .. "wincmd c"
  catch /E684/
    vertical Git
    vertical resize 80
  endtry
endfunction
nnoremap <Leader>g <cmd>call FugitiveToggle()<CR>

source ~/.config/nvim/coc_config.vim

" jump off to lua
lua << EOF
  require'init'
EOF
