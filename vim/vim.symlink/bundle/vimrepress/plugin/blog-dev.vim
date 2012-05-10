"#######################################################################
" Copyright (C) 2007 Adrien Friggeri.
"
" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2, or (at your option)
" any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program; if not, write to the Free Software Foundation,
" Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  
" 
" Maintainer:	Adrien Friggeri <adrien@friggeri.net>
"               Pigeond <http://pigeond.net/blog/>
"               Justin Sattery <justin.slattery@fzysqr.com>
"               Lenin Lee <lenin.lee@gmail.com>
"               Conner McDaniel <connermcd@gmail.com>
"
"     Forked:   Preston M.[BOYPT] <pentie@gmail.com>
"
" URL:		http://www.friggeri.net/projets/vimblog/
"           http://pigeond.net/blog/2009/05/07/vimpress-again/
"           http://pigeond.net/git/?p=vimpress.git
"           http://apt-blog.net
"           http://fzysqr.com/
"
" VimRepress 
"    - A mod of a mod of a mod of Vimpress.   
"    - A vim plugin fot writting your wordpress blog.
"
" Version:	2.1.5
"
" Configure: Add blog configure into your .vimrc (password optional)
"
" let VIMPRESS=[{'username':'user',
"               \'password':'pass',
"               \'blog_url':'http://your-first-blog.com/'
"               \},
"               \{'username':'user',
"               \'blog_url':'http://your-second-blog.com/'
"               \}]
"
"#######################################################################

if !has("python")
    finish
endif

function! CompSave(ArgLead, CmdLine, CursorPos)
  return "publish\ndraft\n"
endfunction

function! CompPrev(ArgLead, CmdLine, CursorPos)
  return "local\npublish\ndraft\n"
endfunction

function! CompEditType(ArgLead, CmdLine, CursorPos)
  return "post\npage\n"
endfunction

fun! Completable(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    " find matching items
    let res = []
    for m in split(s:completable,"|")
      if m =~ '^' . a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfun

command! -nargs=* -complete=custom,CompEditType BlogList exec('py blog_list(<f-args>)')
command! -nargs=? -complete=custom,CompEditType BlogNew exec('py blog_new(<f-args>)')
command! -nargs=? -complete=custom,CompSave BlogSave exec('py blog_save(<f-args>)')
command! -nargs=? -complete=custom,CompPrev BlogPreview exec('py blog_preview(<f-args>)')
command! -nargs=1 -complete=file BlogUpload exec('py blog_upload_media(<f-args>)')
command! -nargs=1 BlogOpen exec('py blog_guess_open(<f-args>)')
command! -nargs=? BlogSwitch exec('py blog_config_switch(<f-args>)')
command! -nargs=? BlogCode exec('py blog_append_code(<f-args>)')

python import os; execfile(os.path.expanduser('~/.vim/plugin/blog.py'))
