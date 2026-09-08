(* checks and report *)
module Xe = Xmlerr

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

exception Report_bal of int

type bal_rep =
  | Balance_err_at of int
  | Balanced

let balance_rep xs =
  let rec aux i depth xs =
    begin match xs with
    | (Xe.Data _)::xs -> aux (succ i) depth xs
    | (Xe.Comm _)::xs -> aux (succ i) depth xs

    | (Xe.Tag (name, _))::xs ->
        let depth = push depth name in
        aux (succ i) (depth) xs

    | (Xe.ETag (name1))::xs ->
        let depth =
          match (pop depth) with
          | None -> raise (Report_bal i)
          | Some (depth, name2) ->
              if name1 = name2 then (depth) else raise (Report_bal i)
        in
        aux (succ i) (depth) xs

    | [] ->
        if (List.length depth) = 0 then ()
        else raise (Report_bal i)
    end
  in
  try aux 0 [] xs; (Balanced)
  with Report_bal i -> (Balance_err_at i)
;;

let _max_depth xs =
  let rec aux i depth _max xs =
    begin match xs with
    | [] -> (_max)
    | (Xe.Data _)::xs -> aux i depth _max xs
    | (Xe.Comm _)::xs -> aux i depth _max xs

    | (Xe.Tag (name, _))::xs ->
        let depth = push depth name in
        aux (succ i) (depth) _max xs

    | (Xe.ETag (name1))::xs ->
        let depth =
          match (pop depth) with
          | None -> raise Exit
          | Some (depth, name2) ->
              if name1 = name2 then (depth) else raise Exit
        in
        aux (pred i) (depth) (max i _max) xs
    end
  in
  aux 0 [] 0 xs
;;

let max_depth xs =
  try (_max_depth xs)
  with Exit -> invalid_arg "not-balanced"

let max_depth_opt xs =
  try Some (_max_depth xs)
  with Exit -> None

let test_data = [] ;;

