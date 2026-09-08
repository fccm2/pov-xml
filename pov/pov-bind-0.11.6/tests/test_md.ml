module Pov = Povray
module PovMeshD = Pov.MeshD
module PovInc = Pov.Inc_file
module PovCol = Pov.Color

let () =
  print_string (Pov.get_include ~inc:PovInc.Colors);
  print_string (Pov.get_background ~color:(PovCol.RGB(0.2, 0.4, 0.8)));
  print_string (Pov.get_light_source ~location:(2., 4., -3.) ~color:(PovCol.RGB(1.0, 1.0, 1.0)));
  print_string (Pov.get_camera ~location:(2.0, 1.0, -2.4) ~look_at:(0., 1., 2.) ());

  let texture = Pov.get_texture ~color:(PovCol.RGBT(1.0, 0.8, 0.8, 0.5)) () in
  print_string (Pov.get_sphere ~center:(0.0, 2.0, 2.0) ~radius:0.8 ~texture ());

  let texture = Pov.new_texture ~color:PovCol.Cyan () in
  print_string (
    PovMeshD.get_mesh ~texture
      ~points:[|
        (0.0, 0.0, 0.1);
        (0.7, 0.0, 0.0);
        (0.7, 0.7, 0.1);
        (0.7, 0.0, 0.0);
        (1.0, 0.0, 0.2);
        (0.7, 0.7, 0.0);
        (1.0, 0.0, 0.1);
        (1.0, 0.7, 0.2);
        (0.7, 0.7, 0.0);
        (1.0, 0.7, 0.1);
        (1.0, 1.0, 0.1);
        (0.7, 0.7, 0.3);
        (1.0, 1.0, 0.2);
        (0.7, 1.0, 0.0);
        (0.7, 0.7, 0.1);
        (0.7, 1.0, 0.3);
        (0.0, 1.0, 0.2);
        (0.7, 0.7, 0.2);
        (0.0, 1.0, 0.1);
        (0.0, 0.7, 0.0);
        (0.7, 0.7, 0.1);
        (0.0, 0.7, 0.3);
        (0.0, 0.0, 0.0);
        (0.7, 0.7, 0.2);
      |]
      ~faces:[|
        (0, 1, 2);
        (3, 4, 5);
        (6, 7, 8);
        (9, 10, 11);
        (12, 13, 14);
        (15, 16, 17);
        (18, 19, 20);
        (21, 22, 23);
      |]
      ~translate:(0.0, 0.0, 0.0)
      ~rotate:(0.0, 0.0, 0.0)
      ~scale:(0.0, 0.0, 0.0)
    ());
;;

