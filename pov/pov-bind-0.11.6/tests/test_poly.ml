module Pov = Povray
module PovCol = Pov.Color

let () =
  print_string (Pov.get_background ~color:(PovCol.RGB(0.2, 0.4, 0.8)));
  print_string (Pov.get_light_source ~location:(24., 24., -100.) ~color:(PovCol.RGB(1.0, 1.0, 1.0)));
  print_string (Pov.get_camera ~location:(0.0, 0.0, -8.0) ~look_at:(0.0, 0.5, 0.0) ());

  let texture = Pov.get_texture ~color:(PovCol.RGBT(1.0, 0.0, 0.0, 0.0)) () in
  print_string (Pov.get_polygon
    ~translate:(0.0, 0.0, 0.0)
    ~pnts:[
      (0.45, 0.0);
      (0.30, 1.0);
      (0.40, 1.0);
      (0.55, 0.1);
      (0.70, 1.0);
      (0.80, 1.0);
      (0.65, 0.0);
      (0.45, 0.0);
    ]
    ~texture ());
;;

