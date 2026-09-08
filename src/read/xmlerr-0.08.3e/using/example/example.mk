test:
	cat example.html | \
	  ocaml -I ../../src/ \
	        -I ../../addons/ \
	   ../../commands/htmluxtr  example.utmpl  example.tmpl
