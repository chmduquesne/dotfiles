DOTFILES=$(wildcard .*)
LINKRULES=$(DOTFILES:.%=link.%)
UNLINKRULES=$(DOTFILES:.%=unlink.%)

all: install

link.:
link.%: .%
	@if test "x"$< != "x.." -a "x"$< != "x.hg"; then ln -s $(PWD)/$< $(HOME)/$<;echo "Creating link for $(HOME)/$<" ; fi

unlink.:
unlink.%: .%
	@if test "x"$< != "x.." -a "x"$< != "x.hg"; then rm -rf $(HOME)/$<;echo "Removing $(HOME)/$<" ; fi

install: $(LINKRULES)
	@echo "config installed!"

uninstall: $(UNLINKRULES)
	@echo "config uninstalled!"
