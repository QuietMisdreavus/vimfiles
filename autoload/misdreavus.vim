" misdreavus.vim: helper utilities for my scripts
" (c) 2020 QuietMisdreavus

function misdreavus#qftype(b = bufnr())
    if has_key(s:loclists, a:b)
        " quickfix list buffers and location list buffers have the same filetype, so check our
        " loclists map first
        return 'll'
    elseif getbufvar(a:b, '&filetype') == 'qf'
        " if the ft is 'qf' but it wasn't in loclists, then it's a quickfix list
        return 'qf'
    else
        " otherwise, it's not a quickfix window, so return an empty string
        return ''
    endif
endfunction

function misdreavus#qfname(b = bufnr())
    if has_key(s:loclists, a:b)
        " if the buffer is saved in our location lists cache, use that title
        return s:loclists[a:b]
    elseif getbufvar(a:b, '&filetype') == 'qf'
        " otherwise, pull it from the qflist title
        return getqflist({'qfbufnr': a:b, 'title': 0}).title
    else
        " if we weren't given a qf/ll buffer, return a blank string
        return ''
    endif
endfunction

" keep a cache of the active location list buffers and their titles

function! s:refresh_loclists()
    let loclists = {}
    for win in range(1, winnr('$'))
        let loc = getloclist(win, {'qfbufnr':0, 'title':0})
        if loc.qfbufnr != 0 && !has_key(loclists, loc.qfbufnr)
            let loclists[loc.qfbufnr] = loc.title
        endif
    endfor

    let s:loclists = loclists
endfunction

let s:loclists = {}
call s:refresh_loclists()

" refresh the location list cache when buffers are changed
augroup loclists
    autocmd!
    autocmd BufAdd * call <sid>refresh_loclists()
    autocmd BufDelete * call <sid>refresh_loclists()
augroup END
