module Xe = Xmlerr
open Xe

let input_line_opt ic =
  try Some (input_line ic)
  with _ -> None

let read_file fn =
  let ic = open_in fn in
  let rec aux acc =
    match input_line_opt ic with
    | Some line -> aux (line::acc)
    | None -> close_in ic; (List.rev acc)
  in
  let lines = aux [] in
  let s = String.concat "\n" lines in
  (s)

let () =
  let filename = Sys.argv.(1) in
  let str = read_file filename in
  let src = Xe.string_input str in
  let xs = Xe.parse src in
  let xs = Xe.strip_space xs in
  let xs = Xe.x_lowercase xs in
  let rec aux xs =
    match xs with
    | Data (td) :: xs -> print_string ("" ^ td ^ "\n"); aux xs
    | Comm (comment) :: xs -> print_string ("# " ^ comment ^ "\n"); aux xs

    | Tag ("br", _) :: xs -> print_string "\n"; aux xs
    | ETag ("br") :: xs -> (); aux xs

    | Tag ("p", _) :: xs -> print_string "\n"; aux xs
    | ETag ("p") :: xs -> print_string "\n"; aux xs

    | Tag ("title", _) :: Data (title) ::
      ETag ("title") :: xs -> print_string (" " ^ title ^ "\n\n"); aux xs

    | Tag ("style", _) :: Data (_) ::
      ETag ("style") :: xs -> (); aux xs

    | Tag ("h1", _) :: Data (title1) ::
      ETag ("h1") :: xs -> print_string (" " ^ title1 ^ "\n\n"); aux xs

    | ETag ("div") :: xs -> print_string "\n"; aux xs

    | Tag ("hr", _) :: xs -> print_string "---\n"; aux xs

    | Tag ("img", attrs) :: xs ->  (* img-tag *)
        let alt =
          try List.assoc "alt" attrs
          with _ -> ""
        in
        print_string (" [" ^ alt ^ "]\n"); aux xs

    | Tag ("a", attrs) :: Data (link) ::
      ETag ("a") :: xs ->
        let href = try List.assoc "href" attrs with _ -> "" in
        let title = try List.assoc "title" attrs with _ -> "" in
        print_string (link ^ " " ^ title ^ "\n " ^ href ^ "\n"); aux xs

    | Tag ("a", attrs) :: xs ->  (* a-href *)
        let href = try List.assoc "href" attrs with _ -> "" in
        print_string (" " ^ href ^ "\n"); aux xs

    | Tag (_, _) :: xs -> aux xs
    | ETag (_) :: xs -> aux xs

    | [] -> ()

    (*
    | _ -> (); aux xs
    *)
  in
  aux xs
