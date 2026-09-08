# anti-aliasing
#AA=
AA=+A
opt: xpov.opt
xpov.opt: xpov.ml
	ocamlopt -o $@ -I read/xmlerr-0.08.3e/src/ xmlerr.cmxa xpov.ml
ppp:
	$(MAKE) -C ppp
dep:
	$(MAKE) -C read/xmlerr-0.08.3e/src/ xmlerr.cmxa
#%.pov: %.ml
#	ocaml -I ../src povray.cma $< > $@
%.png: %.pov
	povray +W680 +H440 -V $(AA) +I$<
clean:
	$(MAKE) -C read/xmlerr-0.08.3e/src/ clean
	$(MAKE) -C ppp clean
	$(RM) xpov.opt
	$(RM) xpov.o
	$(RM) xpov.cmi
	$(RM) xpov.cmx
clean2:
	$(RM) *.pov-state
	$(RM) test1.pov
	$(RM) test2.pov
	$(RM) test3.pov
	$(RM) test3.png
