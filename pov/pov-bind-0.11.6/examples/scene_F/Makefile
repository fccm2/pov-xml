# anti-aliasing
#AA =
AA = +A

all:
	sh make-pov.sh
	sh make-png.sh

%.png: %.pov
	povray +W680 +H440 -V $(AA) +I$<

#	display $@
#	mogrify -resize 50% $@

%.pov: %.ml
	ocaml -I ../../src povray.cma $< > $@

clean:
	$(RM) *.png
clean2:
	$(RM) *.pov

