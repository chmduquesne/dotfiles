chmd's dotfiles
===============

The deployment of these files is done via make commands:
* `make` or `make install` creates symbolic links `~/.file ->
  /abs/path/to/file` for every file of this repository (except this README
  and the Makefile).
* `make clean` or `make uninstall` erases '~/.file' for every file of this
  repository (except this README and the Makefile). Beware that no check
  is performed on whether the file is a symlink to a file in this
  directory.

Have fun reading this!
