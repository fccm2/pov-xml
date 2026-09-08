module Pov = Povray
module PovColor = Pov.Color
module PovInc = Pov.Inc_file
module PovMesh = Pov.Mesh
module PovCol = PovColor
module PovDesc = Pov.Desc

let get_triangles1 s h = [
  ( (-. s, 0.0,    s), (0.0, h, 0.0), (   s, 0.0,    s) );
  ( (   s, 0.0,    s), (0.0, h, 0.0), (   s, 0.0, -. s) );
  ( (   s, 0.0, -. s), (0.0, h, 0.0), (-. s, 0.0, -. s) );
  ( (-. s, 0.0, -. s), (0.0, h, 0.0), (-. s, 0.0,    s) );
]

let get_triangles2 s h = [
  ( (-. s, 0.0,    s), (0.0, h, 0.0), (   s, 0.0,    s) );
  ( (   s, 0.0,    s), (0.0, h, 0.0), (   s, 0.0, -. s) );
  ( (   s, 0.0, -. s), (0.0, h, 0.0), (-. s, 0.0, -. s) );
  ( (-. s, 0.0, -. s), (0.0, h, 0.0), (-. s, 0.0,    s) );

  ( (-. s, 0.0, -. s), (0.0, -. h, 0.0), (   s, 0.0, -. s) );
  ( (-. s, 0.0,    s), (0.0, -. h, 0.0), (-. s, 0.0, -. s) );
  ( (   s, 0.0,    s), (0.0, -. h, 0.0), (-. s, 0.0,    s) );
  ( (   s, 0.0, -. s), (0.0, -. h, 0.0), (   s, 0.0,    s) );
]

let _scale v = (v, v, v)
let _scale2 (x, y, z) d = (x *. d, y *. d, z *. d)

let m0 = get_triangles2 0.5 1.6
let m3 = get_triangles2 0.4 1.6
let m1 = get_triangles2 0.8 1.5
let m2 = get_triangles1 0.2 1.0

let bg_color = PovColor.RGB(0.1, 0.1, 0.6)

let light_color1 = PovColor.RGB(0.8, 0.8, 0.8)
let light_color2 = PovColor.RGB(0.6, 0.6, 0.6)

let cam_loc = (2.2, 3.2, 2.8)
let look_at = (0.0, 0.6, 0.0)

let mesh_color = PovColor.RGB(0.8, 0.6, 0.2)
let mesh_color0 = PovColor.RGB(1.0, 0.0, 0.0)
let mesh_color1 = PovColor.RGB(0.1, 1.0, 0.0)
let mesh_color2 = PovColor.RGB(0.2, 0.4, 0.1)

let box_color = PovColor.RGB(0.8, 0.8, 0.76)
let sph_color = PovColor.RGB(1.0, 1.0, 0.0)

let tex_cyan = Pov.new_texture ~color:PovCol.Cyan ()

