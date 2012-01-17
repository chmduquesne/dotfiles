FILES=$(filter-out . .. .hg .hgignore README Makefile,$(wildcard *))
LINKRULES=$(FILES:%=link.%)
REMOVERULES=$(FILES:%=rm.%)

all: install

link.%: %
	@echo "Creating the symbolic link $(HOME)/.$<"
	@ln -s $(PWD)/$< $(HOME)/.$<

rm.%: %
	@echo "Removing $(HOME)/.$<"
	@rm -rf $(HOME)/.$<

install: $(LINKRULES)
	@echo "config installed!"

uninstall: $(REMOVERULES)
	@echo "config uninstalled!"

clean: uninstall
