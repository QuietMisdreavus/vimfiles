" custom statusline

set statusline=
set statusline+=[\ %{mode('1')}\ ]                  " mode flag
set statusline+=%#Folded#                           " color next section medium
set statusline+=%(%{FugitiveStatusline()}%)         " git HEAD
set statusline+=%#SignColumn#                       " color next section light
set statusline+=\ #%n:\ %f                          " buf number: filename
set statusline+=%=                                  " right-align remaining items
set statusline+=%#Folded#                           " color next section medium
set statusline+=%h%w%m%y                            " flags: [help][preview][mod][filetype]
set statusline+=%*                                  " color next section dark (normal)
set statusline+=ln\ %l/%L\ cl\ %c\                  " line number, col number
set statusline+=%#Error#                            " color next section red
set statusline+=%{MisdreavusTrailingSpaceCheck()}   " trailing whitespace marker
set statusline+=%{MisdreavusTabsSpacesCheck()}      " mixed indent (in same line) marker
set statusline+=%{MisdreavusMixedIndentCheck()}     " mixed indent (across file) marker
set statusline+=%*                                  " reset statusline color at the end

" trailing whitespace check for statusline
function! MisdreavusTrailingSpaceCheck()
    if !exists("b:misdreavus_trailing_space_mark")
        let skip = (&filetype == 'help') && !&modifiable
        if !skip && search('\s\+$', 'nw') != 0
            let b:misdreavus_trailing_space_mark = '[tws]'
        else
            let b:misdreavus_trailing_space_mark = ''
        endif
    endif

    return b:misdreavus_trailing_space_mark
endfunction

" mixed indent (within the same line) check for statusline
function! MisdreavusTabsSpacesCheck()
    if !exists("b:misdreavus_tabs_spaces_mark")
        let skip = (&filetype == 'help') && !&modifiable
        let spaces_before_tabs = search('^ \+\t', 'nw') != 0

        if !skip && spaces_before_tabs
            let b:misdreavus_tabs_spaces_mark = '[t/s]'
        else
            let b:misdreavus_tabs_spaces_mark = ''
        endif
    endif

    return b:misdreavus_tabs_spaces_mark
endfunction

" mixed indent (across the whole file) check for statusline
function! MisdreavusMixedIndentCheck()
    if !exists("b:misdreavus_mixed_indent_mark")
        let skip = (&filetype == 'help') && !&modifiable
        let tabs = search('^ \+', 'nw') != 0
        let spaces = search('^\t\+', 'nw') != 0

        if !skip && tabs && spaces
            let b:misdreavus_mixed_indent_mark = '[mi]'
        else
            let b:misdreavus_mixed_indent_mark = ''
        endif
    endif

    return b:misdreavus_mixed_indent_mark
endfunction

" clear statusline marker caches when idle or on write
augroup statusline
    autocmd!
    autocmd CursorHold,BufWritePost * unlet! b:misdreavus_trailing_space_mark
    autocmd CursorHold,BufWritePost * unlet! b:misdreavus_tabs_spaces_mark
    autocmd CursorHold,BufWritePost * unlet! b:misdreavus_mixed_indent_mark
augroup END
