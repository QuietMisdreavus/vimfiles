" i like Source Code Pro
if has("gui_win32")
	set guifont=Source_Code_Pro:h12:cANSI
elseif has("osx")
    set guifont=SourceCodePro-Regular:h15
else
	set guifont=Source\ Code\ Pro\ 12
endif
" take out the toolbar, the one with icons and stuff
set guioptions-=T
