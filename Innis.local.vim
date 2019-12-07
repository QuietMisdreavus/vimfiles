" Innis is a 16-inch MacBook Pro (2019)

if has("gui_running")
    " Add icons to the touch bar

    " Navigate between buffers
    nnoremenu icon=NSTouchBarGoBackTemplate TouchBar.PrevBuffer :bprevious<CR>
    nnoremenu icon=NSTouchBarRefreshTemplate TouchBar.ToggleBuffer <C-^>
    nnoremenu icon=NSTouchBarGoForwardTemplate TouchBar.NextBuffer :bnext<CR>

    " Trim trailing whitespace
    nnoremenu icon=NSTouchBarTextLeftAlignTemplate TouchBar.TrimWhiteSpace :%s/\s\+$<CR>:nohl<CR>

    " Clear hlsearch highlight
    nnoremenu icon=NSTouchBarTextStrikethroughTemplate TouchBar.ClearHilight :nohl<CR>
end
