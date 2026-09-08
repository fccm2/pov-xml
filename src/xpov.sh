#make -C read/xmlerr-0.08.3e/src/ xmlerr.cma
ocaml -I read/xmlerr-0.08.3e/src/ xmlerr.cma xpov.ml test1.xml
