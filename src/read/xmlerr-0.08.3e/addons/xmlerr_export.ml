open Xmlerr
let f ts =
  let b = Buffer.create 124 in
  let f t =
    match t with
    | Tag (t_name, attrs) ->  (** opening tag *) (* :string * attr list *)
        Printf.bprintf b "(%s " t_name;
        List.iter (fun attr ->
          match attr with
          | a_name, a_val ->
              Printf.bprintf b "(%s %s)" a_name a_val;
        ) attrs;
    | ETag _ ->  (** closing tag *)
        Printf.bprintf b ") ";
    | Data dt ->  (** pcdata *)
        Printf.bprintf b "\"%s\"" dt;
    | Comm com ->  (** comments *)
        Printf.bprintf b ";%s" com;
  in
  let rec aux ts =
    match ts with
    | t::ts -> f t; aux ts
    | [] -> (Buffer.contents b)
  in aux ts

let to_sexpr ~s =
  let ts = Xmlerr.parse_string s in f ts

let file_to_sexpr ~fn =
  let ts = Xmlerr.parse_file ~filename:fn in f ts
