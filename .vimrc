"Deant's vimrc config file

"(based on gudemare's original vimrc)

"General configuration
	set nocompatible						"Abandon last century
	set hidden								"Hides buffers instead of closing them
	filetype plugin indent on				"Loads type-specific plugins / indent styles
	set autoread							"Re-read if the file is modified elsewhere
	set wildmenu							"Useful menu for navigation
	set wildignore=*.o,*~,*.swp,*.bak
	set backspace=indent,eol,start			"Make backspace erase everything
	set binary								"For editing binary files
	set visualbell							"Don't beep
	set noerrorbells						"Don't beep
	set title								"Change terminal's title
	set history=1000						"Remember more commands and search history
	set undolevels=1000						"Use many muchos levels of undo

"General behaviour
	set splitbelow							"Open split below
	set splitright							"Open split right
	set ignorecase							"Ignore case on search
	set hlsearch							"Highlight search results
	set incsearch							"Search as you type
	set wrap								"Wrap text
	set nostartofline						"Moves cursor to first non-blank character for some cmds
	set gdefault							"Search/replace 'globally' (on a line) by default
"	set gcr=a:blinkon0						"Disable cursor blink
	set scrolloff=5							"Start scrolling X lines away from margins

"Folding behaviour
	set foldenable							"Enable folding
	set foldmethod=indent					"Fold by indentation
	set foldlevel=10						"Max foldlevel

	"<space> to fold / unfold
		nnoremap <space> za
		vnoremap <space> za

"Mappings to easily toggle fold levels
	nnoremap z0 :set foldlevel=0<CR>
	nnoremap z1 :set foldlevel=1<CR>
	nnoremap z2 :set foldlevel=2<CR>
	nnoremap z3 :set foldlevel=3<CR>
	nnoremap z4 :set foldlevel=4<CR>
	nnoremap z5 :set foldlevel=5<CR>

"Jump to matching pairs easily, with Tab
"	nnoremap <Tab> %
"	vnoremap <Tab> %

"Indentation
	set tabstop=4							"A tab is four spaces
	set shiftwidth=4						"Autoindent spaces
	set autoindent							"Indent automatically
	set smartindent							"Indent intelligently

"Visual shifting (does not exit Visual mode)
	vnoremap < <gv
	vnoremap > >gv

"Remaps
	set pastetoggle=<F2>					"Toggle pastemode
"	inoremap jk <ESC>

	"Navigate quicker
		map <C-H> <C-W>h<C-W><ESC>
		map <C-J> <C-W>j<C-W><ESC>
		map <C-K> <C-W>k<C-W><ESC>
		map <C-L> <C-W>l<C-W><ESC>

	"Use HJKL to move in normal mode !
		nmap <UP> :echo "nope !"<CR>
		nmap <LEFT> :echo "nope !"<CR>
		nmap <RIGHT> :echo "nope !"<CR>
		nmap <DOWN> :echo "nope !"<CR>

	"Useful on some keyboards
		nnoremap ; :
		vnoremap ; :

"Stop highlighting searches
	nnoremap ,<space> :nohlsearch<CR>
	vnoremap ,<space> :nohlsearch<CR>

"Toggle list characters
	nnoremap ,l :set list!<CR>
	vnoremap ,l :set list!<CR>

"Appearance
	set term=xterm-color
	set t_Co=256
	
	"color elfold
		set background=dark
		set showmode
		set showcmd
		set number
		syntax on
	
	"set cursorline
		set showmatch
		set listchars=tab:▸\ ,trail:#,eol:↩,nbsp:_,extends:⥤,precedes:⥢
		set nolist
		set linespace=0						"No extra spaces between rows

"Cursor goes back where it was
	augroup resCur
		autocmd!
		autocmd BufReadPost * call setpos(".", getpos("'\""))
	augroup END

"For searching files in a project
	set path+=**

"Remap j and k to act as expected when used on long, wrapped, lines

	nnoremap ,ev :vsp ~/.vimrc<CR>
	nnoremap ,ez :vsp ~/.zshrc<CR>

"Resource .vimrc quicker
	nmap ,sv :source ~/.vimrc<CR>

"Write and quit files quicker
	nmap ,w :w<CR>
	nmap ,q :q<CR>

"Turn persistent undo on
	try
		set undodir=~/.vim_runtimetemp_dirs/undodir
		set undofile
	catch
	endtry

"Toggle between number and relativenumber
	function! ToggleNumber()
		if(&relativenumber == 1)
			set norelativenumber
			set number
		else
			set relativenumber
		endif
	endfunc
	nnoremap ,t :call ToggleNumber()<CR>
	vnoremap ,t :call ToggleNumber()<CR>


"Session Handling
	" Creates a session
	function! MakeSession()
		let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
		if (filewritable(b:sessiondir) != 2)
			exe 'silent !mkdir -p ' b:sessiondir
			redraw!
		endif
		let b:sessionfile = b:sessiondir . '/session.vim'
		exe "mksession! " . b:sessionfile
	endfunction

" Updates a session, BUT ONLY IF IT ALREADY EXISTS
	function! UpdateSession()
		let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
		let b:sessionfile = b:sessiondir . "/session.vim"
		if (filereadable(b:sessionfile))
			exe "mksession! " . b:sessionfile
			echo "updating session"
		endif
	endfunction

" Loads a session if it exists
	function! LoadSession()
		if argc() == 0
			let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
			let b:sessionfile = b:sessiondir . "/session.vim"
			if (filereadable(b:sessionfile))
				exe 'source ' b:sessionfil
			else
				echo "No session loaded."
			endif
		else
			let b:sessionfile = ""
			let b:sessiondir = ""
		endif
	endfunction

	au VimEnter * nested :call LoadSession()
	au VimLeave * :call UpdateSession()
	map ,m :call MakeSession()<CR>
