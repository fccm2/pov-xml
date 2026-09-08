(* Copyright (C) 2023, 2024 Florent Monnier
 *
 * This software is provided "AS-IS", without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to modify it and redistribute it freely.
 *)
(*
 * https://www.povray.org/documentation/3.7.0/r3_0.html
 * /usr/share/doc/povray
 *)

type location = float * float * float

module Camera = struct
type t =
  | Perspective
  | Orthographic
  | Fisheye
end

module Color = struct
type t =
  | Red
  | Green
  | Blue
  | Yellow
  | White
  | Black
  | Cyan
  | Pink
  | Magenta
  | RGB of float * float * float
  | RGBT of float * float * float * float
end
type color = Color.t


type triangle = location * location * location
type triangle_c = triangle * Color.t

type uv = float * float
type triangle_2d = uv * uv * uv
type triangle_uv = triangle * triangle_2d

type face_indice = int * int * int
type face_indices = face_indice array


type texture = string
type finish = string


type scene_desc =
  | Include of string
  | Background of color
  | Light_source of location * color
  | Ambient_light of float * float * float
  | Camera of location * location * Camera.t option

  | Sphere of float * location * texture * location option * location option * location option
    (* radius / center / texture / translate / rotate / scale *)

  | Cone of float * float * location * location * texture * location option * location option * location option
    (* radius1 / radius2 / center1 / center2 / texture / translate / rotate / scale *)

  | Box of location * location * texture * location option * location option * location option
    (* corner1 / corner2 / texture / translate / rotate / scale *)

  | Cylinder of float * location * location * texture * location option * location option * location option
    (* radius / center1 / center2 / texture / translate / rotate / scale *)

  | Torus of float * float * texture * location option * location option * location option
    (* major / minor / texture / translate / rotate / scale *)

  | Mesh of triangle list * texture * location option * location option * location option
    (* triangles / texture / translate / rotate / scale *)

  | MeshC of (triangle * color) list * location option * location option * location option
    (* (triangles / colors) / translate / rotate / scale *)

  | MeshD of location array * face_indice array * texture * location option * location option * location option
    (* points / faces / texture / translate / rotate / scale *)

  | MeshD2 of location array * (face_indice * int) array * texture array * location option * location option * location option
    (* points / faces / textures / translate / rotate / scale *)

  | MeshUV of triangle_uv list * string * location option * location option * location option
    (* triangles + uv / image-file-name / translate / rotate / scale *)



type scene = string list * string list


let new_scene () =
  ([], [])

let string_of_scene (scene, includes) =
  let scene = List.rev scene in
  let includes = List.rev includes in
  (String.concat "" includes) ^
  (String.concat "" scene)

let print_scene sc =
  print_string (string_of_scene sc)


(* inc-files *)

module Inc_file = struct
type t =
  | Arrays
  | Chars
  | Colors
  | Consts
  | Debug
  | Finish
  | Functions
  | Glass
  | Glass_old
  | Golds
  | Logo
  | Math
  | Metals
  | Rad_def
  | Rand
  | Textures
  | Transforms
  | Screen
  | Shapes
  | Shapes2
  | Shapes_old
  | Shapesq
  | Skies
  | Stage1
  | Stars
  | Stdcam
  | Stdinc
  | Stoneold
  | Stones
  | Stones1
  | Stones2
  | Strings
  | Sunpos
  | Woodmaps
  | Woods


let to_string ~inc = match inc with
  | Arrays     -> "arrays"
  | Chars      -> "chars"
  | Colors     -> "colors"
  | Consts     -> "consts"
  | Debug      -> "debug"
  | Finish     -> "finish"
  | Functions  -> "functions"
  | Glass      -> "glass"
  | Glass_old  -> "glass_old"
  | Golds      -> "golds"
  | Logo       -> "logo"
  | Math       -> "math"
  | Metals     -> "metals"
  | Rad_def    -> "rad_def"
  | Rand       -> "rand"
  | Textures   -> "textures"
  | Transforms -> "transforms"
  | Screen     -> "screen"
  | Shapes     -> "shapes"
  | Shapes2    -> "shapes2"
  | Shapes_old -> "shapes_old"
  | Shapesq    -> "shapesq"
  | Skies      -> "skies"
  | Stage1     -> "stage1"
  | Stars      -> "stars"
  | Stdcam     -> "stdcam"
  | Stdinc     -> "stdinc"
  | Stoneold   -> "stoneold"
  | Stones     -> "stones"
  | Stones1    -> "stones1"
  | Stones2    -> "stones2"
  | Strings    -> "strings"
  | Sunpos     -> "sunpos"
  | Woodmaps   -> "woodmaps"
  | Woods      -> "woods"


let of_string ~inc = match inc with
  | "arrays"     -> Arrays
  | "chars"      -> Chars
  | "colors"     -> Colors
  | "consts"     -> Consts
  | "debug"      -> Debug
  | "finish"     -> Finish
  | "functions"  -> Functions
  | "glass"      -> Glass
  | "glass_old"  -> Glass_old
  | "golds"      -> Golds
  | "logo"       -> Logo
  | "math"       -> Math
  | "metals"     -> Metals
  | "rad_def"    -> Rad_def
  | "rand"       -> Rand
  | "textures"   -> Textures
  | "transforms" -> Transforms
  | "screen"     -> Screen
  | "shapes"     -> Shapes
  | "shapes2"    -> Shapes2
  | "shapes_old" -> Shapes_old
  | "shapesq"    -> Shapesq
  | "skies"      -> Skies
  | "stage1"     -> Stage1
  | "stars"      -> Stars
  | "stdcam"     -> Stdcam
  | "stdinc"     -> Stdinc
  | "stoneold"   -> Stoneold
  | "stones"     -> Stones
  | "stones1"    -> Stones1
  | "stones2"    -> Stones2
  | "strings"    -> Strings
  | "sunpos"     -> Sunpos
  | "woodmaps"   -> Woodmaps
  | "woods"      -> Woods
  | _ -> invalid_arg "Inc_file.of_string"
end

type inc_file = Inc_file.t

let string_of_inc_file = Inc_file.to_string
let inc_file_of_string = Inc_file.of_string


let get_include ~inc = Printf.sprintf "\
#include \"%s.inc\"\n"
  (string_of_inc_file ~inc)
;;

let add_include (scene, includes) ~inc =
  let inc = get_include ~inc in
  (scene, inc :: includes)


(* colors *)

let get_color ~color =
  match color with
  | Color.Red    -> "Red"
  | Color.Green  -> "Green"
  | Color.Blue   -> "Blue"
  | Color.Yellow -> "Yellow"
  | Color.White  -> "White"
  | Color.Black  -> "Black"
  | Color.Cyan   -> "Cyan"
  | Color.Pink   -> "Pink"
  | Color.Magenta -> "Magenta"
  | Color.RGB(r,g,b) -> Printf.sprintf "rgb='%g, %g, %g'" r g b
  | Color.RGBT(r,g,b,t) -> Printf.sprintf "rgbt='%g, %g, %g, %g'" r g b t
