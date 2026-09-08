type t =
  | S of string
  | Var of string

let read_tmpl s =
  let n = String.length s in
  let rec aux i j reg acc =
    if i >= n then begin
      if i = j then acc else
      let r = String.sub s j (i - j) in
      let r = if reg then S r else Var r in
      List.rev (r::acc)
    end else
      if s.[i] = '@' then begin
        let r = String.sub s j (i - j) in
        let r = if reg then S r else Var r in
        aux (i+1) (i+1) (not reg) (r::acc)
      end else
        aux (i+1) j reg acc
  in
  aux 0 0 true []

let rec list_assoc_opt x = function
  | [] -> None
  | (a,b)::l -> if compare a x = 0 then Some b else list_assoc_opt x l

let f ts ~x =
  List.map (function
  | (Var v) as var ->
      begin match list_assoc_opt v x with
      | Some s -> S s
      | None -> var
      end
  | s -> s
  ) ts

let fe ts ~x =
  let r = f ts ~x in
  let r = List.map (function S s -> s | Var _ -> invalid_arg "fe") r in
  (String.concat "" r)

let print ts =
  List.iter (function
    | S s -> Printf.printf "S: %S\n" s
    | Var v -> Printf.printf "Var: %S\n" v
  ) ts
