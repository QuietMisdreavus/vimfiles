" custom statusline

set statusline=%!MisdreavusStatusLine()

if !exists('g:qf_disable_statusline')
    " disable the built-in quickfix list plugin from overriding the statusline
    let g:qf_disable_statusline = 1
endif

function! MisdreavusStatusLine()
    let s = ''

    let w = g:statusline_winid
    let b = winbufnr(w)

    let qftype = misdreavus#qftype(b)

    " Section 1: mode

    " mode flag
    let s .= '[ %{MisdreavusModeFlag()} ]'

    " Section 2: git status

    " color this section medium
    let s .= '%#Folded#'

    " don't print git status for qf/ll windows
    if qftype == ''
        let s .= '%{FugitiveStatusline()}'
    endif

    " Section 3: main (buffer name, qf/ll count)

    " color this section light
    let s .= '%#SignColumn#'

    if qftype == ''
        " #N: filename (placing a folding marker before the filename to truncate if necessary)
        let s .= ' #%n: %<%f'
    else
        " qf: command (placing a folding marker before the name)
        let s .= ' ' . qftype . ': %<' . misdreavus#qfname(b)
    endif

    " right-align everything after this point
    let s .= '%= '

    if qftype == ''
        " ll/qf counters, if the lists are loaded
        let s .= '%{MisdreavusLocationCounter()}'
        if g:statusline_winid == 1
            " only show the quickfix counter on window 1
            let s .= '%{MisdreavusQuickfixCounter()}'
        endif
    endif

    " Section 4: flags

    " color this section medium
    let s .= '%#Folded#'

    if qftype == ''
        " only show flags for normal windows
        let s .= '%{MisdreavusStatusFlags()}'
    endif

    " Section 5: cursor location

    " color this section dark (normal)
    let s .= '%*'

    " ln num/count col num
    let s .= 'ln %l/%L cl %c '

    " Section 6: warning flags

    " color this section red
    let s .= '%#Error#'

    if qftype == ''
        let s .= '%{MisdreavusTrailingSpaceCheck()}' " trailing whitespace
        let s .= '%{MisdreavusTabsSpacesCheck()}'    " mixed indent in same line
        let s .= '%{MisdreavusMixedIndentCheck()}'   " mixed indent across file
        let s .= '%{MisdreavusALEStatus()}'          " ALE warning/error counter
    endif

    " reset color at the end
    let s .= '%*'

    return s
endfunction

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

function! MisdreavusStatusFlags()
    if &previewwindow
        let pflag = '[p]'
    else
        let pflag = ''
    endif

    if !&modifiable
        let mflag = '[-]'
    elseif &modified
        let mflag = '[+]'
    else
        let mflag = ''
    endif

    if &filetype != ''
        let ftflag = '[' . &filetype . ']'
    else
        let ftflag = ''
    endif

    return pflag . mflag . ftflag
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

" ALE error count for statusline
function! MisdreavusALEStatus()
    if exists(":ALELint")
        let counts = ale#statusline#Count(bufnr())

        if counts.error != 0
            return '[e:' . counts.error . ']'
        endif
    endif

    return ''
endfunction

" clear statusline marker caches when idle or on write
augroup statusline
    autocmd!
    autocmd CursorHold,BufWritePost * unlet! b:misdreavus_trailing_space_mark
    autocmd CursorHold,BufWritePost * unlet! b:misdreavus_tabs_spaces_mark
    autocmd CursorHold,BufWritePost * unlet! b:misdreavus_mixed_indent_mark
augroup END
