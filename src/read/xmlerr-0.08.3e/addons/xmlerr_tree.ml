module Xe = Xmlerr

type attr = string * string  (** (attr_name, attr_val) *)
type attrs = attr list

type tree =
  | CTag of string * attrs * tree list  (** rec: sub-t *)
  | CData of string  (** PCData *)
  | CComm of string  (** Comments *)

(*
let dump_tree xs =
  let rec aux xs =
    match xs with
    | [] -> []
    | x::xs ->
        begin match x with
        | Xe.Data s -> [CData s]
        | Xe.Comm c -> [CComm c]
        | Xe.Tag (name, attrs) ->
            let sub = aux xs in
            [CTag (name, attrs, sub)]
        | Xe.ETag (name) -> [CEmpty]
        end
  in
  aux xs
*)

let push xs x = x :: xs
let pop xs =
  match xs with
  | x :: xs -> Some (xs, x)
  | [] -> None

let is_balanced xs =
  let rec aux depth xs =
    begin match xs with
    | [] -> ()
    | (Xe.Data _)::xs -> aux depth xs
    | (Xe.Comm _)::xs -> aux depth xs

    | (Xe.Tag (name, _))::xs ->
        let depth = push depth name in
        aux (depth) xs

    | (Xe.ETag (name1))::xs ->
        let depth =
          match (pop depth) with
          | None -> raise Exit
          | Some (depth, name2) ->
              if name1 = name2 then (depth) else raise Exit
        in
        aux (depth) xs
    end
  in
  try aux [] xs; true
  with Exit -> false
;;

let dump_tree xs =
  let _xs = ref [] in
  let rec sub acc xs =
    begin match xs with
    | [] -> (List.rev acc)
    | (Xe.Data s)::xs -> sub ((CData s)::acc) xs
    | (Xe.Comm c)::xs -> sub ((CComm c)::acc) xs
    
    | (Xe.ETag (name))::xs ->
        _xs := xs;
        (List.rev acc)
    
    | (Xe.Tag (name, attrs))::xs ->
        let sub_t = sub [] xs in
        
        let xs = !_xs in
    
        sub ((CTag (name, attrs, sub_t ))::acc) xs

    end
  in
  (sub [] xs)
;;

let s_attrs attrs =
  let len = List.length attrs in
  let sep = if len <= 3 then "" else "\n" in
  let attrs =
    List.map (fun (attr_name, attr_v) ->
      Printf.sprintf " %s='%s'" attr_name attr_v;
    ) attrs
  in
  (String.concat sep attrs)

let print_tree tree =
  let rec aux tree =
    match tree with
    | CTag (tag, attrs, sub_t) ->
        Printf.printf "<%s%s>\n" tag (s_attrs attrs);
        List.iter aux sub_t;
        Printf.printf "</%s>\n" tag;
    | CData d ->
        Printf.printf "%s\n" d;
    | CComm cm ->
        Printf.printf "<!-- %s -->\n" cm;
  in
  aux tree;
;;

let print_trees tree_s =
  List.iter print_tree tree_s;
;;

let test_data =
  [CTag ("html", [],
    [CTag ("head", [],
      [CTag ("title", [], [CData "tree-test"]);
       CTag ("style", [("type", "text/css")],
        [CData "body { background:#333; color:#D60; }"])]);
     CTag ("body", [],
      [CTag ("h1", [], [CData "tree-test"]);
       CTag ("div", [("class", "main")],
        [CTag ("div", [("class", "desc")],
          [CData "sub-part"]);
         CTag ("div", [("class", "desc2")],
          [CTag ("span", [("class", "sub2")],
            [CData "sub-part2"])])])])]);
   CComm " vim:cindent sw=2 sts=2 ts=2 et\n"]
;;

let test_data_in =
 [Xmlerr.Tag ("html", []); Xmlerr.Tag ("head", []); Xmlerr.Tag ("title", []);
  Xmlerr.Data "tree-test"; Xmlerr.ETag "title";
  Xmlerr.Tag ("style", [("type", "text/css")]);
  Xmlerr.Data "body { background:#333; color:#D60; }"; Xmlerr.ETag "style";
  Xmlerr.ETag "head"; Xmlerr.Tag ("body", []); Xmlerr.Tag ("h1", []);
  Xmlerr.Data "tree-test"; Xmlerr.ETag "h1";
  Xmlerr.Tag ("div", [("class", "main")]);
  Xmlerr.Tag ("div", [("class", "desc")]); Xmlerr.Data "sub-part";
  Xmlerr.ETag "div"; Xmlerr.Tag ("div", [("class", "desc2")]);
  Xmlerr.Tag ("span", [("class", "sub2")]); Xmlerr.Data "sub-part2";
  Xmlerr.ETag "span"; Xmlerr.ETag "div"; Xmlerr.ETag "div";
  Xmlerr.ETag "body"; Xmlerr.ETag "html";
  Xmlerr.Comm " vim:cindent sw=2 sts=2 ts=2 et\n"]
;;

