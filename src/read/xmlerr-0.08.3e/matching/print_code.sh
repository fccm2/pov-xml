cd `dirname $0`

#XMLERR_DIR="$HOME/xmlerr"
XMLERR_DIR="../src"

ocaml -I +unix unix.cma \
  -I $XMLERR_DIR xmlerr.cma \
  print_code.ml $*

#XMLERR_DIR="+xmlerr"
