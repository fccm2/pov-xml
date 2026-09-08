OCAMLOPT = ocamlopt
OCAMLC = ocamlc
DIR = xmlerr
OCAMLDIR = $(shell $(OCAMLC) -where)
DESTDIR = $(OCAMLDIR)/$(DIR)
DOCDIR = /usr/local/share/doc
DESTDOC = $(DOCDIR)/$(DIR)

all: utils tmpl utmpl tree reporte exporte

# Utils

utils: \
  xmlerr_utils.cmi \
  xmlerr_utils.cmo \
  xmlerr_utils.cma \
  xmlerr_utils.cmx \
  xmlerr_utils.cmxa

# Templating

tmpl: \
  xmlerr_tmpl.cmi \
  xmlerr_tmpl.cmo \
  xmlerr_tmpl.cma \
  xmlerr_tmpl.cmx \
  xmlerr_tmpl.cmxa

# Un-templating

utmpl: \
  xmlerr_utmpl.cmi \
  xmlerr_utmpl.cmo \
  xmlerr_utmpl.cma \
  xmlerr_utmpl.cmx \
  xmlerr_utmpl.cmxa

# Tree

tree: \
  xmlerr_tree.cmi \
  xmlerr_tree.cmo \
  xmlerr_tree.cma \
  xmlerr_tree.cmx \
  xmlerr_tree.cmxa

# Report

reporte: \
  xmlerr_report.cmi \
  xmlerr_report.cmo \
  xmlerr_report.cma \
  xmlerr_report.cmx \
  xmlerr_report.cmxa

# Export

exporte: \
  xmlerr_export.cmi \
  xmlerr_export.cmo \
  xmlerr_export.cma \
  xmlerr_export.cmx \
  xmlerr_export.cmxa

# Generic

xmlerr_%.cmi: xmlerr_%.mli
	$(OCAMLC) -c -I ../src $<

xmlerr_%.cmo: xmlerr_%.ml xmlerr_%.cmi
	$(OCAMLC) -c -I ../src $<

xmlerr_%.cmx: xmlerr_%.ml xmlerr_%.cmi
	$(OCAMLOPT) -c -I ../src $<

xmlerr_%.cma: xmlerr_%.cmo
	$(OCAMLC) -a -I ../src -o $@ $<

xmlerr_%.cmxa: xmlerr_%.cmx
	$(OCAMLOPT) -a -I ../src -o $@ $<

# Test

HTML_INPUT = ../web/index.html
TMP_FILE = log.tmp

$(TMP_FILE): ../test/test.ml $(HTML_INPUT)
	ocaml -I ../src xmlerr.cmo $^ > $@

.PHONY: test
test: $(TMP_FILE)
	cat $<

INSTALL_DIR = install -d -m 755
INSTALL_FILE = install -m 644

RMDIR = rmdir
MKDIR = mkdir -p

.PHONY: uninstall
uninstall:
	$(RM) $(DESTDIR)/*
	$(RM) $(DESTDOC)/*
	$(RMDIR) $(DESTDIR)
	$(RMDIR) $(DESTDOC)


DESTDOC2 = $(DESTDOC)/addons

.PHONY: install
install:
	$(INSTALL_DIR) $(DESTDIR)
	$(INSTALL_DIR) $(DESTDOC2)
	$(INSTALL_FILE) xmlerr_*.mli $(DESTDIR)/
	$(INSTALL_FILE) xmlerr_*.cmi $(DESTDIR)/
	$(INSTALL_FILE) xmlerr_*.cmo  $(DESTDIR)/ || :
	$(INSTALL_FILE) xmlerr_*.cma  $(DESTDIR)/ || :
	$(INSTALL_FILE) xmlerr_*.cmx  $(DESTDIR)/ || :
	$(INSTALL_FILE) xmlerr_*.cmxa $(DESTDIR)/ || :
	$(INSTALL_FILE) readme.md $(DESTDOC2)/addons

OCAMLDOC = ocamldoc

.PHONY: man
man:
	$(MKDIR) man
	$(OCAMLDOC) -html -d man \
	 -I ../src ../src/xmlerr.mli \
	  xmlerr_tmpl.mli \
	  xmlerr_utmpl.mli \
	  xmlerr_utils.mli \
	  xmlerr_report.mli \
	  xmlerr_tree.mli \
	  #End

.PHONY: clean
clean:
	$(RM) *.[oa] *.so *.dll *.cm[ioax] *.cmx[as] *.exe *.opt *.byte

