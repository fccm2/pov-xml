(** xmlerr, xml parsing with error *)
(* Copyright (C) 2011 Florent Monnier, Some rights reserved
  Issues: https://github.com/fccm/ocaml-xmlerr/issues

 Permission to use, copy, modify, distribute, and sell this software and
 its documentation for any purpose is hereby granted without fee.
 No representations are made about the suitability of this software for any
 purpose.  It is provided "AS IS" without express or implied warranty.
*)

let usage () =
  Printf.eprintf "\
    usage:\n %s ( -file <filename> | - <input-from-stdin> )\n%!"
    Sys.argv.(0)

let print_from_file fn =
  let xs = Xmlerr.parse_file fn in
  let xs = Xmlerr.strip_space xs in
  Xmlerr.print_html xs

let print_from_ic ic =
  let xs = Xmlerr.parse_ic ic in
  let xs = Xmlerr.strip_space xs in
  Xmlerr.print_html xs

let () =
  let args = List.tl (Array.to_list Sys.argv) in
  match args with
  | ["-file"; filename] -> print_from_file filename
  | ["-"] -> print_from_ic stdin
  | _ -> usage ()
