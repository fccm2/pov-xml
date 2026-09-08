
let sub_eq s1 s2 ofs1 ofs2 n =
  let r = ref true in
  for i = 0 to pred n do
    let c1 = s1.[ofs1 + i]
    and c2 = s2.[ofs2 + i] in
    r := !r && (c1 = c2)
  done;
  !r

let sub_eq s1 s2 ofs1 ofs2 n =
  try sub_eq s1 s2 ofs1 ofs2 n
  with _ -> false

let find f l =
  try Some(List.find f l)
  with Not_found -> None

let str_copy s =
  String.init (String.length s) (fun r -> String.get s r)

let replaces s repl =
  let len = String.length s in
  if len = 0 then  str_copy s else
  let rec aux i j acc =
    if i >= len
    then
      let v = String.sub s j (i-j) in
      List.rev (v::acc)
    else
      let b =
        find (fun (item, _) ->
          sub_eq s item i 0 (String.length item)
        ) repl
      in
      match b with
      | None ->
          aux (i+1) j acc
      | Some (item, rep) ->
          let v = String.sub s j (i-j) in
          let k = i + (String.length item) in
          aux k k (rep::v::acc)
  in
  let chunks = aux 0 0 [] in
  let r = (String.concat "" chunks) in
  (*
  if r = s then r else r
  *)
  r
