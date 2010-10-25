# FILES TO LINK (MINUS ".", "..", ".hg")
DOTFILES=$(patsubst .,,$(patsubst ..,,$(patsubst .hg,,$(wildcard .*))))
LINK=$(DOTFILES:.%=link.%)
RM=$(DOTFILES:.%=unlink.%)

all: install

link.%: .%
	@echo "Creating the symbolic link $(HOME)/$<"
	@ln -s $(PWD)/$< $(HOME)/$<

unlink.%: .%
	@echo "Removing $(HOME)/$<"
	@rm -rf $(HOME)/$<

install: $(LINK)
	@echo "config installed!"

uninstall: $(RM)
	@echo "config uninstalled!"

clean: uninstall