;;




(* env *)

let cam_kind ?kind () =
  let kind =
    match kind with
    | Some Camera.Perspective  -> "\n  perspective"
    | Some Camera.Orthographic -> "\n  orthographic"
    | Some Camera.Fisheye      -> "\n  fisheye"
    | None -> ""
  in
  (kind)


let cam_angle ?angle () =
  let angle =
    match angle with
    | Some a -> Printf.sprintf "\n  angle %d" a
    | None -> ""
  in
  (angle)

let get_camera ~location:(lx,ly,lz) ~look_at:(ax,ay,az) ?(kind) ?(angle) () =
  let knd = cam_kind ?kind () in
  let ang = cam_angle ?angle () in
  ignore knd; 
  ignore ang; 
  Printf.sprintf
  "<camera location='%g, %g, %g' look_at='%g, %g, %g' />\n"
     lx ly lz
     ax ay az ;
;;

let add_camera (scene, includes) ~location ~look_at ?kind ?angle () =
  let cam = get_camera ~location ~look_at ?kind ?angle () in
  (cam :: scene, includes)


let get_background ~color = Printf.sprintf "
  <background>
    <color %s />
  </background>
" (get_color ~color);
;;

let add_background (scene, includes) ~color =
  let bg = get_background ~color in
  (bg :: scene, includes)


let get_comment ~com = Printf.sprintf "
<!-- %s -->\n" com;
;;

let add_comment (scene, includes) ~com =
  let cm = get_comment ~com in
  (cm :: scene, includes)


let get_light_source ~location:(x,y,z) ~color = Printf.sprintf "
<light_source position='%g, %g, %g' %s />\n"
  x y z (get_color ~color);
;;

let add_light_source (scene, includes) ~location ~color =
  let li = get_light_source ~location ~color in
  (li :: scene, includes)

let get_ambient_light ~color:(r, g, b) = Printf.sprintf "
global_settings { ambient_light rgb <%g, %g, %g> }\n" r g b

let add_ambient_light (scene, includes) ~color =
  let ali = get_ambient_light ~color in
  (ali :: scene, includes)


(* texture *)
(* includes *)
(* assoc (inc-file / defined-textures) *)

module Textures = struct
module Wood = struct

(* Woods *)

type woods =
  (* textures defined in 'woods.inc' *)
  | P_WoodGrain1A | P_WoodGrain1B | P_WoodGrain2A | P_WoodGrain2B
  | P_WoodGrain3A | P_WoodGrain3B | P_WoodGrain4A | P_WoodGrain4B
  | P_WoodGrain5A | P_WoodGrain5B | P_WoodGrain6A | P_WoodGrain6B
  | P_WoodGrain7A | P_WoodGrain7B | P_WoodGrain8A | P_WoodGrain8B
  | P_WoodGrain9A | P_WoodGrain9B | P_WoodGrain10A | P_WoodGrain10B
  | P_WoodGrain11A | P_WoodGrain11B | P_WoodGrain12A | P_WoodGrain12B
  | P_WoodGrain13A | P_WoodGrain13B | P_WoodGrain14A | P_WoodGrain14B
  | P_WoodGrain15A | P_WoodGrain15B | P_WoodGrain16A | P_WoodGrain16B
  | P_WoodGrain17A | P_WoodGrain17B | P_WoodGrain18A | P_WoodGrain18B
  | P_WoodGrain19A | P_WoodGrain19B
  | T_Wood1 | T_Wood2 | T_Wood3 | T_Wood4 | T_Wood5
  | T_Wood6 | T_Wood7 | T_Wood8 | T_Wood9 | T_Wood10
  | T_Wood11 | T_Wood12 | T_Wood13 | T_Wood14 | T_Wood15 | T_Wood16 | T_Wood17 | T_Wood18
  | T_Wood19 | T_Wood20 | T_Wood21 | T_Wood22 | T_Wood23 | T_Wood24 | T_Wood25 | T_Wood26
  | T_Wood27 | T_Wood28 | T_Wood29 | T_Wood30 | T_Wood31 | T_Wood32 | T_Wood33 | T_Wood34
  | T_Wood35


let woods_inc = [
  (* textures defined in 'woods.inc' *)
  "P_WoodGrain1A"; "P_WoodGrain1B"; "P_WoodGrain2A"; "P_WoodGrain2B";
  "P_WoodGrain3A"; "P_WoodGrain3B"; "P_WoodGrain4A"; "P_WoodGrain4B";
  "P_WoodGrain5A"; "P_WoodGrain5B"; "P_WoodGrain6A"; "P_WoodGrain6B";
  "P_WoodGrain7A"; "P_WoodGrain7B"; "P_WoodGrain8A"; "P_WoodGrain8B";
  "P_WoodGrain9A"; "P_WoodGrain9B"; "P_WoodGrain10A"; "P_WoodGrain10B";
  "P_WoodGrain11A"; "P_WoodGrain11B"; "P_WoodGrain12A"; "P_WoodGrain12B";
  "P_WoodGrain13A"; "P_WoodGrain13B"; "P_WoodGrain14A"; "P_WoodGrain14B";
  "P_WoodGrain15A"; "P_WoodGrain15B"; "P_WoodGrain16A"; "P_WoodGrain16B";
  "P_WoodGrain17A"; "P_WoodGrain17B"; "P_WoodGrain18A"; "P_WoodGrain18B";
  "P_WoodGrain19A"; "P_WoodGrain19B";
  "T_Wood1"; "T_Wood2"; "T_Wood3"; "T_Wood4"; "T_Wood5";
  "T_Wood6"; "T_Wood7"; "T_Wood8"; "T_Wood9"; "T_Wood10";
  "T_Wood11"; "T_Wood12"; "T_Wood13"; "T_Wood14"; "T_Wood15"; "T_Wood16"; "T_Wood17"; "T_Wood18";
  "T_Wood19"; "T_Wood20"; "T_Wood21"; "T_Wood22"; "T_Wood23"; "T_Wood24"; "T_Wood25"; "T_Wood26";
  "T_Wood27"; "T_Wood28"; "T_Wood29"; "T_Wood30"; "T_Wood31"; "T_Wood32"; "T_Wood33"; "T_Wood34";
  "T_Wood35";
]

