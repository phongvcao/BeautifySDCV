"=============================================================================
" FILE: autoload/stardict.vim
" AUTHOR: Phong V. Cao <phongvcao@phongvcao.com>
" License: MIT license {{{
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be included
" in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
" OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
" IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
" CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
" TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
" SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================


let s:stardict_buf_count = 0


function! stardict#StarDict(...)
    let l:expl=stardict#GetDefinition(a:000)

    if (&filetype != 'stardict')
        let l:cur_winnr = winnr()
        execute "normal! \<C-W>b"
        if (winnr() > 1)
            exe "normal! " . l:cur_winnr . "\<C-W>w"
            while 1
                if (&filetype == 'stardict')
                    break
                endif
                exe "normal! \<C-W>w"
                if (l:cur_winnr ==# winnr())
                    break
                endif
            endwhile
        endif
        if &filetype != 'stardict'
            if (g:stardict_split_horizontal ==# 1)
                silent! execute g:stardict_split_size . 'sp vim-stardict' . s:stardict_buf_count
            else
                silent! execute g:stardict_split_size . 'vsp vim-stardict' . s:stardict_buf_count
            endif
        endif
    endif

    silent exec "1,$d"
    setlocal buftype=nofile bufhidden=hide noswapfile readonly filetype=stardict
    setlocal number relativenumber nobuflisted
    silent! 1s/^/\=l:expl/
    1
endfunction


function! stardict#GetDefinition(words)
    if empty(a:words)
        let args = ''
    else
        let escaped_words = map(copy(a:words), 'shellescape(v:val)')
        let args = join(escaped_words, ' ')
    endif
    return split(system('sdcv -n ' . args), '\n')
endfunction

function! stardict#SourceSyntaxFile()
    let l:syntax_file_0 = '~/.vim/bundle/stardict/syntax/stardict.vim'
    let l:syntax_file_1 = '~/.vim/plugin/syntax/stardict.vim'
    let l:syntax_file_2 = '/usr/share/vim/vimfiles/syntax/stardict.vim'

    if filereadable(expand(l:syntax_file_0))
        silent! execute 'source ' . l:syntax_file_0
        let g:stardict_syntax_file = l:syntax_file_0

    elseif filereadable(expand(l:syntax_file_1))
        silent! execute 'source ' . l:syntax_file_1
        let g:stardict_syntax_file = l:syntax_file_1

    elseif filereadable(expand(l:syntax_file_2))
        silent! execute 'source ' . l:syntax_file_2
        let g:stardict_syntax_file = l:syntax_file_2
    endif
endfunction
