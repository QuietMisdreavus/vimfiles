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

Memo to self: When installing fresh, racer also has some setup. Amazingly,
I was able to build it with the "beta" rustc in the Arch repo (as of
4/28/2015) in contrast with the warning displayed in racer's README.

    # install rustc and cargo first
	cd bundle/racer
	cargo build --release

Racer also wants a local copy of the Rust source, so clone [that repo][rust-src]
somewhere and set `$RUST_SRC_DIR` to the `src` subdirectory there.
Make sure to `git checkout` which branch matched your rustc, in my case
`beta`.
