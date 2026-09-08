XML_REP='../read/xmlerr-0.08.3e/src/'
all: ppptc.byte
opt: ppptc.opt
ppptc.byte: ppptc.ml
	ocamlc -o $@ -I . strings.cmo -I $(XML_REP) xmlerr.cma $<
ppptc.opt: ppptc.ml
	ocamlopt -o $@ -I . strings.cmx -I $(XML_REP) xmlerr.cmxa $<
clean:
	$(RM) ppptc.byte
	$(RM) ppptc.opt
	$(RM) ppptc.cmi
	$(RM) ppptc.cmo
	$(RM) ppptc.cmx
	$(RM) ppptc.o
