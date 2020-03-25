" custom statusline

set statusline=
set statusline+=[\ %{MisdreavusModeFlag()}\ ]       " mode flag
set statusline+=%#Folded#                           " color next section medium
set statusline+=%(%{FugitiveStatusline()}%)         " git HEAD
set statusline+=%#SignColumn#                       " color next section light
set statusline+=\ #%n:\ %f                          " buf number: filename
set statusline+=%=                                  " right-align remaining items
set statusline+=%{MisdreavusLocationCounter()}      " location list: (index/count)
set statusline+=%{MisdreavusQuickfixCounter()}      " quickfix list: (index/count)
set statusline+=%#Folded#                           " color next section medium
set statusline+=%h%w%m%y                            " flags: [help][preview][mod][filetype]
set statusline+=%*                                  " color next section dark (normal)
set statusline+=ln\ %l/%L\ cl\ %c\                  " line number, col number
set statusline+=%#Error#                            " color next section red
set statusline+=%{MisdreavusTrailingSpaceCheck()}   " trailing whitespace marker
set statusline+=%{MisdreavusTabsSpacesCheck()}      " mixed indent (in same line) marker
set statusline+=%{MisdreavusMixedIndentCheck()}     " mixed indent (across file) marker
set statusline+=%*                                  " reset statusline color at the end

" mode string for statusline
function! MisdreavusModeFlag()
    let mode_map = {
          \ 'c'  : 'comm',
          \ 'i'  : 'ins',
          \ 'ic' : 'comp',
          \ 'ix' : 'comp',
          \ 'n'  : 'norm',
          \ 'ni' : 'norm*',
          \ 'no' : 'oper',
          \ 'R'  : 'repl',
          \ 'Rv' : 'v repl',
          \ 's'  : 'sel',
          \ 'S'  : 'sel-l',
          \ '' : 'sel-b',
          \ 't'  : 'term',
          \ 'v'  : 'vis',
          \ 'V'  : 'vis-l',
          \ '' : 'vis-b',
          \ }

    let mode = mode('1')

    if has_key(mode_map, mode)
        return mode_map[mode]
    endif

    for k in keys(mode_map)
        if match(mode, k) == 0
            return mode_map[k]
        endif
    endfor

    " for unknown modes just return the flag unaltered
    return mode
endfunction

" location list index/count for statusline
function! MisdreavusLocationCounter()
    let loc = getloclist(winnr(), {'idx':0, 'size':0})

    if loc.size == 0
        return ''
    else
        return 'll: (' . loc.idx . '/' . loc.size . ') '
    endif
endfunction

" quickfix list index/count for statusline
function! MisdreavusQuickfixCounter()
    let qf = getqflist({'idx':0, 'size':0})

    if qf.size == 0
        return ''
    else
        return 'qf: (' . qf.idx . '/' . qf.size . ') '
    endif
endfunction

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
