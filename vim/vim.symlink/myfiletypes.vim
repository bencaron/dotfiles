"
" *************************************************************
" Filename : $HOME/vim/myfiletypes.vim
" See the document by typing :help autocmd within vim session
" see also the doc at /usr/share/vim/doc/autocmd.txt
" This file will setup the autocommands for new filetypes
" using the existing syntax-filetypes.
" For example when you open foo.prc it will use syntax of plsql
" Basically does :set filetype=prc inside vim
" Add a line in $HOME/.gvimrc as below:
" so $HOME/vim/myfiletypes.vim
"
" *************************************************************
augroup filetype
         au!
         au! BufRead,BufNewFile *.php    set filetype=php
	 au! BufRead,BufNewFile *.py     set filetype=python
	 au! BufRead,BufNewFile *.pl 	 set filetype=perl
	 au! BufRead,BufNewFile *.pm     set filetype=perl
augroup END

