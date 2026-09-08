module Pov = Povray
module PovCol = Povray.Color
module PovInc = Povray.Inc_file

let font1 = "/usr/share/fonts/TTF/Vera.ttf"
let font2 = "/mnt/chromeos/fonts/monotype/verdana.ttf"

let () =
  let sc = Pov.new_scene () in
  let sc = Pov.add_include sc ~inc:PovInc.Colors in

  let sc = Pov.add_background sc ~color:(PovCol.RGB(0.2, 0.4, 0.8)) in
  let sc = Pov.add_camera sc ~location:(2., 2., -3.) ~look_at:(3., 1., 2.) () in
  let sc = Pov.add_light_source sc ~location:(2., 4., -3.) ~color:(PovCol.RGB(1.0, 0.8, 0.7)) in
  let sc = Pov.add_ambient_light sc ~color:(0.0, 0.3, 0.6) in

  let texture = Pov.new_texture ~color:PovCol.Cyan () in
  (*
  let texture = Pov.get_texture ~color:(PovCol.RGB(1.0, 0.8, 0.8)) () in
  *)
  let sc = Pov.add_text sc ~text:"Hello PovRay" ~font:font2 ~texture () in
  let sc = Pov.add_torus sc ~major:1.2 ~minor:0.2 ~texture
                      ~translate:(2.0, 1.0, 2.0)
                      ~rotate:(90.0, 0.0, 0.0) () in

  Pov.print_scene sc;
;;

