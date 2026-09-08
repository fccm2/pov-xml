module Pv = Povray
module PvN = Povray.Normal

let color (r, g, b) = Pv.Color.RGB(r, g, b)

let () =
  let sc = Pv.new_scene () in
  let sc = Pv.add_background sc ~color:(Pv.Color.RGB(0.2, 0.3, 0.8)) in
  let sc = Pv.add_light_source sc ~color:(Pv.Color.RGB(0.2, 0.3, 0.6)) ~location:(1.6, 1.8, 1.2) in
  let sc = Pv.add_ambient_light sc ~color:(0.5, 0.6, 0.7) in

  let sc = Pv.add_camera sc
    ~location:(3.6, 0.8, 3.2)
    ~look_at:(0.0, 0.0, 0.0) () in

  let normal =
    PvN.normal_marble ~bump_depth:1.5 ~scale:0.5 ~turbulence:1.0
  (*
    PvN.normal_wrinkles ~bump_depth:1.25 ~scale:0.10

normal { bozo 5.00 scale 0.25}
normal { crackle 1.5 scale 0.25 }
normal { marble 1.5 scale 0.5 turbulence 1.0 }
normal { wrinkles 1.25 scale 0.10 }
normal { ripples 3 phase 0.5 frequency 5 }
normal { waves 0.75 scale 0.05 }
normal { granite 1.5 scale 1 }
normal { dents 5.5 scale 0.075 }
normal { facets size 0.25 }
normal { agate 1.0 agate_turb 1.0 scale 0.5 }

  *)
  in

  let sc = Pv.Mesh.add_mesh sc
    ~triangles:(Shapes.get_icosahedron ())
    ~scale:(1.0, 1.0, 1.0)
    ~texture:(Pv.new_texture ~normal ~color:(Pv.Color.RGB(1.0, 1.0, 0.8)) ()) () in

  (*
  let color1 = Pv.Color.RGB(0.8, 0.6, 0.1) in
  let color2 = Pv.Color.RGB(0.9, 0.7, 0.2) in
  let texture = Pv.new_checker ~color1 ~color2 () in
  let sc = Pv.add_plane sc ~norm:(0, 1, 0) ~dist:(0) ~texture () in
  *)

  Pv.print_scene sc;
;;