let woods_lst =
  (* textures defined in 'woods.inc' *)
  [ P_WoodGrain1A; P_WoodGrain1B; P_WoodGrain2A; P_WoodGrain2B;
    P_WoodGrain3A; P_WoodGrain3B; P_WoodGrain4A; P_WoodGrain4B;
    P_WoodGrain5A; P_WoodGrain5B; P_WoodGrain6A; P_WoodGrain6B;
    P_WoodGrain7A; P_WoodGrain7B; P_WoodGrain8A; P_WoodGrain8B;
    P_WoodGrain9A; P_WoodGrain9B; P_WoodGrain10A; P_WoodGrain10B;
    P_WoodGrain11A; P_WoodGrain11B; P_WoodGrain12A; P_WoodGrain12B;
    P_WoodGrain13A; P_WoodGrain13B; P_WoodGrain14A; P_WoodGrain14B;
    P_WoodGrain15A; P_WoodGrain15B; P_WoodGrain16A; P_WoodGrain16B;
    P_WoodGrain17A; P_WoodGrain17B; P_WoodGrain18A; P_WoodGrain18B;
    P_WoodGrain19A; P_WoodGrain19B;
    T_Wood1; T_Wood2; T_Wood3; T_Wood4; T_Wood5;
    T_Wood6; T_Wood7; T_Wood8; T_Wood9; T_Wood10;
    T_Wood11; T_Wood12; T_Wood13; T_Wood14; T_Wood15; T_Wood16; T_Wood17; T_Wood18;
    T_Wood19; T_Wood20; T_Wood21; T_Wood22; T_Wood23; T_Wood24; T_Wood25; T_Wood26;
    T_Wood27; T_Wood28; T_Wood29; T_Wood30; T_Wood31; T_Wood32; T_Wood33; T_Wood34;
    T_Wood35;
  ]

let assoc_woods_textures = List.combine woods_lst woods_inc

let to_string tx = (List.assoc tx assoc_woods_textures)

end


(* Stones *)
module Stone = struct

type stones =
  (* textures defined in 'stones1.inc' *)
  | T_Grnt0 | T_Grnt1 | T_Grnt2 | T_Grnt3 | T_Grnt4 | T_Grnt5 | T_Grnt6 | T_Grnt7 | T_Grnt8
  | T_Grnt9 | T_Grnt10 | T_Grnt11 | T_Grnt12 | T_Grnt13 | T_Grnt14 | T_Grnt15 | T_Grnt16
  | T_Grnt17 | T_Grnt18 | T_Grnt19 | T_Grnt20 | G1 | G2 | G3 | G4 | T_Grnt21 | T_Grnt22
  | T_Grnt23 | T_Grnt24 | T_Grnt25 | T_Grnt26 | T_Grnt27 | T_Grnt28 | T_Grnt29 | T_Grnt0a
  | T_Grnt1a | T_Grnt2a | T_Grnt3a | T_Grnt4a | T_Grnt5a | T_Grnt6a | T_Grnt7a | T_Grnt8a
  | T_Grnt9a | T_Grnt10a | T_Grnt11a | T_Grnt12a | T_Grnt13a | T_Grnt14a | T_Grnt15a | T_Grnt16a
  | T_Grnt17a | T_Grnt18a | T_Grnt19a | T_Grnt20a | T_Grnt21a | T_Grnt22a | T_Grnt23a | T_Grnt24a
  | T_Crack1 | T_Crack2 | T_Crack3 | T_Crack4 | T_Stone1 | T_Stone2 | T_Stone3 | T_Stone4
  | T_Stone5 | T_Stone6 | T_Stone7 | T_Stone8 | T_Stone9 | T_Stone10 | T_Stone11 | T_Stone12
  | T_Stone13 | T_Stone14 | T_Stone15 | T_Stone16 | T_Stone17 | T_Stone18 | T_Stone19 | T_Stone20
  | T_Stone21 | T_Stone22 | T_Stone23 | T_Stone24

  (* textures defined in 'stones2.inc' *)
  | T_Stone25 | T_Stone26 | T_Stone27 | T_Stone28 | T_Stone29 | T_Stone30 | T_Stone31 | T_Stone32
  | T_Stone33 | T_Stone34 | T_Stone35 | T_Stone36 | T_Stone37 | T_Stone38 | T_Stone39 | T_Stone40
  | T_Stone41 | T_Stone42 | T_Stone43 | T_Stone44


let stones_inc = [
  (* textures defined in 'stones1.inc' *)
  "T_Grnt0"; "T_Grnt1"; "T_Grnt2"; "T_Grnt3"; "T_Grnt4"; "T_Grnt5"; "T_Grnt6"; "T_Grnt7"; "T_Grnt8";
  "T_Grnt9"; "T_Grnt10"; "T_Grnt11"; "T_Grnt12"; "T_Grnt13"; "T_Grnt14"; "T_Grnt15"; "T_Grnt16";
  "T_Grnt17"; "T_Grnt18"; "T_Grnt19"; "T_Grnt20"; "g1"; "g2"; "g3"; "g4"; "T_Grnt21"; "T_Grnt22";
  "T_Grnt23"; "T_Grnt24"; "T_Grnt25"; "T_Grnt26"; "T_Grnt27"; "T_Grnt28"; "T_Grnt29"; "T_Grnt0a";
  "T_Grnt1a"; "T_Grnt2a"; "T_Grnt3a"; "T_Grnt4a"; "T_Grnt5a"; "T_Grnt6a"; "T_Grnt7a"; "T_Grnt8a";
  "T_Grnt9a"; "T_Grnt10a"; "T_Grnt11a"; "T_Grnt12a"; "T_Grnt13a"; "T_Grnt14a"; "T_Grnt15a"; "T_Grnt16a";
  "T_Grnt17a"; "T_Grnt18a"; "T_Grnt19a"; "T_Grnt20a"; "T_Grnt21a"; "T_Grnt22a"; "T_Grnt23a"; "T_Grnt24a";
  "T_Crack1"; "T_Crack2"; "T_Crack3"; "T_Crack4"; "T_Stone1"; "T_Stone2"; "T_Stone3"; "T_Stone4";
  "T_Stone5"; "T_Stone6"; "T_Stone7"; "T_Stone8"; "T_Stone9"; "T_Stone10"; "T_Stone11"; "T_Stone12";
  "T_Stone13"; "T_Stone14"; "T_Stone15"; "T_Stone16"; "T_Stone17"; "T_Stone18"; "T_Stone19"; "T_Stone20";
  "T_Stone21"; "T_Stone22"; "T_Stone23"; "T_Stone24";

  (* textures defined in 'stones2.inc' *)
  "T_Stone25"; "T_Stone26"; "T_Stone27"; "T_Stone28"; "T_Stone29"; "T_Stone30"; "T_Stone31"; "T_Stone32";
  "T_Stone33"; "T_Stone34"; "T_Stone35"; "T_Stone36"; "T_Stone37"; "T_Stone38"; "T_Stone39"; "T_Stone40";
  "T_Stone41"; "T_Stone42"; "T_Stone43"; "T_Stone44";
]


