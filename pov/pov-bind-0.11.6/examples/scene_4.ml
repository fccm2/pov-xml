module Pov = Povray
module PovInc = Pov.Inc_file
module PovTex = Pov.Textures
module PovColor = Pov.Color
module PovDesc = Pov.Desc

let () =
  let inc1 = PovInc.to_string ~inc:PovInc.Colors in
  let inc2 = PovInc.to_string ~inc:PovInc.Woods in

  let bg_color = PovColor.RGB(0.0, 0.1, 0.2) in

  let cam_loc, look_at = (0., 2., -3.), (0., 1., 2.) in
  let cam_kind = None in

  let light_loc = (2.0, 4.0, -3.0) in
  let light_color = PovColor.RGB(0.4, 0.5, 0.6) in

  let sphere_radius = 1.8 in
  let sphere_center = (0.0, 1.0, 2.0) in
  let sphere_tex = Pov.new_texture ~color:PovColor.Green () in

  let c_radius1 = 0.4 in
  let c_radius2 = 0.6 in
  let c_center1 = (0., 2., 0.) in
  let c_center2 = (2., 2., 3.) in
  let c_texture = Pov.new_texture ~def:(PovTex.Wood PovTex.Wood.T_Wood6) () in

  let translation = None in
  let rotation = None in
  let scale = None in

  let desc = [
    Pov.Include inc1;
    Pov.Include inc2;

    Pov.Background bg_color;

    Pov.Light_source (light_loc, light_color);
    Pov.Camera (cam_loc, look_at, cam_kind);

    Pov.Sphere (sphere_radius, sphere_center, sphere_tex, translation, rotation, scale);

    Pov.Cone (c_radius1, c_radius2, c_center1, c_center2, c_texture,
      translation, rotation, scale);

  ] in

  let scene = PovDesc.to_scene desc in

  Pov.print_scene scene;
;;

