lib: shapes.cma
opt: shapes.cmxa

shapes.cmi: shapes.mli
	ocamlc -c $<

shapes.cmo: shapes.ml shapes.cmi
	ocamlc -c $<

shapes.cma: shapes.cmi shapes.cmo
	ocamlc -a -o $@ shapes.cmo

shapes.cmxa: shapes.cmi shapes.cmx
	ocamlopt -a -o $@ shapes.cmx

doc: shapes.cmi
	mkdir -p doc
	ocamldoc -html -d doc shapes.mli

clean:
	$(RM) *.cm[ioxa]

