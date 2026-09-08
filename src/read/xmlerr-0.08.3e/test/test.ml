module Xe = Xmlerr

let print_debug xs =
  let print_attrs attrs =
    List.iter (fun (key, value) ->
      Printf.printf "\n ['%s' '%s']" key value) attrs
  in
  let print_x = function
  | Xe.Tag (name, attrs) ->
      print_string "(Tag ";
      print_string name;
      print_attrs attrs;
      print_string ")\n";
  | Xe.ETag (name) ->
      print_string "(/Tag ";
      print_string name;
      print_string ")\n";
  | Xe.Data d ->
      print_string "  \"";
      print_string d;
      print_string "\"";
      print_char '\n';
  | Xe.Comm c ->
      print_string "  ;; ";
      print_string c;
      print_string "\n";
  in
  List.iter print_x xs;
  print_newline ()

let () =
  let s = Xmlerr.ic_input (open_in Sys.argv.(1)) in
  let xe = Xmlerr.strip_space (Xmlerr.parse s) in
  print_debug xe;
;;
