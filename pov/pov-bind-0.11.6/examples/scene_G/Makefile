# anti-aliasing
#AA =
AA = +A

all:
	sh make-pov.sh
	sh make-png.sh
all2:
	sh make-pov.2.sh
	sh make-png.2.sh

%.pov: %.ml
	ocaml -I ../../src povray.cma $< > $@

%.png: %.pov
	povray +W680 +H440 -V $(AA) +I$<

#	display $@

clean:
	$(RM) *.png
clean2:
	$(RM) *.pov
clean3:
	$(RM) *.pov-state

clean0: clean clean2 clean3
