module Pov = Povray

let () =
  print_string (Pov.get_background ~color:(RGB(0.2, 0.4, 0.8)));
  print_string (Pov.get_camera ~location:(0., 2., -3.) ~look_at:(0., 1., 2.) ());
  print_string (Pov.get_light_source ~location:(2., 4., -3.) ~color:(RGB(1.0, 1.0, 1.0)));

  let texture = Pov.get_texture ~color:(RGBT(1.0, 0.8, 0.8, 0.5)) () in
  print_string (Pov.get_sphere ~center:(0.0, 0.8, 2.0) ~radius:1.6 ~texture ());
  print_string (Pov.get_sphere ~center:(0.0, 2.0, 2.0) ~radius:0.8 ~texture ());
;;

