XML_REP='../read/xmlerr-0.08.3e/src/'
all: pppst.byte
opt: pppst.opt
pppst.byte: pppst.ml
	ocamlc -o $@ -I . strings.cmo -I $(XML_REP) xmlerr.cma $<
pppst.opt: pppst.ml
	ocamlopt -o $@ -I . strings.cmx -I $(XML_REP) xmlerr.cmxa $<
clean:
	$(RM) pppst.byte
	$(RM) pppst.opt
	$(RM) pppst.cmi
	$(RM) pppst.cmo
	$(RM) pppst.cmx
	$(RM) pppst.o
