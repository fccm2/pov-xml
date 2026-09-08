module Pov = Povray
module PovCol = Pov.Color
module PovCam = Pov.Camera

let () =
  print_string (Pov.get_background ~color:(PovCol.RGB(0.2, 0.4, 0.8)));
  print_string (Pov.get_light_source ~location:(24., 24., -100.) ~color:(PovCol.RGB(1.0, 1.0, 1.0)));
  print_string (Pov.get_camera ~location:(0.0, 2.8, -6.0) ~look_at:(0.0, 0.5, 0.0) ~kind:PovCam.Fisheye ());

  let texture = Pov.get_texture ~color:(PovCol.RGBT(0.2, 0.2, 1.0, 0.0)) () in
  print_string (Pov.get_box
    ~translate:(0.0, 0.0, 0.0)
    ~rotate:(0.0, 20.0, 0.0)
    ~scale:(1.0, 1.0, 1.0)
    ~corner1:(0.0, 0.0, 0.0)
    ~corner2:(1.2, 1.8, 1.2)
    ~texture ());
;;

