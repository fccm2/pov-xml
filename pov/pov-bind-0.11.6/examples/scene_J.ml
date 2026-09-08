module Pov = Povray
module PovInc = Pov.Inc_file
module PovColor = Pov.Color
module PovMesh = Pov.Mesh
module PovCol = PovColor
module PovDesc = Pov.Desc

let _scale v = (v, v, v)

let bg_color = PovColor.RGB(0.1, 0.1, 0.3)

let light_color1 = PovColor.RGB(0.8, 0.8, 0.8)
let light_color2 = PovColor.RGB(0.6, 0.6, 0.6)

let cam_loc = (6.2, 4.8, 8.6)
let look_at = (0.0, 0.0, 0.0)

let box_color = PovColor.RGB(0.8, 0.8, 0.76)

let () =
  let sc = Pov.new_scene () in
  let sc = Pov.add_include sc ~inc:PovInc.Colors in
  let sc = Pov.add_background sc ~color:bg_color in
  let sc = Pov.add_camera sc ~location:cam_loc ~look_at () in

  let sc = Pov.add_light_source sc ~location:(3.0, 5.0,  4.0) ~color:light_color1 in
  let sc = Pov.add_light_source sc ~location:(3.0, 5.0, -4.0) ~color:light_color2 in

  let sc = Pov.add_ambient_light sc ~color:(0.2, 0.1, 0.3) in
  let sc = Pov.add_ambient_light sc ~color:(0.4, 0.2, 0.6) in
  let sc = Pov.add_ambient_light sc ~color:(0.6, 0.4, 0.8) in

  let color1 = PovColor.RGB(0.1, 0.6, 0.2) in
  let color2 = PovColor.RGB(0.2, 0.6, 0.1) in
  let texture = Pov.new_checker ~color1 ~color2 () in
  let sc = Pov.add_plane sc ~norm:(0, 1, 0) ~dist:(0) ~texture () in

  let color = PovColor.RGB(0.8, 0.8, 0.76) in
  let texture = Pov.new_texture ~color () in

  let translation = None in
  let rotation = None in
  let scale = None in

  let corner1 = (-0.4, 0.0, -0.4) in
  let corner2 = ( 0.4, 0.6,  0.4) in

  let sc =
    PovDesc.add_descs sc [
      Pov.Box (corner1, corner2, texture, translation, rotation, scale);
    ]
  in

  Pov.print_scene sc;
;;

