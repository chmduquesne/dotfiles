# FILES TO LINK (MINUS ".", "..", ".hg")
DOTFILES=$(filter-out . .. .hg,$(wildcard .*))

# RULE NAMES
LINK=$(DOTFILES:.%=link.%)
RM=$(DOTFILES:.%=rm.%)

all: install

link.%: .%
	@echo "Creating the symbolic link $(HOME)/$<"
	@ln -s $(PWD)/$< $(HOME)/$<

rm.%: .%
	@echo "Removing $(HOME)/$<"
	@rm -rf $(HOME)/$<

install: $(LINK)
	@echo "config installed!"

uninstall: $(RM)
	@echo "config uninstalled!"

clean: uninstall
