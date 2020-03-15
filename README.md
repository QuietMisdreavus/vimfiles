# QuietMisdreavus's vim files

I wanted to stash my vim setup somewhere, so I figured I'd get off my ass and figure out how git
works and centralize my vimrc at the same time.

I've set up the plugins i use as submodules in various directories under the `pack` folder. This
uses Vim 8.x's native package management to load them up. I was previously using [pathogen] to load
up plugins, so it was fairly painless to migrate to native packages. There are separate package
bundles for syntax definitions, color schemes, and plugins that offer extra functionality.

[pathogen]: https://github.com/tpope/vim-pathogen

*Note to self:* To add a new plugin to the `bundle` directory, don't use `git clone`, use `git
submodule add` instead. That makes sure git properly sees the new folder as a submodule instead of a
bunch of new files.

*When pulling down new submodules:* `git submodule update --init --recursive`

*Also:* `git submodule update --remote --merge` updates all the submodules in a repository, in one
command, it's fantastic.
