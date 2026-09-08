module Pov = Povray
module PovColor = Pov.Color
module PovMesh = Pov.Mesh

let get_triangles s s2 = [
  ( (-. s, 0.0,    s), (0.0, s2, 0.0), (   s, 0.0,    s) );
  ( (   s, 0.0,    s), (0.0, s2, 0.0), (   s, 0.0, -. s) );
  ( (   s, 0.0, -. s), (0.0, s2, 0.0), (-. s, 0.0, -. s) );
  ( (-. s, 0.0, -. s), (0.0, s2, 0.0), (-. s, 0.0,    s) );
]

let m1 = get_triangles 1.2 1.2
let m2 = get_triangles 0.2 1.0

let light_color = PovColor.RGB(0.8, 0.8, 0.8)
let bg_color = PovColor.RGB(0.1, 0.1, 0.6)

let cam_loc = (1.8, 4.8, 2.4)
let look_at = (0.0, 0.6, 0.0)

let mesh_color = PovColor.RGB(0.8, 0.6, 0.2)
let mesh_color2 = PovColor.RGB(0.2, 0.4, 0.1)

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
  let sc = PovMesh.add_mesh sc ~triangles:m1 ~texture () in

  let texture = Pov.new_texture ~color:mesh_color2 () in

  let sc = PovMesh.add_mesh sc ~triangles:m2 ~texture
                ~translate:(-1.0, 0.0, -2.0) ~rotate:(0.0, 0.0, 0.0) () in

  let sc = PovMesh.add_mesh sc ~triangles:m2 ~texture
                ~translate:(-2.0, 0.0, -1.0) ~rotate:(0.0, 6.0, 0.0) () in

  let sc = PovMesh.add_mesh sc ~triangles:m2 ~texture
                ~translate:(-2.4, 0.0,  0.4) ~rotate:(0.0, 8.6, 0.0) () in

  let sc = PovMesh.add_mesh sc ~triangles:m2 ~texture
                ~translate:(-1.2, 0.0,  2.4) ~rotate:(0.0, 8.6, 0.0) () in

  Pov.print_scene sc;
;;

