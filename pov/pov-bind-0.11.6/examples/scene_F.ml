module Pov = Povray
module PovColor = Pov.Color
module PovMesh = Pov.Mesh
module PovCol = PovColor
module PovDesc = Pov.Desc

let () = Random.self_init ()

let bg_color = PovColor.RGB(0.2, 0.1, 0.4)

let light_color1 = PovColor.RGB(0.6, 0.6, 0.6)
let light_color2 = PovColor.RGB(0.4, 0.4, 0.4)

let cam_loc = (1.8, 4.8, 2.4)
let look_at = (0.0, 0.6, 0.0)

let mesh_color = PovColor.RGB(0.8, 0.6, 0.2)
let box_color = PovColor.RGB(1.0, 1.0, 1.0)

let rand_num a b =
  a + (Random.int (b - a + 1))

let _scale v = (v, v, v)

let () =
  let sc = Pov.new_scene () in
  let sc = Pov.add_include sc ~inc:Colors in
  let sc = Pov.add_background sc ~color:bg_color in
  let sc = Pov.add_camera sc ~location:cam_loc ~look_at () in

  let sc = Pov.add_light_source sc ~location:(3.0, 5.0,  4.0) ~color:light_color1 in
  let sc = Pov.add_light_source sc ~location:(3.0, 5.0, -4.0) ~color:light_color2 in

  let sc = Pov.add_ambient_light sc ~color:(0.2, 0.1, 0.3) in

  let texture =
    let color1 = PovColor.RGB(0.6, 0.1, 0.2) in
    let color2 = PovColor.RGB(0.6, 0.2, 0.1) in
    Pov.new_checker ~color1 ~color2 ()
  in
  let sc = Pov.add_plane sc ~norm:(0, 1, 0) ~dist:(0) ~texture () in

  let triangles = [
    (* top side *)
    ( (-0.8, 0.8, -0.8), (0.8, 0.8, -0.8), (0.8, 0.8, 0.8) );
    ( (-0.8, 0.8, -0.8), (-0.8, 0.8, 0.8), (0.8, 0.8, 0.8) );

    (* left side *)
    ( (-0.8, -0.8, -0.8), (-0.8, -0.8, 0.8), (-0.8, 0.8, 0.8) );
    ( (-0.8, -0.8, -0.8), (-0.8, 0.8, -0.8), (-0.8, 0.8, 0.8) );

    (* right side *)
    ( (0.8, -0.8, -0.8), (0.8, -0.8, 0.8), (0.8, 0.8, 0.8) );
    ( (0.8, -0.8, -0.8), (0.8, 0.8, -0.8), (0.8, 0.8, 0.8) );

    (* front side *)
    ( (-0.8, -0.8, -0.8), (0.8, -0.8, -0.8), (-0.8, 0.8, -0.8) );
    ( (-0.8, 0.8, -0.8), (0.8, 0.8, -0.8), (0.8, -0.8, -0.8) );

    (* back side *)
    ( (-0.8, -0.8, 0.8), (0.8, -0.8, 0.8), (-0.8, 0.8, 0.8) );
    ( (-0.8, 0.8, 0.8), (0.8, 0.8, 0.8), (0.8, -0.8, 0.8) );
  ] in

  let mesh_color = PovColor.RGB(0.6, 0.7, 0.8) in
  let texture = Pov.new_texture ~color:mesh_color () in
  let sc = PovMesh.add_mesh sc ~triangles ~texture () in

  (* box *)
  let texture = Pov.new_texture ~color:box_color () in
  let sc = Pov.add_box sc
    ~corner1:(0.0, 0.2, 0.2)
    ~corner2:(0.2, 0.0, 0.0)
    ~translate:( 2.2, 0.0, -0.4)
    ~scale:(_scale 0.6)
    ~texture ()
  in
  let _sc = ref sc in
  for i = 0 to pred 12 do
    let x = (float (rand_num 18 28)) /. 10.0 in
    let y = 0.0 in
    let z = (float (rand_num 12 16)) /. 10.0 in
    let translate = (x, y, z -. 1.0) in
    let sc = !_sc in
    let sc = Pov.add_box sc
      ~corner1:(0.0, 0.2, 0.2)
      ~corner2:(0.2, 0.0, 0.0)
      ~translate
      ~scale:(_scale 0.6)
      ~texture ()
    in
    _sc := sc;
  done;
  let sc = !_sc in

  Pov.print_scene sc;
;;