let stones_lst =
  (* textures defined in 'stones1.inc' *)
  [ T_Grnt0; T_Grnt1; T_Grnt2; T_Grnt3; T_Grnt4; T_Grnt5; T_Grnt6; T_Grnt7; T_Grnt8;
    T_Grnt9; T_Grnt10; T_Grnt11; T_Grnt12; T_Grnt13; T_Grnt14; T_Grnt15; T_Grnt16;
    T_Grnt17; T_Grnt18; T_Grnt19; T_Grnt20; G1; G2; G3; G4; T_Grnt21; T_Grnt22;
    T_Grnt23; T_Grnt24; T_Grnt25; T_Grnt26; T_Grnt27; T_Grnt28; T_Grnt29; T_Grnt0a;
    T_Grnt1a; T_Grnt2a; T_Grnt3a; T_Grnt4a; T_Grnt5a; T_Grnt6a; T_Grnt7a; T_Grnt8a;
    T_Grnt9a; T_Grnt10a; T_Grnt11a; T_Grnt12a; T_Grnt13a; T_Grnt14a; T_Grnt15a; T_Grnt16a;
    T_Grnt17a; T_Grnt18a; T_Grnt19a; T_Grnt20a; T_Grnt21a; T_Grnt22a; T_Grnt23a; T_Grnt24a;
    T_Crack1; T_Crack2; T_Crack3; T_Crack4; T_Stone1; T_Stone2; T_Stone3; T_Stone4;
    T_Stone5; T_Stone6; T_Stone7; T_Stone8; T_Stone9; T_Stone10; T_Stone11; T_Stone12;
    T_Stone13; T_Stone14; T_Stone15; T_Stone16; T_Stone17; T_Stone18; T_Stone19; T_Stone20;
    T_Stone21; T_Stone22; T_Stone23; T_Stone24;

    (* textures defined in 'stones2.inc' *)
    T_Stone25; T_Stone26; T_Stone27; T_Stone28; T_Stone29; T_Stone30; T_Stone31; T_Stone32;
    T_Stone33; T_Stone34; T_Stone35; T_Stone36; T_Stone37; T_Stone38; T_Stone39; T_Stone40;
    T_Stone41; T_Stone42; T_Stone43; T_Stone44;
  ]


(*
let stones1_lst =
  (* textures defined in 'stones1.inc' *)
  [ T_Grnt0; T_Grnt1; T_Grnt2; T_Grnt3; T_Grnt4; T_Grnt5; T_Grnt6; T_Grnt7; T_Grnt8;
    T_Grnt9; T_Grnt10; T_Grnt11; T_Grnt12; T_Grnt13; T_Grnt14; T_Grnt15; T_Grnt16;
    T_Grnt17; T_Grnt18; T_Grnt19; T_Grnt20; G1; G2; G3; G4; T_Grnt21; T_Grnt22;
    T_Grnt23; T_Grnt24; T_Grnt25; T_Grnt26; T_Grnt27; T_Grnt28; T_Grnt29; T_Grnt0a;
    T_Grnt1a; T_Grnt2a; T_Grnt3a; T_Grnt4a; T_Grnt5a; T_Grnt6a; T_Grnt7a; T_Grnt8a;
    T_Grnt9a; T_Grnt10a; T_Grnt11a; T_Grnt12a; T_Grnt13a; T_Grnt14a; T_Grnt15a; T_Grnt16a;
    T_Grnt17a; T_Grnt18a; T_Grnt19a; T_Grnt20a; T_Grnt21a; T_Grnt22a; T_Grnt23a; T_Grnt24a;
    T_Crack1; T_Crack2; T_Crack3; T_Crack4; T_Stone1; T_Stone2; T_Stone3; T_Stone4;
    T_Stone5; T_Stone6; T_Stone7; T_Stone8; T_Stone9; T_Stone10; T_Stone11; T_Stone12;
    T_Stone13; T_Stone14; T_Stone15; T_Stone16; T_Stone17; T_Stone18; T_Stone19; T_Stone20;
    T_Stone21; T_Stone22; T_Stone23; T_Stone24;
  ]

let stones2_lst = [
  (* textures defined in 'stones2.inc' *)
    T_Stone25; T_Stone26; T_Stone27; T_Stone28; T_Stone29; T_Stone30; T_Stone31; T_Stone32;
    T_Stone33; T_Stone34; T_Stone35; T_Stone36; T_Stone37; T_Stone38; T_Stone39; T_Stone40;
    T_Stone41; T_Stone42; T_Stone43; T_Stone44;
  ]
*)


(*
let textures_assoc =
  [ Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1; Inc_file.Stones1;
    Inc_file.Stones1; Inc_file.Stones1;

    Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2;
    Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2;
    Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2;
    Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2; Inc_file.Stones2;
  ]
*)


let assoc_stones_textures = List.combine stones_lst stones_inc
(*
let texture_assocs = List.combine stones_lst textures_assoc
*)

(*
let assoc_textures =
  let l1 = assoc_textures1 in
  let l2 = assoc_textures2 in
  List.rev_append (List.rev l1) l2
*)

let to_string tx = (List.assoc tx assoc_stones_textures)

end

module Metal = struct
(* Metal *)
type metals =
  | T_Brass_1A | T_Brass_1B | T_Brass_1C | T_Brass_1D | T_Brass_1E
  | T_Brass_2A | T_Brass_2B | T_Brass_2C | T_Brass_2D | T_Brass_2E
  | T_Brass_3A | T_Brass_3B | T_Brass_3C | T_Brass_3D | T_Brass_3E
  | T_Brass_4A | T_Brass_4B | T_Brass_4C | T_Brass_4D | T_Brass_4E
  | T_Brass_5A | T_Brass_5B | T_Brass_5C | T_Brass_5D | T_Brass_5E
  (* Coppers & Bronzes *)
  | T_Copper_1A | T_Copper_1B | T_Copper_1C | T_Copper_1D | T_Copper_1E
  | T_Copper_2A | T_Copper_2B | T_Copper_2C | T_Copper_2D | T_Copper_2E
  | T_Copper_3A | T_Copper_3B | T_Copper_3C | T_Copper_3D | T_Copper_3E
  | T_Copper_4A

let metals_inc = [
  (* textures defined in "metals.inc" *)
 "T_Brass_1A"; "T_Brass_1B"; "T_Brass_1C"; "T_Brass_1D"; "T_Brass_1E";
 "T_Brass_2A"; "T_Brass_2B"; "T_Brass_2C"; "T_Brass_2D"; "T_Brass_2E";
 "T_Brass_3A"; "T_Brass_3B"; "T_Brass_3C"; "T_Brass_3D"; "T_Brass_3E";
 "T_Brass_4A"; "T_Brass_4B"; "T_Brass_4C"; "T_Brass_4D"; "T_Brass_4E";
 "T_Brass_5A"; "T_Brass_5B"; "T_Brass_5C"; "T_Brass_5D"; "T_Brass_5E";
 "T_Copper_1A"; "T_Copper_1B"; "T_Copper_1C"; "T_Copper_1D"; "T_Copper_1E";
 "T_Copper_2A"; "T_Copper_2B"; "T_Copper_2C"; "T_Copper_2D"; "T_Copper_2E";
 "T_Copper_3A"; "T_Copper_3B"; "T_Copper_3C"; "T_Copper_3D"; "T_Copper_3E";
 "T_Copper_4A";
]

