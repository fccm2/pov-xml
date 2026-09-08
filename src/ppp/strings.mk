all:
	ocamlc -c strings.mli
	ocamlc -c strings.ml
opt:
	ocamlopt -c strings.mli
	ocamlopt -c strings.ml
clean:
	$(RM) strings.cmi
	$(RM) strings.cmo
	$(RM) strings.cmx
	$(RM) strings.o
