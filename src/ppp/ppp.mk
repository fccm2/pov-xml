PREFIX='/usr/local'
INSTALL_PREFIX=$(PREFIX)'/bin'
MANUAL_PREFIX=$(PREFIX)'/share/man/man1'

opt: pppst.opt ppptc.opt

%.opt: %.mk %.ml
	$(MAKE) -f $< opt

pppst.opt: pppst.ml
	$(MAKE) -f pppst.mk opt
ppptc.opt: ppptc.ml
	$(MAKE) -f ppptc.mk opt

install: pppst.opt ppptc.opt
	sudo mkdir -p $(INSTALL_PREFIX)
	sudo cp pppst.opt $(INSTALL_PREFIX)/pppst
	sudo cp ppptc.opt $(INSTALL_PREFIX)/ppptc
	:
	sudo mkdir -p $(MANUAL_PREFIX)
	sudo cp pppst.1 $(MANUAL_PREFIX)/
	sudo cp ppptc.1 $(MANUAL_PREFIX)/
