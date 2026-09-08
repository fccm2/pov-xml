module Pov = Povray
module PovColor = Pov.Color
module PovMesh = Pov.Mesh
module Povf = Pov.Float

let triangles = [
  (* top side *)
  ( (-1.2, 1.2, -1.2), (1.2, 1.2, -1.2), (1.2, 1.2, 1.2) );
  ( (-1.2, 1.2, -1.2), (-1.2, 1.2, 1.2), (1.2, 1.2, 1.2) );

  (* bottom side *)
  ( (-1.2, -1.2, -1.2), (1.2, -1.2, -1.2), (1.2, -1.2, 1.2) );
  ( (-1.2, -1.2, -1.2), (-1.2, -1.2, 1.2), (1.2, -1.2, 1.2) );

  (* left side *)
  ( (-1.2, -1.2, -1.2), (-1.2, -1.2, 1.2), (-1.2, 1.2, 1.2) );
  ( (-1.2, -1.2, -1.2), (-1.2, 1.2, -1.2), (-1.2, 1.2, 1.2) );

  (* right side *)
  ( (1.2, -1.2, -1.2), (1.2, -1.2, 1.2), (1.2, 1.2, 1.2) );
  ( (1.2, -1.2, -1.2), (1.2, 1.2, -1.2), (1.2, 1.2, 1.2) );

  (* front side *)
  ( (-1.2, -1.2, -1.2), (1.2, -1.2, -1.2), (-1.2, 1.2, -1.2) );
  ( (-1.2, 1.2, -1.2), (1.2, 1.2, -1.2), (1.2, -1.2, -1.2) );

  (* back side *)
  ( (-1.2, -1.2, 1.2), (1.2, -1.2, 1.2), (-1.2, 1.2, 1.2) );
  ( (-1.2, 1.2, 1.2), (1.2, 1.2, 1.2), (1.2, -1.2, 1.2) );
]

let light_color = PovColor.RGB(1.0, 1.0, 1.0)
let bg_color = PovColor.RGB(0.2, 0.4, 0.8)

let mesh_color = PovColor.RGB(0.6, 0.7, 0.8)

let () =
  print_string (Pov.get_background ~color:bg_color);
  print_string (Pov.get_camera ~location:(2., 3., 4.) ~look_at:(0., 0.66, 0.) ());
  print_string (Pov.get_light_source ~location:(3.0, 4.0, 6.0) ~color:light_color);

  let texture = Pov.new_texture ~color:mesh_color () in
  print_string (PovMesh.get_mesh ~triangles ~texture ());
;;

