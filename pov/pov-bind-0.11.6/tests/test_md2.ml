module Pov = Povray
module PovMeshD2 = Pov.MeshD2
module PovInc = Pov.Inc_file
module PovCol = Pov.Color

let () =
  print_string (Pov.get_include ~inc:PovInc.Colors);
  print_string (Pov.get_background ~color:(PovCol.RGB(0.2, 0.4, 0.8)));
  print_string (Pov.get_light_source ~location:(2., 4., -3.) ~color:(PovCol.RGB(1.0, 1.0, 1.0)));
  print_string (Pov.get_camera ~location:(2.0, 1.0, -2.4) ~look_at:(0., 1., 2.) ());

  let texture = Pov.get_texture ~color:(PovCol.RGBT(1.0, 0.0, 0.0, 0.0)) () in
  print_string (Pov.get_sphere ~center:(0.0, 2.0, 2.0) ~radius:0.8 ~texture ());

  let texture1 = Pov.new_texture ~color:PovCol.Black () in
  let texture2 = Pov.new_texture ~color:PovCol.Yellow () in
  print_string (
    PovMeshD2.get_mesh
      ~points:[|
        (0.0, 0.0, 0.0);
        (0.5, 0.0, 0.0);
        (0.5, 0.5, 0.0);
        (1.0, 0.0, 0.0);
        (1.0, 0.5, 0.0);
        (1.0, 1.0, 0.0);
        (0.5, 1.0, 0.0);
        (0.0, 1.0, 0.0);
        (0.0, 0.5, 0.0);
      |]
      ~faces:[|
        (0, 1, 2), 0;
        (1, 3, 2), 1;
        (3, 4, 2), 0;
        (4, 5, 2), 1;
        (5, 6, 2), 0;
        (6, 7, 2), 1;
        (7, 8, 2), 0;
        (8, 0, 2), 1;
      |]
      ~textures:[|
        texture1;
        texture2;
      |]
      ~translate:(0.0, 0.0, 0.0)
      ~rotate:(0.0, 0.0, 0.0)
      ~scale:(0.0, 0.0, 0.0)
    ());
;;

