let should = [
  Xmlerr.Tag ("div", [("class", "hereBug")]);
  Xmlerr.Tag ("script", [("type", "text/javascript")]);
  Xmlerr.Data "var vFoo = \"<img src='./bar.jpg'/>\";";
  Xmlerr.ETag "script";
  Xmlerr.ETag "div";
]

let got = [
  Xmlerr.Tag ("div", [("class", "hereBug")]);
  Xmlerr.Tag ("script", [("type", "text/javascript")]);
  Xmlerr.Data "var vFoo = \"";
  Xmlerr.Tag ("img", [("src", "./bar.jpg")]);
  Xmlerr.ETag "img";
  Xmlerr.Data "\";";
  Xmlerr.ETag "script";
  Xmlerr.ETag "div";
]

let () =
  let h = Xmlerr.parse_file "sample.html" in
  let h = Xmlerr.strip_white h in
  if h <> should then begin
    Printf.eprintf "Bug: reading HTML tags inside javascript strings\n%!";
    exit 1;
  end
