(** Untemplating Utility functions *)
(* Copyright (C) 2012 Florent Monnier, Some rights reserved
  Issues: https://github.com/fccm/ocaml-xmlerr/issues

 Permission to use, copy, modify, distribute, and sell this software and
 its documentation for any purpose is hereby granted without fee.
 No representations are made about the suitability of this software for any
 purpose.  It is provided "AS IS" without express or implied warranty.
*)
open Xmlerr


let rec for_all2 p l1 l2 =
  match (l1, l2) with
  | ([], []) -> true
  | (a1::l1, a2::l2) -> p a1 a2 && for_all2 p l1 l2
  | (_, _) -> false


let cmp_pat s =
  match String.length s with
  | 0 -> false
  | 1 -> (s = "@")
  | n -> (s.[0] = '@' && s.[n-1] = '@')


let cmp_attr (a1, v1) (a2, v2) =
  (a1 = a2) && (
    (v1 = v2) || (v1 = "_") || (v1 = "@") || (v1 = "@@") || cmp_pat v1
  )


let xtr_pat s =
  match String.length s with
  | 0 -> None
  | 1 -> if s = "@" then Some "" else None
  | 2 -> if s = "@@" then Some "" else None
  | n ->
      if s.[0] = '@' && s.[n-1] = '@'
      then Some (String.sub s 1 (n-2))
      else None


let cmp tp xs =
  let rec aux = function
  | t :: ts, x :: xs ->
      let matched =
        match t, x with
        | Data "_", Data s -> true
        | Data s1, Data s2 -> cmp_pat s1 || (s1 = s2)
        | ETag e1, ETag e2 -> (e1 = e2)
        | Comm "_", Comm c -> true
        | Comm c1, Comm c2 -> cmp_pat c1 || (c1 = c2)
        | Tag (g1, attrs1), Tag (g2, attrs2) ->
            (g1 = g2) && (for_all2 cmp_attr attrs1 attrs2)
        | _ -> false
      in
      matched && aux (ts, xs)
  | _ -> true
  in
  aux (tp, xs)


let extr_attrs attrs1 attrs2 =
  let rec aux acc = function
  | (_, sun)::t1, (_, v)::t2 ->
      begin match xtr_pat sun with
      | Some unt -> aux ((unt, v)::acc) (t1, t2)
      | None -> aux acc (t1, t2)
      end
  | _ -> List.rev acc
  in
  aux [] (attrs1, attrs2)


let extr tp xs =
  let rec aux acc = function
  | t :: ts, x :: xs ->
      begin match t, x with
      | Data sun, Data v
      | Comm sun, Comm v ->
          begin match xtr_pat sun with
          | Some unt -> aux ((unt, v)::acc) (ts, xs)
          | None -> aux acc (ts, xs)
          end
      | ETag _, ETag _ ->
          aux acc (ts, xs)
      | Tag (_, attrs1), Tag (_, attrs2) ->
          let ks = extr_attrs attrs1 attrs2 in
          if ks = [] then aux acc (ts, xs)
          else aux (ks @ acc) (ts, xs)
      | _ ->
          aux acc (ts, xs)
      end
  | _ -> List.rev acc
  in
  aux [] (tp, xs)


let pop n lst =
  let rec aux i lst =
    if i <= 0 then lst else
      match lst with
      | hd :: tl -> aux (pred i) tl
      | [] -> failwith "pop"
  in
  aux n lst


let extract tp xs =
  let tp_len = List.length tp in
  let rec aux acc = function
  | [] -> List.rev acc
  | (_ :: tl) as xs ->
      if cmp tp xs
      then aux ((extr tp xs) :: acc) (pop tp_len xs)
      else aux acc tl
  in
  aux [] xs
