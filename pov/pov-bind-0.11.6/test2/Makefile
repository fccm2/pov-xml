# anti-aliasing
#AA =
AA = +A

.PRECIOUS: %.pov
%.pov: %.ml
	ocaml -I ../src povray.cma -I ../utils shapes.cma $< > $@

%.png: %.pov
	povray +W680 +H440 -V $(AA) +I$<

clean:
	$(RM) t*.png
	$(RM) t*.pov
