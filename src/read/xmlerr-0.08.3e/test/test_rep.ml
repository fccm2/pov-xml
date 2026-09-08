module Xe = Xmlerr
module Xr = Xmlerr_report

let _tree = [] ;;

let main1 () =
  let s = Xmlerr.ic_input (open_in "./index.html") in
  let xe = Xmlerr.strip_space (Xmlerr.parse s) in
  if Xmlerr_report.is_balanced xe
  then print_endline "tree: balanced"
  else prerr_endline "tree: not balanced";
;;

let () =
  prerr_newline ();
  let s = Xmlerr.ic_input (open_in "./index.html") in
  let xe = Xmlerr.strip_space (Xmlerr.parse s) in
  match Xmlerr_report.balance_rep xe with
  | Balanced -> print_endline "tree: balanced"
  | Balance_err_at i -> Printf.eprintf "tree: not balanced at tag %d" i
;;

let () =
  prerr_newline ();
  let s = Xmlerr.ic_input (open_in "./index.html") in
  let xe = Xmlerr.strip_space (Xmlerr.parse s) in
  let d = Xmlerr_report.max_depth xe in
  Printf.printf "tree: max-depth %d\n" d;
;;