let metals_lst =
  (* textures defined in "metals.inc" *)
  [ T_Brass_1A; T_Brass_1B; T_Brass_1C; T_Brass_1D; T_Brass_1E;
    T_Brass_2A; T_Brass_2B; T_Brass_2C; T_Brass_2D; T_Brass_2E;
    T_Brass_3A; T_Brass_3B; T_Brass_3C; T_Brass_3D; T_Brass_3E;
    T_Brass_4A; T_Brass_4B; T_Brass_4C; T_Brass_4D; T_Brass_4E;
    T_Brass_5A; T_Brass_5B; T_Brass_5C; T_Brass_5D; T_Brass_5E;
    T_Copper_1A; T_Copper_1B; T_Copper_1C; T_Copper_1D; T_Copper_1E;
    T_Copper_2A; T_Copper_2B; T_Copper_2C; T_Copper_2D; T_Copper_2E;
    T_Copper_3A; T_Copper_3B; T_Copper_3C; T_Copper_3D; T_Copper_3E;
    T_Copper_4A;
  ]

let assoc_metals_textures = List.combine metals_lst metals_inc

let to_string tx = (List.assoc tx assoc_metals_textures)

end

type texture_def =
  | Stone of Stone.stones
  | Wood of Wood.woods
  | Metal of Metal.metals

let to_string tx =
  match tx with
  | Wood tx -> Wood.to_string tx
  | Stone tx -> Stone.to_string tx
  | Metal tx -> Metal.to_string tx

end


type normal = string

module Normal = struct
  type t = normal

  let normal_marble ~bump_depth ~scale ~turbulence = Printf.sprintf "
    normal { marble %g scale %g turbulence %g }\n" bump_depth scale turbulence ;;

  let normal_ripples ~bump_depth ~phase ~frequency = Printf.sprintf "
    normal { ripples %g phase %g frequency %g }\n" bump_depth phase frequency ;;

  let normal_agate ~bump_depth ~agate_turb ~scale = Printf.sprintf "
    normal { agate %g agate_turb %g scale %g }\n" bump_depth agate_turb scale ;;

  let normal_marble ~bump_depth ~scale ~turbulence = Printf.sprintf "
    normal { marble %g scale %g turbulence %g }\n" bump_depth scale turbulence ;;

  let normal_crackle ~size = Printf.sprintf "
    normal { facets size %g }\n" size ;;

  let normal_crackle ~bump_depth ~scale = Printf.sprintf "
    normal { crackle %g scale %g }\n" bump_depth scale ;;

  let normal_bozo ~bump_depth ~scale = Printf.sprintf "
    normal { bozo %g scale %g }\n" bump_depth scale ;;

  let normal_dents ~bump_depth ~scale = Printf.sprintf "
    normal { dents %g scale %g }\n" bump_depth scale ;;

  let normal_granite ~bump_depth ~scale = Printf.sprintf "
    normal { granite %g scale %g }\n" bump_depth scale ;;

  let normal_wrinkles ~bump_depth ~scale = Printf.sprintf "
    normal { wrinkles %g scale %g }\n" bump_depth scale ;;

  let normal_waves ~bump_depth ~scale = Printf.sprintf "
    normal { waves %g scale %g }\n" bump_depth scale ;;

  let string_of_normal s = s
end


let get_finish ?ambient ?diffuse ?specular () =
  let amb =
    match ambient with None -> ""
    | Some d -> Printf.sprintf "ambient %g" d
  in
  let dif =
    match diffuse with None -> ""
    | Some d -> Printf.sprintf "diffuse %g" d
  in
  let spe =
    match specular with None -> ""
    | Some d -> Printf.sprintf "specular %g" d
  in
  let prm = [ amb; dif; spe; ] in
  let prm = String.concat "" prm in
  Printf.sprintf "\n    finish { %s }\n" prm
;;


let _get_texture ?color ?scale ?def ?(normal="") ?(finish="") () =
  let s_color =
    match color with
    | None -> ""
    | Some color ->
        Printf.sprintf "<color %s />" (get_color ~color) ;
  in
  let s_scale =
    match scale with
    | Some scale -> Printf.sprintf " scale %d" scale
    | None -> ""
  in
  let s_def =
    match def with
    | None -> ("")
    | Some def ->
        let _def = Textures.to_string def in
        (" " ^ _def)
  in
  Printf.sprintf "

  <texture> %s %s
    <pigment>
      %s
    </pigment> %s %s
  </texture>
"    s_def s_scale s_color
     normal finish
;;


let get_texture ?color ?scale ?def ?normal ?finish () =
  _get_texture ?color ?scale ?def ?normal ?finish ()


let new_texture ?color ?scale ?def ?normal ?finish () =
  let tex = get_texture ?color ?scale ?def ?normal ?finish () in
  (tex)


let new_finish ?ambient ?diffuse ?specular () =
  let finish = get_finish ?ambient ?diffuse ?specular () in
  (finish)


(*

let add_texture (scene, includes) ?color ?scale ?def () =
  let tex = get_texture ?color ?scale ?def () in
  let inc =
    match def with None -> None
    | Some tex ->
        (*
        try let _ = List.assoc tex Textures.assoc_textures1 in Some (Inc_file.Stones1)
        with Not_found ->
        try let _ = List.assoc tex Textures.assoc_textures2 in Some (Inc_file.Stones2)
        with Not_found -> None
        *)
        if List.mem tex Textures.stones1_lst then Some (Inc_file.Stones1) else
        if List.mem tex Textures.stones2_lst then Some (Inc_file.Stones2) else
        None
  in
  let includes =
    match inc with
    | None -> (includes)
    | Some inc ->
        let inc = get_include ~inc in
        try let _ = List.mem inc includes in (includes)
        with Not_found ->
          (inc :: includes)
  in
  (tex :: scene, includes)
;;

*)


let get_checker ~color1 ~color2 ?scale ?(finish="") () =
  let c1 = match color1 with
  | color -> "color " ^ (get_color ~color) in
  let c2 = match color2 with
  | color -> "color " ^ (get_color ~color) in
  let sc = match scale with
  | None -> "" | Some s -> Printf.sprintf "\n      scale %g" s in
  Printf.sprintf "  \
  texture {
    pigment {
      checker %s, %s%s
    }%s
  }" c1 c2 sc finish
;;

let new_checker ~color1 ~color2 ?scale ?finish () =
  let checker = get_checker ~color1 ~color2 ?scale ?finish () in
  (checker)


let get_hexagon ~color1 ~color2 ~color3 ?scale ?(finish="") () =
  let c1 = match color1 with
  | color -> "color " ^ (get_color ~color) in
  let c2 = match color2 with
  | color -> "color " ^ (get_color ~color) in
  let c3 = match color3 with
  | color -> "color " ^ (get_color ~color) in
  let sc = match scale with
  | None -> "" | Some s -> Printf.sprintf "\n      scale %g" s in
  Printf.sprintf "  \
  texture {
    pigment {
      hexagon %s, %s, %s%s
    }%s
  }" c1 c2 c3 sc finish
