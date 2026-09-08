module Pov = Povray
module PovInc = Pov.Inc_file
module PovColor = Pov.Color
module PovCol = Pov.Color
module PovMeshC = Pov.MeshC
module Povf = Pov.Float

let mesh_color1 = PovColor.RGB(1.0, 0.0, 0.0)
let mesh_color2 = PovColor.RGB(0.0, 0.0, 1.0)
let mesh_color3 = PovColor.RGB(0.0, 1.0, 0.0)

let triangles = [
  (* top-side *)
  ( (-1.2, 1.2, -1.2), (1.2, 1.2, -1.2), (1.2, 1.2, 1.2) ), mesh_color1;
  ( (-1.2, 1.2, -1.2), (-1.2, 1.2, 1.2), (1.2, 1.2, 1.2) ), mesh_color2;

  (* left-side *)
  ( (-1.2, -1.2, -1.2), (-1.2, 1.2, -1.2), (-1.2, 1.2, 1.2) ), mesh_color1;
  ( (-1.2, -1.2, -1.2), (-1.2, -1.2, 1.2), (-1.2, 1.2, 1.2) ), mesh_color2;
]

let light_color = PovColor.RGB(1.0, 1.0, 1.0)
let bg_color = PovColor.RGB(0.2, 0.4, 0.8)

let () =
  print_string (Pov.get_include ~inc:PovInc.Colors);
  print_string (Pov.get_background ~color:bg_color);
  print_string (Pov.get_camera ~location:(2., 3., 4.) ~look_at:(0., 0.66, 0.) ());
  print_string (Pov.get_light_source ~location:(3.0, 4.0, 6.0) ~color:light_color);

  print_string (PovMeshC.get_mesh ~triangles ());
;;

