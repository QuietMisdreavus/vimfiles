# icesoldier's vim files

I wanted to stash my vim setup somewhere, so I figured I'd get off
my ass and figure out how git works and centralize my vimrc at the
same time.

I've set up the plugins I use as submodules under the `bundle` folder.
I use [pathogen][] to load everything up, so throwing all the links in
there seemed like a good idea. The stuff in the `autoload` folder is
pathogen itself, and an override for vim-airline's Zenburn theme to
make the status bar more readable on my terrible displays.

[pathogen]: https://github.com/tpope/vim-pathogen
