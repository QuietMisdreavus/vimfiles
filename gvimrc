if exists("g:misdreavus_font_override")
    let &guifont=g:misdreavus_font_override
elseif has("gui_win32")
    set guifont=Source_Code_Pro:h12:cANSI
elseif has("osx")
    set guifont=SourceCodePro-Regular:h15
else
    set guifont=Source\ Code\ Pro\ 12
endif

" take out the toolbar, the one with icons and stuff
set guioptions-=T

" never use the GUI tabline
set guioptions-=e
