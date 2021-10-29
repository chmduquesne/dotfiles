Chmd's Dotfiles
===============

If you like this stuff, you should be interested in knowing about the way
I deploy it. I use a Makefile:
* `make` or `make install`:
  Creates symbolic links `~/.file -> /abs/path/to/file` for every file of
  this repository (except this README and the Makefile).
* `make clean` or `make uninstall`:
  Erases '~/.file' for every file of this repository (except this README
  and the Makefile). Beware that no check is performed on whether the
  file is a symlink to a file in this directory.

Have fun reading this!
