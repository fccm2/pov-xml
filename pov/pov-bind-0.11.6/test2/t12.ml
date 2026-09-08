module Pv = Povray

let color (r, g, b) = Pv.Color.RGB(r, g, b)

let () =
  let sc = Pv.new_scene () in
  let sc = Pv.add_background sc ~color:(Pv.Color.RGB(0.2, 0.3, 0.8)) in
  let sc = Pv.add_light_source sc ~color:(Pv.Color.RGB(0.2, 0.3, 0.6)) ~location:(1.6, 1.8, 1.2) in
  let sc = Pv.add_ambient_light sc ~color:(0.5, 0.6, 0.7) in

  let sc = Pv.add_camera sc
    ~location:(3.6, 0.8, 3.2)
    ~look_at:(0.0, 0.0, 0.0) () in

  let texture =
    Pv.new_color_pattern
      ~pat:`wrinkles
      ~color_map:[
        (0.0, color (1., 1., 1.));
        (0.3, color (1., 0., 0.));
        (0.6, color (0., 0., 1.));
        (1.0, color (1., 1., 1.));
      ]
      ~scale:0.2 ()
  in

  let sc = Pv.Mesh.add_mesh sc
    ~triangles:(Shapes.get_icosahedron ())
    ~texture () in

  (*
  let color1 = Pv.Color.RGB(0.8, 0.6, 0.1) in
  let color2 = Pv.Color.RGB(0.9, 0.7, 0.2) in
  let texture = Pv.new_checker ~color1 ~color2 () in
  let sc = Pv.add_plane sc ~norm:(0, 1, 0) ~dist:(0) ~texture () in
  *)

  Pv.print_scene sc;
;;
