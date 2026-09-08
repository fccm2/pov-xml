module Pov = Povray
module PovColor = Pov.Color
module PovMesh = Pov.Mesh
module PovCol = PovColor
module PovDesc = Pov.Desc

let () = Random.self_init ()

let bg_color = PovColor.RGB(0.2, 0.1, 0.4)

let light_color1 = PovColor.RGB(0.8, 0.8, 0.6)
let light_color2 = PovColor.RGB(0.6, 0.6, 0.4)

let cam_loc = (1.8, 4.8, 2.4)
let look_at = (0.0, 0.6, 0.0)

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
  let sc = Pov.add_include sc ~inc:Colors in
  let sc = Pov.add_background sc ~color:bg_color in
  let sc = Pov.add_camera sc ~location:cam_loc ~look_at () in

  let sc = Pov.add_light_source sc ~location:(3.0, 5.0,  4.0) ~color:light_color1 in
  let sc = Pov.add_light_source sc ~location:(3.0, 5.0, -4.0) ~color:light_color2 in

  let sc = Pov.add_ambient_light sc ~color:(0.2, 0.1, 0.3) in

  (* blue-checker *)
  let texture =
    let color1 = PovColor.RGB(0.10, 0.30, 0.80) in
    let color2 = PovColor.RGB(0.12, 0.34, 0.86) in
    Pov.new_checker ~color1 ~color2 ()
  in
  let sc = Pov.add_plane sc ~norm:(0, 1, 0) ~dist:(0) ~texture () in

  (* boxes *)
  let box_color = PovColor.RGB(0.8, 0.8, 0.76) in
  let box_color2 = PovColor.RGB(1.0, 0.4, 0.1) in
  let box_color3 = PovColor.RGB(0.2, 0.9, 0.1) in
  let box_color4 = PovColor.RGB(0.1, 0.2, 0.9) in

  let sc = Pov.add_union sc
    ~rotate:(0.0, 2.0, 0.0)
    ~translate:(-0.6, 0.0, 0.0)
    ~group:(fun sc ->
      let sc =
        List.fold_left (fun sc (translate, dims, scale, color) ->
          let texture = Pov.new_texture ~color () in
          let corner1, corner2 =  (* (w, h, l) *)
            let w, h, l = (dims) in
            ( (0.0, h, w), (l, 0.0, 0.0) )
          in
          Pov.add_box sc
            ~corner1 ~corner2
            ~translate ~scale
            ~texture ()
        ) sc [
          (* (translation, (dims), scale) *)
          (( 0.2, 0.0, -2.0), (0.2, 0.16, 0.8), (_scale 1.2), box_color);
     
          (( 1.0, 0.0, -0.2), (0.2, 0.12, 0.6), (_scale 1.0), box_color);
          (( 0.1, 0.0, -1.2), (0.2, 0.1, 0.4), (_scale 0.8), box_color);
     
          (( 0.2, 0.17, -2.0), (0.1, 0.08, 0.2), (_scale 1.2), box_color2);
          (( 0.5, 0.18, -1.9), (0.1, 0.08, 0.2), (_scale 1.2), box_color3);
          (( 0.8, 0.19, -2.0), (0.1, 0.08, 0.2), (_scale 1.2), box_color4);
        ]
      in
      (sc)
    ) ()
  in

  let sc = Pov.add_union sc
    ~rotate:(0.0, -6.0, 0.0)
    ~translate:(-0.8, 0.0, 0.0)
    ~group:(fun sc ->
      let texture = Pov.new_texture ~color:box_color () in
      let sc = Pov.add_sphere sc
        ~center:(-0.8, 2.6,  1.2)
        ~radius:0.16 ~texture ()
      in
      let sc = Pov.add_sphere sc
        ~center:(-0.2, 2.6,  1.2)
        ~radius:0.16 ~texture ()
      in
      let sc = Pov.add_cylinder sc
        ~center1:(-0.8, 2.6,  1.2)
        ~center2:(-0.2, 2.6,  1.2)
        ~radius:0.16 ~texture ()
      in
      (sc)
    ) ()
  in

  Pov.print_scene sc;
;;

