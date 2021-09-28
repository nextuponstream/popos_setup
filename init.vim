filetype plugin indent on
syntax enable
set number
set cmdheight=2
set colorcolumn=80
" Use all of the available colors
" https://stackoverflow.com/a/64763678
set termguicolors
set encoding=UTF-8

call plug#begin('$HOME/.config/nvim/plugins')
" = Vim themes ===
Plug 'sainnhe/everforest'
Plug 'arcticicestudio/nord-vim'

Plug 'yggdroot/indentline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'
Plug 'shougo/echodoc'

"= LSP ===
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"= Coding ===
Plug 'fatih/vim-go'
Plug 'timonv/vim-cargo'
Plug 'vim-python/python-syntax' " python syntax highlighting

" Utility ===
" copy with cp in NORMAL MODE, paste with shift+insert in INSERT MODE
Plug 'christoomey/vim-system-copy' 
Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdtree'
Plug 'farmergreg/vim-lastplace'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'chun-yang/auto-pairs'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'mattesgroeger/vim-bookmarks'

" Always load the vim-devicons as the very last one.
Plug 'ryanoasis/vim-devicons'
call plug#end()

let g:coc_global_extensions = [
\ 'coc-json', 
\ 'coc-git',
\ 'coc-calc',
\ 'coc-css',
\ 'coc-eslint',
\ 'coc-go',
\ 'coc-html',
\ 'coc-json',
\ 'coc-metals',
\ 'coc-markdownlint',
\ 'coc-sh',
\ 'coc-sql',
\ 'coc-texlab',
\ 'coc-toml',
\ 'coc-yaml',
\ 'coc-rust-analyzer',
\ 'coc-jedi',
\ 'coc-pydocstring'
\ ]

" All configuration variables must be set before the colorscheme activation 
" command!
" https://www.nordtheme.com/docs/ports/vim/configuration
let g:nord_cursor_line_number_background = 1
let g:nord_uniform_status_lines = 0
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1

let g:everforest_cursor = 'green'
let g:everforest_diagnostic_text_highlight = 1
let g:everforest_diagnostic_line_highlight = 1
let g:everforest_diagnostic_virtual_text = 'colored'
let g:everforest_current_word = 'bold'
let g:everforest_lightline_disable_bold = 0
let g:everforest_better_performance = 1
let g:everforest_background = 'soft'
let g:everforest_enable_italic = 1
let g:everforest_disable_italic_comment = 0
let g:everforest_diagnostic_text_highlight = 1
let g:everforest_diagnostic_line_highlight = 1
let g:everforest_diagnostic_virtual_text = 'colored'
let g:everforest_current_word = 'bold'

" colorscheme sets colors_name
" https://bbs.archlinux.org/viewtopic.php?id=156454
colorscheme nord

if g:colors_name == 'nord'
	set background=dark
endif

if g:colors_name == 'everforest'
	set background=dark
	let g:airline_theme = 'everforest'
	let g:lightline = {'colorscheme' : 'everforest'}
endif

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = "popup"
highlight link EchoDocPopup Pmenu

let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" Create default mappings
let g:NERDCreateDefaultMappings = 1
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code 
" indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && 
\ exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Required for operations modifying multiple buffers like rename.
set hidden

" note that if you are using Plug mapping you should not use `noremap` mappings.
nmap <F5> <Plug>(lcn-menu)
" Or map each action separately
nmap <silent>K <Plug>(lcn-hover)
nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> <F2> <Plug>(lcn-rename)

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
let NERDTreeShowHidden=1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:rustfmt_autosave = 1

let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1
let g:bookmark_auto_close = 1
let g:bookmark_highlight_lines = 1
let g:bookmark_center = 1
" mi to create bookmark with annotation text
let g:bookmark_display_annotation = 1

" to display f-string correctly (remember first coding test? I forgot an 'f')
let g:python_highlight_all = 1

