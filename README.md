chmd's dotfiles
===============

This repository uses make commands for deployment.

```bash
make
```
or
```bash
make install
```
will create a symbolic link `~/.file -> file` for every file of this
repository.


```bash
make clean
```
or
```
make uninstall
```
will remove all occurrences of `~/.file` where `file` exists in this
repository. Beware that this removal is unconditional to whether the file
is a symbolic link or not.


Have fun reading this!
