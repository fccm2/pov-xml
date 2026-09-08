module Pov = Povray
module PovTextures = Pov.Textures
module PovInc = Pov.Inc_file
module PovColor = Pov.Color
module PovDesc = Pov.Desc

let () = Random.self_init ()

let cs1 = [| PovColor.Green; PovColor.Yellow; |]
let cs2 = [| PovColor.Red; PovColor.Blue; |]
let cs3 = [| PovColor.Cyan; PovColor.Magenta; |]

let cs =
  match Random.int 3 with
  | 0 -> cs1 | 1 -> cs2 | _ -> cs3

let get_color1 () = PovColor.Green
let get_color2 () =
  let n = Array.length cs in
  cs.(Random.int n)

let get_color3 () =
  let r = Random.float 1.0 in
  let g = Random.float 1.0 in
  let b = Random.float 1.0 in
  PovColor.RGB(r, g, b)

let get_color =
  match Random.int 3 with
  | 0 -> get_color1
  | 1 -> get_color2
  | _ -> get_color3

let rand_num a b =
  a + (Random.int (b - a + 1))

let ( @ ) a b =
  List.rev_append (List.rev a) b

let new_box ~i () =
  let color = get_color () in

  let x1 = (float (rand_num 0 20)) /. 10.0 in
  let z1 = (float (rand_num 0 20)) /. 10.0 in
  let y1 = (float (i)) /. 10.0 in

  let x2 = (float (rand_num 0 20)) /. 10.0 in
  let z2 = (float (rand_num 0 20)) /. 10.0 in
  let y2 = (float (i + 1)) /. 10.0 in

  let box_corner1 = (x1, y1, z1) in
  let box_corner2 = (x2, y2, z2) in
  let box_tex = Pov.new_texture ~color () in

  let translation = None in
  let rotation = None in
  let scale = None in

  Pov.Box (box_corner1, box_corner2, box_tex, translation, rotation, scale)


let () =
  let inc = PovInc.to_string ~inc:PovInc.Colors in
  let bg_color = PovColor.RGB(0.0, 0.1, 0.2) in
  let cam_loc, look_at = (0., 2., -3.), (0., 1., 2.) in
  let cam_kind = None in

  let light_loc = (2.0, 4.0, -3.0) in
  let light_color = PovColor.RGB(0.4, 0.5, 0.6) in

  let desc = [
    Pov.Include inc;
    Pov.Background bg_color;
    Pov.Light_source (light_loc, light_color);
    Pov.Camera (cam_loc, look_at, cam_kind);
    (* ... *)
  ] in

  let add_elems n desc =
    let rec aux i acc =
      if i <= 0 then acc else
      let this = new_box ~i () in
      aux (pred i) (this::acc)
    in
    let res = aux n [] in
    desc @ res
  in
  let desc = add_elems 26 desc in

  let scene = PovDesc.to_scene desc in

  Pov.print_scene scene;
;;

