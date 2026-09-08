module Pov = Povray
module PovColor = Pov.Color
module PovMesh = Pov.Mesh

let triangles = [
  ( (-1.2, 0.0,  1.2), (0.0, 1.2, 0.0), ( 1.2, 0.0,  1.2) );
  ( ( 1.2, 0.0,  1.2), (0.0, 1.2, 0.0), ( 1.2, 0.0, -1.2) );
  ( ( 1.2, 0.0, -1.2), (0.0, 1.2, 0.0), (-1.2, 0.0, -1.2) );
  ( (-1.2, 0.0, -1.2), (0.0, 1.2, 0.0), (-1.2, 0.0,  1.2) );
]

let light_color = PovColor.RGB(0.8, 0.8, 0.8)
let bg_color = PovColor.RGB(0.1, 0.1, 0.6)

let cam_loc = (1.8, 4.8, 2.4)
let look_at = (0.0, 0.6, 0.0)

let mesh_color = PovColor.RGB(0.8, 0.6, 0.2)

let tex_cyan = Pov.new_texture ~color:Cyan ()

let () =
  let sc = Pov.new_scene () in
  let sc = Pov.add_include sc ~inc:Colors in
  let sc = Pov.add_background sc ~color:bg_color in
  let sc = Pov.add_camera sc ~location:cam_loc ~look_at () in

  let sc = Pov.add_light_source sc ~location:(3.0, 5.0,  4.0) ~color:light_color in
  let sc = Pov.add_light_source sc ~location:(3.0, 5.0, -4.0) ~color:light_color in

  let sc = Pov.add_ambient_light sc ~color:(0.2, 0.1, 0.3) in

  let texture = Pov.new_texture ~color:mesh_color () in
  let sc = PovMesh.add_mesh sc ~triangles ~texture () in

  Pov.print_scene sc;
;;

