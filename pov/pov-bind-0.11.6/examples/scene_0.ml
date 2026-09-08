module Pov = Povray
module PovCol = Povray.Color

let () =
  let sc = Pov.new_scene () in

  let sc = Pov.add_background sc ~color:(PovCol.RGB(0.2, 0.4, 0.8)) in
  let sc = Pov.add_camera sc ~location:(2., 2., -3.) ~look_at:(3., 1., 2.) () in
  let sc = Pov.add_light_source sc ~location:(2., 4., -3.) ~color:(PovCol.RGB(1.0, 0.8, 0.7)) in

  let texture = Pov.new_texture ~color:(PovCol.RGB(0.1, 0.2, 0.8)) () in

  let sc = Pov.add_sphere sc ~center:(0.0, 0.1, 0.3) ~radius:0.6 ~texture () in

  Pov.print_scene sc;
;;

