module Pv = Povray

let () =
  let sc = Pv.new_scene () in
  let sc = Pv.add_background sc ~color:(Pv.Color.RGB(0.2, 0.3, 0.8)) in
  let sc = Pv.add_light_source sc ~color:(Pv.Color.RGB(0.2, 0.3, 0.6)) ~location:(1.6, 1.8, 1.2) in
  let sc = Pv.add_ambient_light sc ~color:(0.2, 0.3, 0.6) in

  let sc = Pv.add_camera sc
    ~location:(2.2, 0.6, 1.8)
    ~look_at:(0.0, 0.0, 0.0) () in

  let sc = Pv.Mesh.add_mesh sc
    ~triangles:(Shapes.get_octahedron ~s:0.6 ~h:1.0)
    ~texture:(Pv.new_texture ~color:(Pv.Color.RGB(1.0, 1.0, 0.8)) ()) () in

  Pv.print_scene sc;
;;
