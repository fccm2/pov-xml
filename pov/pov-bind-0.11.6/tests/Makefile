# anti-aliasing
#AA = +A
AA =

%.pov: %.ml
	ocaml -I ../src povray.cma $< > $@

%.png: %.pov
	povray +W680 +H440 -V $(AA) +I$<

#	display $@

all:
	sh make-pov.sh
	sh make-png.sh

clean:
	$(RM) *.png
clean2:
	$(RM) *.pov

