mod: povray.cma
opt: povray.cmxa

povray.cmi: povray.mli
	ocamlc -c $<

povray.cmo: povray.ml povray.cmi
	ocamlc -c $<

povray.cma: povray.cmi povray.cmo
	ocamlc -a -o $@ povray.cmo

povray.cmxa: povray.cmi povray.cmx
	ocamlopt -a -o $@ povray.cmx

povray.cmx: povray.ml povray.cmi
	ocamlopt -c $<

doc: povray.cmi
	mkdir -p doc
	ocamldoc -html -d doc povray.mli

clean:
	$(RM) povray.cmx[as]
	$(RM) povray.cm[ioxa]
	$(RM) povray.[oa]
