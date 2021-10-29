SRC := $(filter-out README.md Makefile,$(wildcard *))
DST := $(SRC:%=$(HOME)/.%)

all: install

# How a target in $HOME relates to a file in this directory
$(HOME)/.%: %
	@echo "Creating $@ -> $(PWD)/$<"
	@ln -s $(PWD)/$< $@

install: $(DST)

uninstall:
	rm -f $(DST)

clean: uninstall

.PHONY: all install uninstall clean