let () =
  let sc = Pov.new_scene () in
  let sc = Pov.add_include sc ~inc:PovInc.Colors in
  let sc = Pov.add_background sc ~color:bg_color in
  let sc = Pov.add_camera sc ~location:cam_loc ~look_at () in

  let sc = Pov.add_light_source sc ~location:(3.0, 5.0,  4.0) ~color:light_color1 in
  let sc = Pov.add_light_source sc ~location:(3.0, 5.0, -4.0) ~color:light_color2 in

  let sc = Pov.add_ambient_light sc ~color:(0.2, 0.1, 0.3) in

  let color1 = PovColor.RGB(0.1, 0.6, 0.2) in
  let color2 = PovColor.RGB(0.2, 0.6, 0.1) in
  let texture = Pov.new_checker ~color1 ~color2 () in
  let sc = Pov.add_plane sc ~norm:(0, 1, 0) ~dist:(0) ~texture () in

  let texture = Pov.new_texture ~color:mesh_color () in
  let sc =
    List.fold_left (fun sc (translate, scale) ->
      PovMesh.add_mesh sc ~triangles:m1 ~texture ~translate ~scale ()
    ) sc [
      ( 0.0, 1.0,  0.0), (_scale 0.55);
      ( 1.8, 1.4, -1.4), (_scale 0.12);
      ( 1.2, 1.4, -2.2), (_scale 0.12);
      ( 0.6, 1.4, -1.6), (_scale 0.12);
    ]
  in

  let f1 = Pov.new_finish ~ambient:0.8 () in
  let f2 = Pov.new_finish ~diffuse:0.8 () in
  (*
  ~diffuse:0.8
  ~specular:0.8
  *)
  let t1 = Pov.new_texture ~color:mesh_color0 ~finish:f1 () in
  let t2 = Pov.new_texture ~color:mesh_color1 ~finish:f2 () in
  let sc =
    List.fold_left (fun sc (translate, scale) ->
      let _abv (x, y, z) = (x, y +. 0.6, z) in
      let tr = _abv translate in
      let s2 = _scale2 scale 1.2 in  (* red-n-green *)
      let sc = PovMesh.add_mesh sc ~triangles:m0 ~texture:t1 ~translate ~scale () in
      let sc = PovMesh.add_mesh sc ~triangles:m3 ~texture:t2 ~translate:tr ~scale:s2 () in
      (sc)
    ) sc [
      ( 1.8, 0.23, -0.2), (_scale 0.16);
      ( 2.2, 0.23,  0.2), (_scale 0.16);
      ( 1.6, 0.23,  0.6), (_scale 0.16);
    ]
  in

  let texture = Pov.new_texture ~color:mesh_color2 () in
  let sc =
    List.fold_left (fun sc (translate, rotate) ->
      PovMesh.add_mesh sc ~triangles:m2 ~texture ~translate ~rotate ()
    ) sc [
      (-1.0, 0.0, -2.0), (0.0, 0.0, 0.0);
      (-2.0, 0.0, -1.0), (0.0, 0.0, 0.0);
      (-2.4, 0.0,  0.4), (0.0, 0.0, 0.0);
      (-1.9, 0.0,  1.7), (0.0, 0.0, 0.0);
    ]
  in
  let texture = Pov.new_texture ~color:box_color () in
  let sc = Pov.add_sphere sc
    ~center:(-0.8, 2.4,  1.5)
    ~radius:0.2 ~texture ()
  in
  let texture = Pov.new_texture ~color:sph_color () in
  let sc = Pov.add_sphere sc
    ~center:(-0.8, 0.1,  1.5)
    ~radius:0.1 ~texture ()
  in
  let rec aux i sc =
    if i <= 0 then sc else
      aux (pred i) (
        let rand v d =
          let r = (float (Random.int d)) /. 10.0  in
          v +. (if Random.bool () then -. r else r)
        in
        let x, z =
          (rand ( 0.2) 6,
           rand ( 1.5) 6)
        in
        Pov.add_sphere sc
          ~center:(x, 0.0, z)
          ~radius:0.1 ~texture ()
      )
  in
  let sc = aux 12 sc in

  let rec aux i sc =
    if i <= 0 then sc else
      aux (pred i) (
        let rand v d =
          let r = (float (Random.int d)) /. 10.0  in
          v +. (if Random.bool () then -. r else r)
        in
        let x, z =
          (rand (-3.6) 18,
           rand (-3.8) 18)
        in
        Pov.add_sphere sc
          ~center:(x, 0.0, z)
          ~radius:0.08 ~texture:t2 ()
      )
  in
  let sc = aux 38 sc in

  let texture = Pov.new_texture ~color:box_color () in
  let corner1 = (0.0, 0.3, 0.2) in
  let corner2 = (0.2, 0.0, 0.0) in
  let translate1 = (-0.6, 0.0, -2.8) in
  let translate2 = (-0.2, 0.0, -3.0) in
  let desc = [
    Pov.Box (corner1, corner2, texture, Some translate1, None, None);
    Pov.Box (corner1, corner2, texture, Some translate2, None, None);
  ] in
  let sc = PovDesc.add_descs sc desc in

  Pov.print_scene sc;
;;

