
base:
	$(MAKE) -C src

clean:
	$(MAKE) -C src clean
	$(MAKE) -C addons clean

.PHONY: addons
addons:
	$(MAKE) -C addons
#
#	$(MAKE) -C addons/ utils
#	$(MAKE) -C addons/ tmpl
#	$(MAKE) -C addons/ utmpl
#	$(MAKE) -C addons/ tree
#	$(MAKE) -C addons/ report
#	$(MAKE) -C addons/ export
#

INSTALL_FILE = install -m 644
INSTALL_EXE = install -m 755

install:
	$(INSTALL_EXE) commands/htmluxtr /usr/local/bin
	$(INSTALL_EXE) commands/htmlxtr  /usr/local/bin
	$(INSTALL_EXE) commands/htmluxtr.1 /usr/local/share/man/man1
	$(INSTALL_EXE) commands/htmlxtr.1  /usr/local/share/man/man1

