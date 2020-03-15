" Innis is a 16-inch MacBook Pro (2019)

if has("gui_running")
    " Add icons to the touch bar

    " Navigate between buffers
    anoremenu icon=NSTouchBarGoBackTemplate TouchBar.PrevBuffer :bprevious<CR>
    anoremenu icon=NSTouchBarRefreshTemplate TouchBar.ToggleBuffer <C-^>
    anoremenu icon=NSTouchBarGoForwardTemplate TouchBar.NextBuffer :bnext<CR>

    " Trim trailing whitespace
    anoremenu icon=NSTouchBarTextLeftAlignTemplate TouchBar.TrimWhiteSpace :%s/\s\+$<CR>:nohl<CR>

    " Clear hlsearch highlight
    anoremenu icon=NSTouchBarTextStrikethroughTemplate TouchBar.ClearHilight :nohl<CR>
end
