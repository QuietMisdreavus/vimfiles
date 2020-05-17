" custom tabline
" shows buffers, even when tabs are in use
" if a help window is visible, shows it on the right side of the bar

" always show tabline, even when only one tab is active
set showtabline=2

function! MisdreavusIncludeInLeftTabs(b)
    if !bufexists(a:b)
        return v:false
    endif

    if !buflisted(a:b)
        return v:false
    endif

    if a:b == bufnr() || a:b == bufnr('#')
        return v:false
    endif

    if getbufvar(a:b, '&filetype') == 'qf'
        return v:false
    endif

    if bufwinnr(a:b)->getwinvar('&previewwindow', v:false)
        return v:false
    endif

    return v:true
endfunction

function! MisdreavusIncludeInRightTabs(b)
    if !bufexists(a:b)
        return v:false
    endif

    if a:b == bufnr() || a:b == bufnr('#')
        return v:false
    endif

    if buflisted(a:b)
        return getbufvar(a:b, '&filetype') == 'qf' || bufwinnr(a:b)->getwinvar('&previewwindow', v:false)
    else
        let visbufs = tabpagebuflist()
        return index(visbufs, a:b) != -1
    endif
endfunction

function! MisdreavusTabSegment(b, fill = '')
    let segment = ''
    let curbuf = bufnr()
    let altbuf = bufnr('#')
    let visbufs = tabpagebuflist()

    if a:b == curbuf
        let segment .= '%#TabLineSel#'
    elseif index(visbufs, a:b) != -1
        let segment .= '%#SignColumn#'
    endif

    " number buffers, but signify the alternate buffer with ^N instead of #N
    let hash = '#'
    if a:b == altbuf
        let hash = '^'
    endif

    if !buflisted(a:b) && getbufvar(a:b, '&filetype') == 'help'
        " help files are not listed, but i want to be able to see my current buffer in the tab
        " bar regardless. i don't want to print the full path tho, so just grab the filename
        let name = bufname(a:b)->fnamemodify(':t')
    elseif getbufvar(a:b, '&filetype') == 'qf'
        let name = misdreavus#qfname(a:b)
    else
        let name = bufname(a:b)
        if name != ''
            let name = fnamemodify(name, ':~:.')->pathshorten()
        endif
    endif

    if name == ''
        let name = '[no name]'
    endif

    let segment .= ' ' . a:fill

    if bufwinnr(a:b)->getwinvar('&previewwindow', v:false)
        let segment .= '[p]'
    else
        let segment .= hash . a:b . ':'
    endif

    let segment .= ' ' . name . ' '

    if getbufvar(a:b, '&mod')
        let segment .= '[+] '
    endif

    if a:b == curbuf || index(visbufs, a:b) != -1
        let segment .= '%#TabLine#'
    endif

    return segment
endfunction

function! MisdreavusTabline()
    let s = ''
    let suf = ''

    if tabpagenr('$') > 1
        " tabs are being used, display the tab number
        let s .= '%#TODO#'
        let s .= ' tab #' . tabpagenr()
        let s .= ' %999X[X]%X ' " close button
    endif

    let curbuf = bufnr()
    let altbuf = bufnr('#')
    let visbufs = tabpagebuflist()
    let firstbuf = v:true

    let s .= '%#TabLine#'

    let s .= MisdreavusTabSegment(curbuf)

    if altbuf != -1 && buflisted(altbuf) && altbuf != curbuf
        let s .= '|'
        let s .= MisdreavusTabSegment(altbuf)
    endif

    for b in range(1, bufnr('$'))
        if MisdreavusIncludeInLeftTabs(b)
            if firstbuf
                let firstbuf = v:false
                let s .= '||'
                let fill = '%<'
            else
                let s .= '|'
                let fill = ''
            endif

            let s .= MisdreavusTabSegment(b, fill)
        endif
    endfor

    " color remainder light
    let s .= '%#Folded#'

    let firstbuf = v:true

    for b in range(1, bufnr('$'))
        if MisdreavusIncludeInRightTabs(b)
            if firstbuf
                let firstbuf = v:false
                let s .= '%='
            else
                let s .= '|'
            endif

            let s .= MisdreavusTabSegment(b)
        endif
    endfor

    return s
endfunction

set tabline=%!MisdreavusTabline()
