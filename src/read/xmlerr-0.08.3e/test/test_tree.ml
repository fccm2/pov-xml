module Xe = Xmlerr
module Xt = Xmlerr_tree

let _tree =
  [Xmlerr_tree.CTag ("html", [],
    [Xmlerr_tree.CTag ("head", [],
      [Xmlerr_tree.CTag ("title", [], [Xmlerr_tree.CData "tree-test"]);
       Xmlerr_tree.CTag ("style", [("type", "text/css")],
        [Xmlerr_tree.CData "body { background:#333; color:#D60; }"])]);
     Xmlerr_tree.CTag ("body", [],
      [Xmlerr_tree.CTag ("h1", [], [Xmlerr_tree.CData "tree-test"]);
       Xmlerr_tree.CTag ("div", [("class", "main")],
        [Xmlerr_tree.CTag ("div", [("class", "desc")],
          [Xmlerr_tree.CData "sub-part"]);
         Xmlerr_tree.CTag ("div", [("class", "desc2")],
          [Xmlerr_tree.CTag ("span", [("class", "sub2")],
            [Xmlerr_tree.CData "sub-part2"])])])])]);
   Xmlerr_tree.CComm " vim:cindent sw=2 sts=2 ts=2 et\n"]
;;

let t0 () =
  let s = Xmlerr.ic_input (open_in "./tree.html") in
  let xe = Xmlerr.strip_space (Xmlerr.parse s) in
  let ts = Xmlerr_tree.dump_tree xe in
  if (ts = _tree)
  then print_endline "expected-tree"
  else prerr_endline "tree-doesnt-match"

let t1 () =
  let s = Xmlerr.ic_input (open_in "./tree.html") in
  let xe = Xmlerr.strip_space (Xmlerr.parse s) in
  if Xmlerr_tree.is_balanced xe
  then begin
    let ts = Xmlerr_tree.dump_tree xe in
    Xmlerr_tree.print_trees ts;
  end
  else prerr_endline "tree: not balanced";
;;

let () = t1 ()

