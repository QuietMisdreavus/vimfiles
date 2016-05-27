# icesoldier's vim files

I wanted to stash my vim setup somewhere, so I figured I'd get off my ass and figure out how git
works and centralize my vimrc at the same time.

I've set up the plugins I use as submodules under the `bundle` folder.  I use [pathogen][] to load
everything up, so throwing all the links in there seemed like a good idea. The stuff in the
`autoload` folder is pathogen itself, and an override for vim-airline's Zenburn theme to make the
status bar more readable on my terrible displays.

[pathogen]: https://github.com/tpope/vim-pathogen

*Note to self:* To add a new plugin to the `bundle` directory, don't use `git clone`, use `git
submodule add` instead. That makes sure git properly sees the new folder as a submodule instead of a
bunch of new files.
