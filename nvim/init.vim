" Specify a directory for plugins.
call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'NLKNguyen/papercolor-theme'

" Plug 'tpope/vim-fugitive'
" Plug 'airblade/vim-gitgutter'
" Plug 'easymotion/vim-easymotion'

Plug 'liuchengxu/vim-better-default'
"Plug 'guns/vim-sexp'
"Plug 'tpope/vim-sexp-mappings-for-regular-people'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'ncm2/float-preview.nvim'
"Plug 'jiangmiao/auto-pairs', { 'tag': 'v2.0.0' }
Plug 'w0rp/ale'
"Plug 'rakr/vim-one'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
Plug 'Olical/conjure', {'tag': 'v4.3.0'}
" Initialize plugin system.
call plug#end()

"""" Load better default and override some of the choices there
runtime! plugin/default.vim
set norelativenumber
set directory^=$HOME/.vimtmp//
set confirm
set swapfile
set updatecount=100
"""""""""""""""""""

"""" Load the theme
if (has("termguicolors"))
    set termguicolors
endif
let g:airline_theme='papercolor'
colorscheme PaperColor
"""""""""""""""""""
"
" deoplete and floating windows support
"let g:deoplete#enable_at_startup = 1
"call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})
"set completeopt-=preview
"let g:float_preview#docked = 0
"let g:float_preview#max_width = 100
"let g:float_preview#max_height = 50
""""""""""""""""""

" custom keybindings
"let mapleader = ","
" paredit slurp
"imap <buffer> <C-right> <C-o><Plug>(sexp_capture_next_element)
" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" annoying sql autocomplete -- shutup
let g:omni_sql_no_default_maps = 1

"call deoplete#custom#option('auto_complete_delay', 200)

"CLAP

"nnoremap <leader>* :Clap grep2 ++query=<cword><cr>
"nnoremap <leader>fg :Clap grep2<cr>
"nnoremap <leader>ff :Clap files --hidden<cr>
"nnoremap <leader>fb :Clap buffers<cr>
"nnoremap <leader>fw :Clap windows<cr>
"nnoremap <leader>fr :Clap history<cr>
"nnoremap <leader>fh :Clap command_history<cr>
"nnoremap <leader>fj :Clap jumps<cr>
"nnoremap <leader>fl :Clap blines<cr>
"nnoremap <leader>fL :Clap lines<cr>
"nnoremap <leader>ft :Clap filetypes<cr>
"nnoremap <leader>fm :Clap marks<cr>
""""""""""""""''"""""""""""""""


"""""" ALE asynchronous linter
" clojure linters
let g:ale_linters = {
      \ 'clojure': ['clj-kondo']
      \}
