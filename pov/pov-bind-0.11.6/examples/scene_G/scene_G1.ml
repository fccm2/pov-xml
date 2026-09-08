module Pov = Povray
module PovColor = Pov.Color
module PovMesh = Pov.Mesh
module PovCol = PovColor
module PovDesc = Pov.Desc

let () = Random.self_init ()

let get_triangles s s2 = [
  ( (-. s, 0.0,    s), (0.0, s2, 0.0), (   s, 0.0,    s) );
  ( (   s, 0.0,    s), (0.0, s2, 0.0), (   s, 0.0, -. s) );
  ( (   s, 0.0, -. s), (0.0, s2, 0.0), (-. s, 0.0, -. s) );
  ( (-. s, 0.0, -. s), (0.0, s2, 0.0), (-. s, 0.0,    s) );
]

let m2 = get_triangles 0.2 1.0
let mesh_color2 = PovColor.RGB(0.1, 0.6, 0.1)

let bg_color = PovColor.RGB(0.2, 0.1, 0.4)

let light_color1 = PovColor.RGB(0.8, 0.8, 0.6)
let light_color2 = PovColor.RGB(0.6, 0.6, 0.4)

let cam_loc = (1.8, 4.8, 2.4)
let look_at = (0.0, 0.6, 0.0)

let rand_num (a, b) =
  a +. (Random.float (b -. a +. 1.0))

let () =
  let sc = Pov.new_scene () in
  let sc = Pov.add_include sc ~inc:Colors in
  let sc = Pov.add_background sc ~color:bg_color in
  let sc = Pov.add_camera sc ~location:cam_loc ~look_at () in

  let sc = Pov.add_light_source sc ~location:(3.0, 5.0,  4.0) ~color:light_color1 in
  let sc = Pov.add_light_source sc ~location:(3.0, 5.0, -4.0) ~color:light_color2 in

  let sc = Pov.add_ambient_light sc ~color:(0.2, 0.1, 0.3) in

  let texture =
    let color1 = PovColor.RGB(0.80, 0.30, 0.10) in
    let color2 = PovColor.RGB(0.86, 0.34, 0.12) in
    Pov.new_checker ~color1 ~color2 ()
  in
  let sc = Pov.add_plane sc ~norm:(0, 1, 0) ~dist:(0) ~texture () in

  let ms =
    List.init 76 (fun _ ->
      let x = rand_num (0.2, 2.2) in
      let z = rand_num (-1.4, 1.4) in
      let a = rand_num (0.0, 180.0) in
      ((x, 0.0, z), (0.0, a, 0.0))
    )
  in

  let texture = Pov.new_texture ~color:mesh_color2 () in
  let sc =
    List.fold_left (fun sc (translate, rotate) ->
      PovMesh.add_mesh sc ~triangles:m2 ~texture ~translate ~rotate ()
    ) sc ms
  in
  (*
    [
      (2.0, 0.0, 0.0), (0.0, 90.0, 0.0);
    ]
  *)

  Pov.print_scene sc;
;;

