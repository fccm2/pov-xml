alias ocaml='ocaml -I +unix unix.cma -I +str str.cma'
ocaml -I ../src xmlerr.cma -I ../addons xmlerr_tree.cma test_tree.ml ./tree.html
