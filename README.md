chmd's dotfiles
===============

Deployment
----------

Files of this repository are installed with make.

```bash
make
```
or
```bash
make install
```
will create a symbolic link `~/.file -> /absolute/path/to/file` for every
file at the root of this repository.


```bash
make clean
```
or
```
make uninstall
```
will remove all occurrences of `~/.file` where `file` exists in this
repository.

Gotchas
-------

* If you move this repository after installing the files, you will break the
symbolic links, so you will need to `clean` and re`install`.
* Uninstallation is unconditional to whether the file
is a symbolic link or not.

Conclusion
----------

Have fun reading this!
