# QuietMisdreavus's vim files

This originally started as an experiment to learn git, but as i used it in more and more places, it
grew into a place to play around with vim script. I've tried to keep my configuration heavily
commented so people (including "future me") could learn more about what each things does.

Some of my configuration grew enough that i broke it into separate "plugins". These are all located
in the `pack/misdreavus/start` directory, and should be considered part of my config. The
submodule links are a bit wonky (to make it so i'm not forced to use an ssh key where i don't want
to) so here are the actual links to my personal plugins:

* [ghostline][]: a custom status-bar/tab-bar
* [mru][]: a plugin to track which buffers i've used most recently in a given window
* [session][]: a small wrapper around the built-in `:mksession` command

[ghostline]: https://github.com/QuietMisdreavus/ghostline
[mru]: https://github.com/QuietMisdreavus/misdreavus-mru
[session]: https://github.com/QuietMisdreavus/misdreavus-session

I've set up the plugins i use as submodules in various directories under the `pack` folder. This
uses the Vim 8.x native package management to load them up. I was previously using [pathogen] to
load up plugins, so it was fairly painless to migrate to native packages. There are separate package
bundles for syntax definitions, color schemes, and plugins that offer extra functionality.

[pathogen]: https://github.com/tpope/vim-pathogen

*Note to self:* To add a new plugin to a `pack/**/start` directory, don't use `git clone`, use `git
submodule add` instead. That makes sure git properly sees the new folder as a submodule instead of a
bunch of new files.

*When pulling down new submodules:* `git submodule update --init --recursive`

*Also:* `git submodule update --remote --checkout` updates all the submodules in a repository, in one
command. If you add a submodule directory afterward, it'll just update that submodule.
