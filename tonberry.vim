" tonberry is my server, and thus is (practically) always accessed over SSH

if $COLORTERM == 'truecolor' || $COLORTERM == '24bit'
    " if the terminal that's connected reports that it can show 24-bit color, then enable it
    if &t_8f == ''
        let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
    endif
    if &t_8b == ''
        let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
    endif
    set termguicolors
endif
