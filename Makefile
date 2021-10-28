FILES=$(filter-out . .. .hg .hgignore README Makefile,$(wildcard *))
DOTFILES=$(FILES:%=$(HOME)/.%)

all: install

$(HOME)/.%: %
	@echo "Creating the symbolic link $@"
	@ln -s $(PWD)/$< $@

install: $(DOTFILES)

uninstall:
	rm -f $(DOTFILES)

clean: uninstall

.PHONY: all install uninstall clean
