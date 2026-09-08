module Pov = Povray
module PovColor = Pov.Color
module PovMesh = Pov.Mesh
module PovCol = PovColor
module PovDesc = Pov.Desc

let get_triangles s s2 = [
  ( (-. s, 0.0,    s), (0.0, s2, 0.0), (   s, 0.0,    s) );
  ( (   s, 0.0,    s), (0.0, s2, 0.0), (   s, 0.0, -. s) );
  ( (   s, 0.0, -. s), (0.0, s2, 0.0), (-. s, 0.0, -. s) );
  ( (-. s, 0.0, -. s), (0.0, s2, 0.0), (-. s, 0.0,    s) );
]

let _scale v = (v, v, v)

let m1 = get_triangles 1.2 1.3
let m2 = get_triangles 0.2 1.0

let bg_color = PovColor.RGB(0.1, 0.1, 0.6)

let light_color1 = PovColor.RGB(0.8, 0.8, 0.8)
let light_color2 = PovColor.RGB(0.6, 0.6, 0.6)

let cam_loc = (1.8, 4.8, 2.4)
let look_at = (0.0, 0.6, 0.0)

let mesh_color = PovColor.RGB(0.8, 0.6, 0.2)
let mesh_color2 = PovColor.RGB(0.2, 0.4, 0.1)

let box_color = PovColor.RGB(0.8, 0.8, 0.76)

let tex_cyan = Pov.new_texture ~color:Cyan ()

let () =
  let sc = Pov.new_scene () in
  let sc = Pov.add_include sc ~inc:Colors in
  let sc = Pov.add_background sc ~color:bg_color in
  let sc = Pov.add_camera sc ~location:cam_loc ~look_at () in

  let sc = Pov.add_light_source sc ~location:(3.0, 5.0,  4.0) ~color:light_color1 in
  let sc = Pov.add_light_source sc ~location:(3.0, 5.0, -4.0) ~color:light_color2 in

  let sc = Pov.add_ambient_light sc ~color:(0.2, 0.1, 0.3) in

  let color1 = PovColor.RGB(0.1, 0.6, 0.2) in
  let color2 = PovColor.RGB(0.2, 0.6, 0.1) in
  let texture = Pov.new_checker ~color1 ~color2 () in
  let sc = Pov.add_plane sc ~norm:(0, 1, 0) ~dist:(0) ~texture () in

  let texture = Pov.new_texture ~color:mesh_color () in
  let sc =
    List.fold_left (fun sc (translate, scale) ->
      PovMesh.add_mesh sc ~triangles:m1 ~texture ~translate ~scale ()
    ) sc [
      ( 0.0, 0.0,  0.0), (_scale 0.8);
      ( 1.8, 0.0, -1.4), (_scale 0.12);
      ( 1.2, 0.0, -2.2), (_scale 0.12);
      ( 0.6, 0.0, -1.6), (_scale 0.12);
    ]
  in

  let texture = Pov.new_texture ~color:mesh_color2 () in
  let sc =
    List.fold_left (fun sc (translate, rotate) ->
      PovMesh.add_mesh sc ~triangles:m2 ~texture ~translate ~rotate ()
    ) sc [
      (-1.0, 0.0, -2.0), (0.0, 0.0, 0.0);
      (-2.0, 0.0, -1.0), (0.0, 0.0, 0.0);
      (-2.4, 0.0,  0.4), (0.0, 0.0, 0.0);
      (-1.4, 0.0,  2.2), (0.0, 90.0, 0.0);
    ]
  in

  let texture = Pov.new_texture ~color:box_color () in
  let corner1 = (0.0, 0.4, 0.2) in
  let corner2 = (0.2, 0.0, 0.0) in
  let translate1 = (-0.6, 0.0, -2.8) in
  let translate2 = (-0.2, 0.0, -3.0) in
  let desc = [
    Pov.Box (corner1, corner2, texture, Some translate1, None, None);
    Pov.Box (corner1, corner2, texture, Some translate2, None, None);
  ] in
  let sc = PovDesc.add_descs sc desc in

  Pov.print_scene sc;
;;

