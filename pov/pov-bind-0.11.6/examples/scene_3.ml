module Pov = Povray
module PovInc = Pov.Inc_file
module PovTex = Pov.Textures
module PovColor = Pov.Color

let () =
  let sc = Pov.new_scene () in

  let sc = Pov.add_include sc ~inc:PovInc.Colors in
  let sc = Pov.add_include sc ~inc:PovInc.Woods in

  let sc = Pov.add_background sc ~color:(PovColor.RGB(0.2, 0.4, 0.8)) in
  let sc = Pov.add_camera sc ~location:(0., 2., -3.) ~look_at:(0., 1., 2.) () in
  let sc = Pov.add_light_source sc ~location:(2., 4., -3.) ~color:(PovColor.RGB(1.0, 1.0, 1.0)) in

  let texture = Pov.new_texture ~color:PovColor.Yellow () in

  let sc = Pov.add_sphere sc ~center:(0.0, 1.0, 2.0) ~radius:1.8 ~texture () in
  let sc = Pov.add_cone sc ~center1:(0., 2., 0.) ~radius1:0.6
                           ~center2:(1., 2., 3.) ~radius2:1.5
                           ~texture:(Pov.new_texture ~def:(PovTex.Wood PovTex.Wood.T_Wood5) ()) () in
  Pov.print_scene sc;
;;