;;

let new_hexagon ~color1 ~color2 ~color3 ?scale ?finish () =
  let hexagon = get_hexagon ~color1 ~color2 ~color3 ?scale ?finish () in
  (hexagon)


type pattern = [ `wrinkles | `waves | `ripples | `granite
  | `dents | `crackle | `bozo | `agate of float ]

let string_of_pattern = function
  | `wrinkles -> "wrinkles"
  | `waves      -> "waves"
  | `ripples    -> "ripples"
  | `granite    -> "granite"
  | `dents      -> "dents"
  | `crackle    -> "crackle"
  | `bozo       -> "bozo"
  | `agate turb -> Printf.sprintf "agate\n      agate_turb %g" turb


let get_color_pattern ~pat ~color_map ?scale ?(finish="") () =
  let sc = match scale with
  | None -> "" | Some s -> Printf.sprintf "\n      scale %g" s in
  let color_map = List.map (fun (stop, color) ->
    Printf.sprintf "        [ %g color %s ]\n" stop (get_color ~color)) color_map
  in
  let cm = String.concat "" color_map in
  Printf.sprintf "  \
  texture {
    pigment { %s
      color_map {
%s
      }%s
    }%s
  }" (string_of_pattern pat) cm sc finish
;;

let new_color_pattern ~pat ~color_map ?scale ?finish () =
  get_color_pattern ~pat ~color_map ?scale ?finish ()



(* primitives *)

(* geometry primitives *)

let get_sphere ~center:(x,y,z) ~radius ?(translate) ?(rotate) ?(scale) ?(texture="") () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate='%g, %g, %g'" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate='%g, %g, %g'" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale='%g, %g, %g'" x y z in
  Printf.sprintf "
<sphere position='%g, %g, %g' radius='%g'>
%s%s%s%s
</sphere>
\n" x y z radius texture
    scale rotate translate;
;;


let get_cone ~center1:(x1,y1,z1) ~radius1
             ~center2:(x2,y2,z2) ~radius2
             ?translate ?rotate ?scale ?(texture="") () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in
  Printf.sprintf "
cone {
  <%g, %g, %g>, %g
  <%g, %g, %g>, %g
%s%s%s%s
}\n" x1 y1 z1  radius1
     x2 y2 z2  radius2  texture
     scale rotate translate;
;;


let get_box ~corner1:(x1,y1,z1) ~corner2:(x2,y2,z2) ?(translate) ?(rotate) ?(scale) ?(texture="") () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in
  Printf.sprintf "
box {
  <%g, %g, %g>,
  <%g, %g, %g>
%s%s%s%s
}\n" x1 y1 z1
     x2 y2 z2 texture
     scale rotate translate;
;;


let get_cylinder ~center1:(x1,y1,z1) ~center2:(x2,y2,z2) ~radius
    ?translate ?rotate ?scale ?(texture="") () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in
  Printf.sprintf "
cylinder {
  <%g, %g, %g>,
  <%g, %g, %g>,
  %g%s%s%s%s
}\n" x1 y1 z1
     x2 y2 z2 radius texture
     scale rotate translate;
;;


let get_torus ~major ~minor ?(translate) ?(rotate) ?(scale) ?(texture="") () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in
  Printf.sprintf "
torus {
  %g, %g
%s%s%s%s
}\n" major minor
     texture scale rotate translate;
;;


let get_polygon ~pnts ?(translate) ?(rotate) ?(scale) ?(texture="") () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in
  let n = List.length pnts in
  let pnts = List.map (fun (x, y) -> Printf.sprintf ",\n  <%g, %g>" x y) pnts in
  let pnts = String.concat "" pnts in
  Printf.sprintf "
polygon {
  %d%s
%s%s%s%s
}\n" n pnts texture
     scale rotate translate;
;;


let get_plane ~norm:(x,y,z) ~dist:d ?(texture="") () =
  Printf.sprintf "
plane {
  <%d, %d, %d>, %d
%s
}\n" x y z d
     texture;
;;


let get_text ~font ~text ?(thickness=1.0) ?(offset=0.0)
    ?translate ?rotate ?scale ?(texture="") () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in
  Printf.sprintf {|
text {
  ttf "%s" "%s" %g, %g
%s%s%s%s
}
|} font text thickness offset texture
   scale rotate translate;
;;



(* group *)

let get_union ~group:s ?translate ?rotate ?scale () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in
  Printf.sprintf "
union {
%s%s%s%s
}\n" s
  scale rotate translate;
;;

let scene_to_string (scene) =
  let scene = List.rev scene in
  (String.concat "" scene)

let add_union (scene, includes) ~group:f ?translate ?rotate ?scale () =
  let _scene = [] in
  let _scene, includes = f (_scene, includes) in
  let s = scene_to_string _scene in
  let su = get_union ~group:s ?translate ?rotate ?scale () in
  (su :: scene, includes)



(* csg-diff *)

let get_difference ~elem1 ~elem2 ?(texture="") () =
  Printf.sprintf "
difference {
%s
%s
%s
}\n"
  elem1 elem2 texture;
;;

let add_difference (scene, includes) ~elem1 ~elem2 ?texture () =
  let diff = get_difference ~elem1 ~elem2 ?texture () in
  (diff :: scene, includes)

let add_elem (scene, includes) ~elem () =
  (elem :: scene, includes)


(* intersection *)

let get_intersection ~elem1 ~elem2 ?(texture="") () =
  Printf.sprintf "
intersection {
%s
%s
%s
}\n"
  elem1 elem2 texture;
;;

let add_intersection (scene, includes) ~elem1 ~elem2 ?texture () =
  let diff = get_intersection ~elem1 ~elem2 ?texture () in
  (diff :: scene, includes)



