# my_vimrc

This is nothing more than a particular configuration.
But the complete setup is from [amix/vimrc](https://github.com/amix/vimrc)

## My own configuration
I'm only adding the files in which I've edited / added some lines of configuration for my own purposes.

This modifications are basically some c / c++ flags for the [ale plugin](https://github.com/w0rp/ale) in order to check for syntax errors.

I also added the [cyberpunk](https://github.com/Roboron3042/Cyberpunk-Neon) with little modifications found in this repo, [dracula theme](https://github.com/dracula/vim), [monokai theme](https://github.com/sickill/vim-monokai), the [Archery theme](https://github.com/Badacadabra/vim-archery)

It also uses [vim-polyglot](https://github.com/sheerun/vim-polyglot) for better syntax highlighting.
- After amix installation, clone vim-polyglot to .vim_runtime/my_plugins

The files that i modified (after _amix/vimrc_ installation, obviously) are:
- .vim_runtime/vimrcs/plugins_config.vim
- .vim_runtime/vimrcs/extended.vim

The themes go under .vim_runtime/my_plugins

python.vim script goes under ~/.vim/after/syntax/python.vim
(offers a little more highlighting for python, after loading everything else)
