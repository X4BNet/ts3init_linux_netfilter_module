KVER ?= $(shell uname -r)

.PHONY: all clean install userspace-install dkms-install dkms-uninstall

all:
	$(MAKE) -C src;
	$(MAKE) -C src -f Makefile.xtables;
	$(MAKE) -C test;

clean:
	$(MAKE) -C src clean;
	$(MAKE) -C src -f Makefile.xtables clean;
	$(MAKE) -C test clean;

install: dkms-install userspace-install

userspace-install:
	$(MAKE) -C src -f Makefile.xtables;
	$(MAKE) -C src -f Makefile.xtables install;

dkms-install:
	KVERSION="$(KVER)" ./install-dkms.sh --install

dkms-uninstall:
	./install-dkms.sh --uninstall