(* add's *)

let add_sphere (scene, includes) ~center ~radius ?translate ?rotate ?scale ?texture () =
  let sphere = get_sphere ~center ~radius ?translate ?rotate ?scale ?texture () in
  (sphere :: scene, includes)

let add_cone (scene, includes) ~center1 ~radius1 ~center2 ~radius2 ?translate ?rotate ?scale ?texture () =
  let cone = get_cone ~center1 ~radius1 ~center2 ~radius2 ?translate ?rotate ?scale ?texture () in
  (cone :: scene, includes)

let add_box (scene, includes) ~corner1 ~corner2 ?translate ?rotate ?scale ?texture () =
  let box = get_box ~corner1 ~corner2 ?translate ?rotate ?scale ?texture () in
  (box :: scene, includes)

let add_cylinder (scene, includes) ~center1 ~center2 ~radius ?translate ?rotate ?scale ?texture () =
  let cylinder = get_cylinder ~center1 ~center2 ~radius ?translate ?rotate ?scale ?texture () in
  (cylinder :: scene, includes)

let add_torus (scene, includes) ~major ~minor ?translate ?rotate ?scale ?texture () =
  let torus = get_torus ~major ~minor ?translate ?rotate ?scale ?texture () in
  (torus :: scene, includes)

let add_polygon (scene, includes) ~pnts ?translate ?rotate ?scale ?texture () =
  let polygon = get_polygon ~pnts ?translate ?rotate ?scale ?texture () in
  (polygon :: scene, includes)

let add_plane (scene, includes) ~norm ~dist ?texture () =
  let plane = get_plane ~norm ~dist ?texture () in
  (plane :: scene, includes)

let add_text (scene, includes) ~font ~text ?thickness ?offset ?translate ?rotate ?scale ?texture () =
  let text = get_text ~font ~text ?thickness ?offset ?translate ?rotate ?scale ?texture () in
  (text :: scene, includes)




module Mesh = struct

let get_mesh ~triangles ?(translate) ?(rotate) ?(scale) ?(texture="") () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in
  let triangle_to_string (x, y, z) = (Printf.sprintf "<%g, %g, %g>" x y z) in
  let triangles =
    List.map (fun (a, b, c) ->
      ( triangle_to_string a,
        triangle_to_string b,
        triangle_to_string c
      )
    ) triangles
  in
  let triangles =
    List.map (fun (a, b, c) -> (Printf.sprintf "  triangle { %s, %s, %s }\n" a b c)
    ) triangles
  in
  let triangles =
    List.fold_left (fun acc s -> acc ^ s) "" triangles
  in
  Printf.sprintf {|
mesh {
%s%s%s%s%s
}
|} triangles texture
   scale rotate translate;
;;

let add_mesh (scene, includes) ~triangles ?translate ?rotate ?scale ?texture () =
  let mesh = get_mesh ~triangles ?translate ?rotate ?scale ?texture () in
  (mesh :: scene, includes)

end



module MeshC = struct

let triangle_color tc =
  match tc with
  | Color.Red    -> "texture { pigment { Red } }"
  | Color.Green  -> "texture { pigment { Green } }"
  | Color.Blue   -> "texture { pigment { Blue } }"
  | Color.Yellow -> "texture { pigment { Yellow } }"

  | Color.White  -> "texture { pigment { White } }"
  | Color.Black  -> "texture { pigment { Black } }"

  | Color.Cyan   -> "texture { pigment { Cyan } }"
  | Color.Pink   -> "texture { pigment { Pink } }"
  | Color.Magenta -> "texture { pigment { Magenta } }"

  | Color.RGBT(r, g, b, t) ->
      Printf.sprintf "texture { pigment { color rgbt <%g, %g, %g, %g> } }" r g b t

  | Color.RGB(r, g, b) ->
      Printf.sprintf "texture { pigment { color rgb <%g, %g, %g> } }" r g b
;;



let _tex_id = ref 0

let get_mesh ~triangles ?(translate) ?(rotate) ?(scale) () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in

  let triangle_to_string (x, y, z) = (Printf.sprintf "<%g, %g, %g>" x y z) in

  let _tex_num = ref 0 in
  let _triangles =
    List.map (fun (triangle, tc) ->
      incr _tex_num;
      let tex_id = Printf.sprintf "DTex_%d_%d" !_tex_id !_tex_num in
      let dec =
        Printf.sprintf "#declare %s = %s\n" tex_id (triangle_color tc)
      in
      let tex_name = (Printf.sprintf "texture { %s }" tex_id) in
      (triangle, dec, tex_name)
    ) triangles
  in
  incr _tex_id;

  let _triangles =
    List.map (fun ((a, b, c), dec, tex_n) ->
      ((triangle_to_string a,
        triangle_to_string b,
        triangle_to_string c), dec, tex_n)
    ) _triangles
  in
  let triangles =
    List.map (fun ((a, b, c), _, tn) ->
      (Printf.sprintf "  triangle { %s, %s, %s %s }\n" a b c tn)
    ) _triangles
  in
  let triangles = List.fold_left (fun acc s -> acc ^ s) "" triangles in
  let descs = List.map (fun (_, td, _) -> (td) ) _triangles in
  let descs = (String.concat "" descs) in
  Printf.sprintf {|
%s
mesh {
%s%s%s%s
}
|} descs triangles
   scale rotate translate;
;;


let add_mesh (scene, includes) ~triangles ?(translate) ?(rotate) ?(scale) () =
  let mesh = get_mesh ~triangles ?translate ?rotate ?scale () in
  (mesh :: scene, includes)

end



module MeshD = struct

let check_indices ~points ~faces =
  let n = Array.length points in
  Array.iter (fun (a, b, c) ->
    if a >= n then invalid_arg "get_mesh: indice mismatch";
    if b >= n then invalid_arg "get_mesh: indice mismatch";
    if c >= n then invalid_arg "get_mesh: indice mismatch";
  ) faces;
;;

let get_mesh ~points ~faces ?(translate) ?(rotate) ?(scale) ?(texture="") () =
  check_indices ~points ~faces;
  let n1 = Array.length points in
  let n2 = Array.length faces in

  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in

  let points = Array.map (fun (x, y, z) ->
    Printf.sprintf ",\n    <%g, %g, %g>" x y z) points in
  let faces = Array.map (fun (a, b, c) ->
    Printf.sprintf ",\n    <%d, %d, %d>" a b c) faces in

  let points = String.concat "" (Array.to_list points) in
  let faces = String.concat "" (Array.to_list faces) in
  Printf.sprintf {|
mesh2 {
  vertex_vectors {
    %d%s
  }
  face_indices {
    %d%s
  }
%s%s%s%s
}
|}
  n1 points n2 faces texture
  scale rotate translate;
;;

let add_mesh (scene, includes) ~points ~faces ?(translate) ?(rotate) ?(scale) ?(texture) () =
  let mesh = get_mesh ~points ~faces ?translate ?rotate ?scale ?texture () in
  (mesh :: scene, includes)

end



module MeshD2 = struct

let check_indices n1 n3 ~points ~faces ~textures =
  Array.iter (fun ((a, b, c), i) ->
    if a >= n1 then invalid_arg "get_mesh: point indice mismatch";
    if b >= n1 then invalid_arg "get_mesh: point indice mismatch";
    if c >= n1 then invalid_arg "get_mesh: point indice mismatch";
    if i >= n3 then invalid_arg "get_mesh: texture indice mismatch";
  ) faces;
;;

let get_mesh ~points ~faces ~textures ?(translate) ?(rotate) ?(scale) () =
  let n1 = Array.length points in
  let n2 = Array.length faces in
  let n3 = Array.length textures in
  check_indices n1 n3 ~points ~faces ~textures;

  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "  translate <%g, %g, %g>\n" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "  rotate <%g, %g, %g>\n" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "  scale <%g, %g, %g>\n" x y z in

  let points = Array.map (fun (x, y, z) ->
    Printf.sprintf ",\n    <%g, %g, %g>" x y z) points in

  let faces = Array.map (fun ((a, b, c), i) ->
    Printf.sprintf ",\n    <%d, %d, %d>, %d" a b c i) faces in

  let textures = String.concat "\n" (Array.to_list textures) in
  let points = String.concat "" (Array.to_list points) in
  let faces = String.concat "" (Array.to_list faces) in
  Printf.sprintf {|
mesh2 {
  vertex_vectors {
    %d%s
  }
  texture_list {
    %d,
%s
  }
  face_indices {
    %d%s
  }
%s%s%s}
|}
  n1 points
  n3 textures
  n2 faces
  scale rotate translate;
;;

let add_mesh (scene, includes) ~points ~faces ~textures ?(translate) ?(rotate) ?(scale) () =
  let mesh = get_mesh ~points ~faces ~textures ?translate ?rotate ?scale () in
  (mesh :: scene, includes)

end



module MeshUV = struct

let get_mesh ~triangles ~image ?(translate) ?(rotate) ?(scale) () =
  let translate = match translate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  translate <%g, %g, %g>" x y z in
  let rotate = match rotate with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  rotate <%g, %g, %g>" x y z in
  let scale = match scale with None -> ""
  | Some (x, y, z) -> Printf.sprintf "\n  scale <%g, %g, %g>" x y z in
  let point3d_to_string (x, y, z) = (Printf.sprintf "<%g, %g, %g>" x y z) in
  let point2d_to_string (u, v) = (Printf.sprintf "<%g, %g>" u v) in
  let triangles =
    List.map (fun ((a, b, c), (d, e, f)) ->
      ( point3d_to_string a,
        point3d_to_string b,
        point3d_to_string c,
        point2d_to_string d,
        point2d_to_string e,
        point2d_to_string f
      )
    ) triangles
  in
  let triangles =
    List.map (fun (a, b, c, d, e, f) ->
      Printf.sprintf "\n  triangle { %s, %s, %s uv_vectors %s, %s, %s }" a b c d e f
    ) triangles
  in
  let triangles =
    List.fold_left (fun acc s -> acc ^ s) "" triangles
  in
  let file_type =
    match Filename.extension image with
    | ".png" -> "png"
    | ".jpg" -> "jpeg"
    | _ -> "img-file-type?"
  in
  Printf.sprintf {|
mesh {%s
  texture {
    uv_mapping
    pigment {
      image_map {
        %s "%s"
        map_type 0
      }
    }
  }%s%s%s
}
|} triangles file_type image
   scale rotate translate;
;;

let add_mesh (scene, includes) ~triangles ~image ?translate ?rotate ?scale () =
  let mesh = get_mesh ~triangles ~image ?translate ?rotate ?scale () in
  (mesh :: scene, includes)

end



module Float = struct

let get_camera ~location:(lx,ly,lz) ~look_at:(ax,ay,az) ?(kind) ?(angle) () =
  let knd = cam_kind ?kind () in
  let ang = cam_angle ?angle () in
  Printf.sprintf "
camera {%s
  location <%g, %g, %g>
  look_at  <%g, %g, %g>%s
}\n" knd
     lx ly lz
     ax ay az  ang;
;;

let add_camera (scene, includes) ~location ~look_at ?kind ?angle () =
  let cam = get_camera ~location ~look_at ?kind ?angle () in
  (cam :: scene, includes)


let get_plane ~norm:(x,y,z) ~dist:d ?(texture="") () =
  Printf.sprintf "
plane {
  <%g, %g, %g>, %g
%s
}\n" x y z d
     texture;
;;

let add_plane (scene, includes) ~norm ~dist ?texture () =
  let plane = get_plane ~norm ~dist ?texture () in
  (plane :: scene, includes)

end


module Int = struct

let get_camera ~location:(lx,ly,lz) ~look_at:(ax,ay,az) ?(kind) ?(angle) () =
  let knd = cam_kind ?kind () in
  let ang = cam_angle ?angle () in
  Printf.sprintf "
camera {%s
  location <%d, %d, %d>
  look_at  <%d, %d, %d>%s
}\n" knd
     lx ly lz
     ax ay az  ang;
;;

let add_camera (scene, includes) ~location ~look_at ?kind ?angle () =
  let cam = get_camera ~location ~look_at ?kind ?angle () in
  (cam :: scene, includes)

end


let ( @ ) a b = List.rev_append (List.rev a) b ;;

module Desc = struct

  let add_desc sc desc =
    match desc with
    | Include inc -> add_include sc ~inc:(Inc_file.of_string ~inc)
    | Background color -> add_background sc ~color
    | Camera (location, look_at, kind) -> add_camera sc ~location ~look_at ?kind ()
    | Light_source (location, color) -> add_light_source sc ~location ~color
    | Ambient_light (r, g, b) -> add_ambient_light sc ~color:(r, g, b)

    | Sphere (radius, center, texture, translate, rotate, scale) ->
        add_sphere sc ~radius ~center ?translate ?rotate ?scale ~texture ()

    | Cone (radius1, radius2, center1, center2, texture, translate, rotate, scale) ->
        add_cone sc ~radius1 ~center1
                    ~radius2 ~center2 ~texture
                    ?translate ?rotate ?scale ()

    | Cylinder (radius, center1, center2, texture, translate, rotate, scale) ->
        add_cylinder sc ~center1 ~center2 ~radius ~texture
            ?translate ?rotate ?scale ()

    | Box (corner1, corner2, texture, translate, rotate, scale) ->
        add_box sc ~corner1 ~corner2 ?translate ?rotate ?scale ~texture ()

    | Torus (major, minor, texture, translate, rotate, scale) ->
        add_torus sc ~major ~minor ?translate ?rotate ?scale ~texture ()

    | Mesh (triangles, texture, translate, rotate, scale) ->
        Mesh.add_mesh sc ~triangles ?translate ?rotate ?scale ~texture ()

    | MeshC (triangles, translate, rotate, scale) ->
        MeshC.add_mesh sc ~triangles ?translate ?rotate ?scale ()

    | MeshD (points, faces, texture, translate, rotate, scale) ->
        MeshD.add_mesh sc ~points ~faces ~texture ?translate ?rotate ?scale ()

    | MeshD2 (points, faces, textures, translate, rotate, scale) ->
        MeshD2.add_mesh sc ~points ~faces ~textures ?translate ?rotate ?scale ()

    | MeshUV (triangles, image, translate, rotate, scale) ->
        MeshUV.add_mesh sc ~triangles ~image ?translate ?rotate ?scale ()



  let to_scene desc =
    let sc = new_scene () in
    List.fold_left add_desc sc desc

  let add_descs sc desc =
    List.fold_left add_desc sc desc

  let add elem desc =
    let desc = desc @ [elem] in
    (desc)

  let add_elems elems desc =
    let desc = desc @ elems in
    (desc)

end

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
