# anti-aliasing
#AA =
AA = +A

all:
	sh make-pov.sh
	sh make-png.sh

%.pov: %.ml
	ocaml -I ../src povray.cma $< > $@

%.png: %.pov
	povray +W680 +H440 -V $(AA) +I$<

#	ls $@

#	display $@

clean:
	$(RM) *.png
clean2:
	$(RM) *.pov
clean3:
	$(RM) *.pov-state
