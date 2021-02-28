" Specify a directory for plugins.
call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'

Plug 'NLKNguyen/papercolor-theme'

Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vim-better-default'
Plug 'machakann/vim-highlightedyank'
Plug 'guns/vim-sexp'
Plug 'pechorin/any-jump.vim'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ncm2/float-preview.nvim'
Plug 'jiangmiao/auto-pairs', { 'tag': 'v2.0.0' }
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Olical/conjure', {'tag': 'v4.15.0'}
Plug 'jparise/vim-graphql'
" Plug 'gberenfield/cljfold.vim'
Plug 'clojure-vim/clojure.vim'
Plug 'kassio/neoterm'
Plug 'editorconfig/editorconfig-vim'
Plug 'bakpakin/fennel.vim'
Plug 'Olical/aniseed', { 'tag': 'v3.11.0' }
" Neovim 0.5 stuff
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
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
let g:clojure_foldwords = "def,defn,defnc,defmacro,defmethod,defschema,defprotocol,defrecord,comment"
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
" don't barf on very long indent forms
let g:clojure_maxlines = 1000

"""""" ALE asynchronous linter
" clojure linters
let g:ale_linters = {
      \ 'clojure': ['clj-kondo']
      \}

"""""" Treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"clojure"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = false ,     -- false will disable the whole extension
    --enable = { "clojure" },     -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
  },
}
EOF

"""""" LSP
lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    -- TODO change the colors
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "clojure_lsp" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF
