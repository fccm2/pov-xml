module Pov = Povray
module PovColor = Pov.Color
module PovMesh = Pov.Mesh
module PovMeshC = Pov.MeshC
module PovCol = PovColor
module PovDesc = Pov.Desc

let () = Random.self_init ()

let bg_color = PovColor.RGB(0.2, 0.1, 0.4)

let light_color1 = PovColor.RGB(0.6, 0.6, 0.6)
let light_color2 = PovColor.RGB(0.4, 0.4, 0.4)

let cam_loc = (1.8, 4.8, 2.4)
let look_at = (0.0, 0.6, 0.0)

let mesh_color = PovColor.RGB(0.8, 0.6, 0.2)
let box_color = PovColor.RGB(1.0, 1.0, 1.0)

let box_color2 = PovColor.RGB(0.1, 0.9, 0.1)  (* green *)
let box_color3 = PovColor.RGB(0.6, 0.1, 0.0)

let rand_num a b =
  a + (Random.int (b - a + 1))

let _scale v = (v, v, v)

let () =
  let sc = Pov.new_scene () in
  let sc = Pov.add_include sc ~inc:Colors in
  let sc = Pov.add_background sc ~color:bg_color in
  let sc = Pov.add_camera sc ~location:cam_loc ~look_at () in

  let sc = Pov.add_light_source sc ~location:(3.0, 5.0,  4.0) ~color:light_color1 in
  let sc = Pov.add_light_source sc ~location:(3.0, 5.0, -4.0) ~color:light_color2 in

  let sc = Pov.add_ambient_light sc ~color:(0.2, 0.1, 0.3) in

  let texture =
    let color1 = PovColor.RGB(0.6, 0.2, 0.1) in
    let color2 = PovColor.RGB(0.6, 0.1, 0.2) in
    Pov.new_checker ~color1 ~color2 ()
  in
  let sc = Pov.add_plane sc ~norm:(0, 1, 0) ~dist:(0) ~texture () in

  let triangles = [
    ( (-0.8, 0.8, -0.8), (0.8, 0.8, -0.8), (0.8, 0.8, 0.8) );     (* top side *)
    ( (-0.8, 0.8, -0.8), (-0.8, 0.8, 0.8), (0.8, 0.8, 0.8) );

    ( (-0.8, -0.8, -0.8), (-0.8, -0.8, 0.8), (-0.8, 0.8, 0.8) );  (* left side *)
    ( (-0.8, -0.8, -0.8), (-0.8, 0.8, -0.8), (-0.8, 0.8, 0.8) );

    ( (0.8, -0.8, -0.8), (0.8, -0.8, 0.8), (0.8, 0.8, 0.8) );     (* right side *)
    ( (0.8, -0.8, -0.8), (0.8, 0.8, -0.8), (0.8, 0.8, 0.8) );

    ( (-0.8, -0.8, -0.8), (0.8, -0.8, -0.8), (-0.8, 0.8, -0.8) ); (* front side *)
    ( (-0.8, 0.8, -0.8), (0.8, 0.8, -0.8), (0.8, -0.8, -0.8) );

    ( (-0.8, -0.8, 0.8), (0.8, -0.8, 0.8), (-0.8, 0.8, 0.8) );    (* back side *)
    ( (-0.8, 0.8, 0.8), (0.8, 0.8, 0.8), (0.8, -0.8, 0.8) );
  ] in

  let mesh_color = PovColor.RGB(0.6, 0.7, 0.8) in
  let texture = Pov.new_texture ~color:mesh_color () in
  let sc = PovMesh.add_mesh sc ~triangles ~texture () in

  (* box *)
  let texture = Pov.new_texture ~color:box_color () in
  let sc = Pov.add_box sc
    ~corner1:(0.0, 0.2, 0.2)
    ~corner2:(0.2, 0.0, 0.0)
    ~translate:( 2.2, 0.0, -0.4)
    ~scale:(_scale 0.6)
    ~texture ()
  in

  (* boxes *)
  let _sc = ref sc in
  for _ = 1 to pred 36 do
    let x = (float (rand_num 10 34)) /. 10.0 in
    let y = 0.0 in
    let z = (float (rand_num  8 24)) /. 10.0 in
    let translate = (x, y, z -. 1.0) in
    let sc = !_sc in
    let sc = Pov.add_box sc
      ~corner1:(0.0, 0.2, 0.2)
      ~corner2:(0.2, 0.0, 0.0)
      ~translate
      ~scale:(_scale 0.6)
      ~texture ()
    in
    _sc := sc;
  done;
  let sc = !_sc in

  (* box-2 *)
  let texture = Pov.new_texture ~color:box_color2 () in
  let sc = Pov.add_box sc
    ~corner1:(0.0, 0.5, 0.3)
    ~corner2:(0.3, 0.0, 0.0)
    ~translate:( 2.26, 0.24, -1.66)
    ~scale:(_scale 0.62)
    ~texture ()
  in

  (* box-3 *)
  let texture = Pov.new_texture ~color:box_color3 () in
  let sc = Pov.add_box sc
    ~corner1:(0.0, 0.1, 0.6)
    ~corner2:(0.6, 0.0, 0.0)
    ~translate:( 2.1, 0.1, -1.8)
    ~scale:(_scale 0.8)
    ~texture ()
  in

  (* box-4 *)
  let texture = Pov.new_texture ~color:box_color () in
  let sc = Pov.add_box sc
    ~corner1:(0.0, 0.1, 0.8)
    ~corner2:(0.8, 0.0, 0.0)
    ~translate:( 2.0, 0.0, -1.8)
    ~scale:(_scale 0.8)
    ~texture ()
  in

  (* ( (triangle, color) list ) *)
  let p1 = (-0.6, 0.0,  0.2)  in
  let p2 = ( 0.0, 0.0, -0.8)  in
  let p3 = ( 0.6, 0.0,  0.2)  in
  let p4 = ( 0.0, 0.0,  1.2)  in
  let p5 = (-1.2, 0.0,  1.2)  in
  let p6 = ( 1.2, 0.0,  1.2)  in
  let col1 = PovColor.RGB(0.86, 0.84, 0.82) in
  let col2 = PovColor.RGB(0.64, 0.63, 0.61) in
  let triangles2 = [
    ((p1, p2, p3), col1);
    ((p1, p4, p3), col2);
    ((p1, p4, p5), col1);
    ((p3, p4, p6), col1);
  ] in

  let translate = Some (0.0, 2.6, 0.0) in
  let rotate, scale = (None, Some (_scale 0.66)) in
  let sc =
    PovDesc.add_descs sc [
      Pov.MeshC (triangles2, translate, rotate, scale);
    ]
  in

  let ct1, ct2, ct3, ct4 =
    let color1 = PovColor.RGB(0.1, 0.1, 0.1) in
    let color2 = PovColor.RGB(1.0, 0.1, 0.1) in
    let color3 = PovColor.RGB(0.1, 0.1, 1.0) in
    let color4 = PovColor.RGB(0.1, 1.0, 0.1) in
    let color5 = PovColor.RGB(1.0, 1.0, 0.1) in
    ( Pov.new_checker ~color1 ~color2:color2 (),
      Pov.new_checker ~color1 ~color2:color3 (),
      Pov.new_checker ~color1 ~color2:color4 (),
      Pov.new_checker ~color1 ~color2:color5 () )
  in
  let sph_color = PovColor.RGB(0.02, 0.02, 0.02) in
  let texture = Pov.new_texture ~color:sph_color () in
  let sc =
    Pov.add_sphere sc 
      ~radius:0.8
      ~center:(0.0, 0.0, 0.0)
      ~translate:(-2.9, 0.0,  0.6)
      ~rotate:(0.0, 0.0, 0.0)
      ~scale:(_scale 0.2)
      ~texture ()
  in
  let sc =
    Pov.add_sphere sc 
      ~radius:0.8
      ~center:(0.0, 0.0, 0.0)
      ~translate:(-2.2, 0.0,  0.8)
      ~rotate:(0.0, 0.0, 0.0)
      ~scale:(_scale 0.2)
      ~texture ()
  in
  let sc =
    Pov.add_sphere sc 
      ~radius:0.8
      ~center:(0.0, 0.0, 0.0)
      ~translate:(-2.4, 0.0,  0.2)
      ~rotate:(0.0, 0.0, 0.0)
      ~scale:(_scale 0.2)
      ~texture ()
  in
  let sc =
    Pov.add_sphere sc 
      ~radius:0.76
      ~center:(0.0, 0.0, 0.0)
      ~translate:(-3.26, 0.0, -0.46)
      ~rotate:(0.0, 0.0, 0.0)
      ~scale:(_scale 0.19)
      ~texture ()
  in

  let sc =
    Pov.add_sphere sc 
      ~radius:1.2
      ~center:(0.0, 0.0, 0.0)
      ~translate:(-4.3, 0.0,  0.3)
      ~rotate:(0.0, 0.0, 0.0)
      ~scale:(_scale 0.66)
      ~texture:ct1 ()
  in
  let sc =
    Pov.add_sphere sc 
      ~radius:0.8
      ~center:(0.0, 0.0, 0.0)
      ~translate:(-2.0, 0.0, -0.4)
      ~rotate:(0.0, 0.0, 0.0)
      ~scale:(_scale 0.56)
      ~texture:ct2 ()
  in
  let sc =
    Pov.add_sphere sc 
      ~radius:0.6
      ~center:(0.0, 0.0, 0.0)
      ~translate:( 1.0, 0.0, -1.9)
      ~rotate:(0.0, 0.0, 0.0)
      ~scale:(_scale 0.46)
      ~texture:ct3 ()
  in
  let sc =
    Pov.add_sphere sc 
      ~radius:0.6
      ~center:(0.0, 0.0, 0.0)
      ~translate:( 1.4, 0.0, -2.6)
      ~rotate:(0.0, 0.0, 0.0)
      ~scale:(_scale 0.31)
      ~texture:ct4 ()
  in

  let texture = Pov.get_texture ~color:box_color () in
  let elem =
    let elem1 =
      (Pov.get_box
         ~corner1:(0.0, 0.2, 0.8)
         ~corner2:(0.8, 0.0, 0.0)
         ~translate:(-2.2, 0.0,  1.2) ())
    in
    List.fold_left (fun elem1 elem2 ->
      Pov.get_difference ~elem1 ~elem2 ~texture ()
    ) elem1 [
      (Pov.get_box
         ~corner1:(0.0, 0.1, 0.4)
         ~corner2:(0.4, 0.3, 0.0)
         ~translate:(-2.4, 0.0,  1.0) ());

      (Pov.get_box
         ~corner1:(0.0, 0.1, 0.4)
         ~corner2:(0.4, 0.3, 0.0)
         ~translate:(-1.6, 0.0,  1.0) ());

      (Pov.get_box
         ~corner1:(0.0, 0.1, 0.4)
         ~corner2:(0.4, 0.3, 0.0)
         ~translate:(-1.6, 0.0,  1.8) ());

      (Pov.get_box
         ~corner1:(0.0, 0.1, 0.4)
         ~corner2:(0.4, 0.3, 0.0)
         ~translate:(-2.4, 0.0,  1.8) ());
    ]
  in
  let sc = Pov.add_elem sc ~elem () in

  let texture = Pov.new_texture ~color:box_color2 () in
  let sc =
    Pov.add_box sc
      ~corner1:(0.0, 0.3, 0.1)
      ~corner2:(0.1, 0.2, 0.0)
      ~translate:(-2.2, 0.0,  1.2)
      ~texture ()
  in
  let texture = Pov.new_texture ~color:box_color3 () in
  let sc =
    Pov.add_box sc
      ~corner1:(0.0, 0.3, 0.1)
      ~corner2:(0.1, 0.2, 0.0)
      ~translate:(-2.2, 0.0,  1.8)
      ~texture ()
  in
  let texture = Pov.new_texture ~color:box_color2 () in
  let sc =
    Pov.add_box sc
      ~corner1:(0.0, 0.3, 0.1)
      ~corner2:(0.1, 0.2, 0.0)
      ~translate:(-1.6, 0.0,  1.8)
      ~texture ()
  in
  let texture = Pov.new_texture ~color:box_color3 () in
  let sc =
    Pov.add_box sc
      ~corner1:(0.0, 0.3, 0.1)
      ~corner2:(0.1, 0.2, 0.0)
      ~translate:(-1.6, 0.0,  1.2)
      ~texture ()
  in

  Pov.print_scene sc;
;;

