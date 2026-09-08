# anti-aliasing
#AA =
AA = +A

%.pov: %.ml
	ocaml -I ../../src povray.cma $< > $@

%.png: %.pov
	povray +W680 +H440 -V $(AA) +I$<
#	display $@

clean:
	$(RM) *.png
clean2:
	$(RM) *.pov

