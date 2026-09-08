module Pov = Povray
module PovColor = Pov.Color
module PovInc = Pov.Inc_file
module PovMesh = Pov.Mesh
module PovCol = PovColor
module PovDesc = Pov.Desc

let () = Random.self_init ()

let bg_color = PovColor.RGB(0.2, 0.1, 0.4)

let light_color1 = PovColor.RGB(0.8, 0.8, 0.6)
let light_color2 = PovColor.RGB(0.6, 0.6, 0.4)

let cam_loc = (1.8, 4.6, 2.4)
let look_at = (0.0, 0.8, 0.0)

let _scale v = (v, v, v)

let rand_num (a, b) =
  a +. (Random.float (b -. a +. 1.0))

let rand_color () =
  PovColor.RGB(
    Random.float 1.0,
    Random.float 1.0,
    Random.float 1.0)

let () =
  let sc = Pov.new_scene () in
  let sc = Pov.add_include sc ~inc:PovInc.Colors in
  let sc = Pov.add_background sc ~color:bg_color in
  let sc = Pov.add_camera sc ~location:cam_loc ~look_at () in

  let sc = Pov.add_light_source sc ~location:(3.0, 5.0,  4.0) ~color:light_color1 in
  let sc = Pov.add_light_source sc ~location:(3.0, 5.0, -4.0) ~color:light_color2 in

  let sc = Pov.add_ambient_light sc ~color:(0.2, 0.1, 0.3) in

  (* blue-checker *)
  let texture =
    let color1 = PovColor.RGB(0.1, 0.6, 0.2) in
    let color2 = PovColor.RGB(0.2, 0.6, 0.1) in
    Pov.new_checker ~color1 ~color2 ()
  in
  let sc = Pov.add_plane sc ~norm:(0, 1, 0) ~dist:(0) ~texture () in

  (* spheres *)
  let box_color = PovColor.RGB(0.8, 0.8, 0.76) in
  let c1 = Pov.new_texture ~color:box_color () in
  let c2 = Pov.new_checker ~color1:PovCol.Blue ~color2:PovCol.Red () in
  let c3 = Pov.new_checker ~color1:PovCol.Cyan ~color2:PovCol.Yellow () in
  let sc =
    List.fold_left (fun sc (translate, radius, center, scale, texture) ->
      Pov.add_sphere sc
        ~radius ~center ~scale ~translate
        ~rotate:(0.0, 0.0, 0.0)
        ~texture ()

    ) sc [
      (* [ translation / radius / center / scale / texture ] *)
      (-0.9, 0.0,  1.2), (0.6), (0.0, 0.0, 0.0), (_scale 0.4), c1;
      (-0.4, 0.0,  0.6), (0.6), (0.0, 0.0, 0.0), (_scale 0.3), c1;
      (-0.2, 0.0,  1.6), (0.6), (0.0, 0.0, 0.0), (_scale 0.2), c1;

      (-2.4, 0.2,  0.6), (1.8), (0.0, 1.4, 0.0), (_scale 0.5), c2;
      (-1.2, 0.4, -0.8), (1.4), (0.0, 1.4, 0.0), (_scale 0.4), c3;
    ]
  in

  Pov.print_scene sc;
;;

