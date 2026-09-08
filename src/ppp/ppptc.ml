module Xt = Xmlerr
let highlight clr_name s =
  let r = "\027[00m" in  (* reset *)
  match clr_name with
  | `yellow     -> "\027[33m" ^ s ^ r
  | `blue       -> "\027[34m" ^ s ^ r
  | `magenta    -> "\027[35m" ^ s ^ r
  | `cyan       -> "\027[36m" ^ s ^ r
  | `red   -> "\027[31m" ^ s ^ r
  | `green -> "\027[32m" ^ s ^ r
let highlht0 s = highlight `yellow s
let highlht1 s = highlight `green s
let highlht5 s = highlight `cyan s
let highlht7 s = highlight `red s
let str_eq s0 s1 =
  (s0 = s1)
let () =
  let xt =
    if (Array.length Sys.argv) = 1 || Sys.argv.(1) = "-"
    then Xmlerr.parse_ic (stdin)
    else Xmlerr.parse_file ~filename:Sys.argv.(1)
  in
  let xt = Xmlerr.rem_space xt in
  (*
  Xt.print_html_indent (xt);
  *)

  let rec aux_ndt xt n =
    match xt with
    | [] -> ()
    | Xt.Tag (xt_n0, xt_ttr) ::
      Xt.ETag (xt_n1) :: tx
      when str_eq xt_n0 xt_n1 ->
          Printf.printf "%s" (String.concat "" (List.map (String.make 1) (List.init (n*2) (fun _ -> ' ')))) ;
          Printf.printf "<%s" (highlht5 xt_n0) ;
          List.iter (fun (ttr_nm, ttr_vl) ->
            Printf.printf " %s='%s'" (highlht0 ttr_nm) (highlht1 ttr_vl) ;
          ) xt_ttr ;
          Printf.printf " />\n" ;
        aux_ndt tx (n)
    | hx :: tx ->
      begin match hx with
      | Xt.ETag (xt_n) ->
          let n = (n-1) in
          Printf.printf "%s" (String.concat "" (List.map (String.make 1) (List.init (n*2) (fun _ -> ' ')))) ;
          Printf.printf "</%s>\n" (highlht5 xt_n) ;
          aux_ndt tx (n)
      | Xt.Tag (xt_n, xt_ttr) ->
          Printf.printf "%s" (String.concat "" (List.map (String.make 1) (List.init (n*2) (fun _ -> ' ')))) ;
          Printf.printf "<%s" (highlht5 xt_n) ;
          List.iter (fun (ttr_nm, ttr_vl) ->
            Printf.printf " %s='%s'" (highlht0 ttr_nm) (highlht1 ttr_vl) ;
          ) xt_ttr ;
          Printf.printf ">\n" ;
          aux_ndt tx (n+1)
      | Xt.Data dt ->
          Printf.printf "%s" dt ;
          aux_ndt tx (n+0)
      | Xt.Comm str ->
          Printf.printf "%s" (String.concat "" (List.map (String.make 1) (List.init (n*2) (fun _ -> ' ')))) ;
          Printf.printf "%s\n" (highlight `blue ("<!-- " ^ str ^ " -->")) ;
          aux_ndt tx (n+0)
      (*
      | _ ->
          aux_ndt tx (n+0)
      *)
      end;
  in
  aux_ndt xt 0;
;;
