(* To the extend permited by law, you can use, modify and redistribute
   this file. *)

(** {2 A PovRay module} *)

(** There are 3 different ways to create a [povray] scene:

    with the description type [scene_desc],
    accumulating to the [scene] type,
    or with a type that we can print to a screen.
*)

(** {4 Scene Description} *)

type location = float * float * float

module Camera : sig
  type t = Perspective | Orthographic | Fisheye
end

module Color : sig
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

type texture
type finish

type triangle = location * location * location
type triangle_c = triangle * Color.t

type uv = float * float
type triangle_2d = uv * uv * uv
type triangle_uv = triangle * triangle_2d

type face_indice = int * int * int
type face_indices = face_indice array


type scene_desc =
  | Include of string
  | Background of color
  | Light_source of location * color
  | Ambient_light of float * float * float
  | Camera of location * location * Camera.t option

  | Sphere of float * location * texture *
        location option * location option * location option
    (** [radius] / [center] / [texture] / [translate] / [rotate] / [scale] *)

  | Cone of float * float * location * location * texture *
        location option * location option * location option
    (** [radius1] / [radius2] / [center1] / [center2] / [texture] /
         [translate] / [rotate] / [scale] *)

  | Box of location * location * texture *
        location option * location option * location option
    (** [corner1] / [corner2] / [texture] / [translate] / [rotate] / [scale] *)

  | Cylinder of float * location * location * texture *
        location option * location option * location option
    (** [radius] / [center1] / [center2] / [texture] /
         [translate] / [rotate] / [scale] *)

  | Torus of float * float * texture * location option * location option * location option
    (** [major] / [minor] / [texture] / [translate] / [rotate] / [scale] *)

  | Mesh of triangle list * texture *
        location option * location option * location option
    (** [triangles] / [texture] / [translate] / [rotate] / [scale] *)

  | MeshC of (triangle * color) list *
        location option * location option * location option
    (** ([triangles] / [colors]) / [translate] / [rotate] / [scale] *)

  | MeshD of location array * face_indice array * texture *
        location option * location option * location option
    (** [points] / [faces] / [texture] / [translate] / [rotate] / [scale] *)

  | MeshD2 of location array * (face_indice * int) array * texture array *
        location option * location option * location option
    (** [points] / [faces] / [textures] / [translate] / [rotate] / [scale] *)

  | MeshUV of triangle_uv list * string *
        location option * location option * location option
    (** [triangles + uv] / [image-file-name] / [translate] / [rotate] / [scale] *)



module Textures : sig
(** {4 Textures} *)

(** Textures defined in ["/usr/share/povray-*/include/*.inc"]. *)


module Wood : sig

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

val to_string : woods -> string
end


module Stone : sig

(*
/usr/share/povray-3.7/include/stones.inc
/usr/share/povray-3.7/include/stones1.inc
/usr/share/povray-3.7/include/stones2.inc
*)

(** Textures defined in ["stones1.inc"]:

  - from [T_Grnt0] to [T_Grnt29],
  - from [T_Grnt0A] to [T_Grnt24A],
  - from [T_Crack1] to [T_Crack4],
  - from [Stone1] to [Stone24], and
  - from [T_Stone25] to [T_Stone44], textures defined in ["stones2.inc"].

    To include the files ["stones1.inc"] and ["stones2.inc"]:

  - use respectively: [Inc_file.Stones1] and [Inc_file.Stones2].
*)

(** Textures defined in ["stones1.inc"] and ["stones2.inc"]. *)
type stones =
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

  | T_Stone25 | T_Stone26 | T_Stone27 | T_Stone28 | T_Stone29 | T_Stone30 | T_Stone31 | T_Stone32
  | T_Stone33 | T_Stone34 | T_Stone35 | T_Stone36 | T_Stone37 | T_Stone38 | T_Stone39 | T_Stone40
  | T_Stone41 | T_Stone42 | T_Stone43 | T_Stone44

val to_string : stones -> string
end

module Metal : sig
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

val to_string : metals -> string
end

type texture_def =
  | Stone of Stone.stones
  | Wood of Wood.woods
  | Metal of Metal.metals

val to_string : texture_def -> string

end


(** {4 Adds to a Scene} *)

type scene

val new_scene : unit -> scene

val string_of_scene : scene -> string

val print_scene : scene -> unit


(*
#include "colors.inc"
*)

module Inc_file : sig
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

val to_string : inc:t -> string
val of_string : inc:string -> t
end

type inc_file = Inc_file.t


val string_of_inc_file : inc:inc_file -> string
val inc_file_of_string : inc:string -> inc_file
(**
    [string_of_inc_file] is equivalent to [Inc_file.to_string]

    [inc_file_of_string] is equivalent to [Inc_file.of_string]
*)


val add_include : scene -> inc:inc_file -> scene
val add_comment : scene -> com:string -> scene
val add_background : scene -> color:color -> scene
val add_light_source : scene -> location:float * float * float -> color:color -> scene

val add_camera : scene ->
  location:float * float * float ->
  look_at:float * float * float ->
  ?kind:Camera.t -> ?angle:int -> unit -> scene

val add_ambient_light : scene -> color:float * float * float -> scene

type normal
module Normal : sig
  type t = normal

  val normal_wrinkles : bump_depth:float -> scale:float -> normal
  val normal_granite : bump_depth:float -> scale:float -> normal
  val normal_crackle : bump_depth:float -> scale:float -> normal
  val normal_bozo : bump_depth:float -> scale:float -> normal
  val normal_dents : bump_depth:float -> scale:float -> normal
  val normal_waves : bump_depth:float -> scale:float -> normal
  val normal_ripples :
    bump_depth:float -> phase:float -> frequency:float -> normal
  val normal_agate :
    bump_depth:float -> agate_turb:float -> scale:float -> normal
  val normal_marble :
    bump_depth:float -> scale:float -> turbulence:float -> normal

  val string_of_normal : normal -> string
end

val new_finish :
  ?ambient:float ->
  ?diffuse:float ->
  ?specular:float -> unit -> finish

val new_texture :
  ?color:color -> ?scale:int ->
  ?def:Textures.texture_def ->
  ?normal:normal ->
  ?finish:finish -> unit -> texture

val new_checker :
  color1:color ->
  color2:color ->
  ?scale:float ->
  ?finish:finish -> unit -> texture

val new_hexagon :
  color1:color ->
  color2:color ->
  color3:color ->
  ?scale:float ->
  ?finish:finish -> unit -> texture

type pattern = [ `wrinkles | `waves | `ripples | `granite
  | `dents | `crackle | `bozo | `agate of float ]

val string_of_pattern : pattern -> string

val new_color_pattern :
  pat:pattern ->
  color_map:(float * Color.t) list ->
  ?scale:float ->
  ?finish:string -> unit -> texture


(** {4 Adds Shapes to a Scene} *)

val add_sphere :
  scene ->
  center:float * float * float ->
  radius:float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float -> ?texture:texture -> unit -> scene

val add_cylinder :
  scene ->
  center1:float * float * float ->
  center2:float * float * float ->
  radius:float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float -> ?texture:texture -> unit -> scene

val add_box :
  scene ->
  corner1:float * float * float ->
  corner2:float * float * float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float -> ?texture:texture -> unit -> scene

val add_cone :
  scene ->
  center1:float * float * float ->
  radius1:float ->
  center2:float * float * float ->
  radius2:float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float -> ?texture:texture -> unit -> scene

val add_torus :
  scene ->
  major:float ->
  minor:float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float -> ?texture:texture -> unit -> scene
(** [major-radius] / [minor-radius] *)

val add_polygon :
  scene ->
  pnts:(float * float) list ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float -> ?texture:texture -> unit -> scene

val add_plane :
  scene ->
  norm:int * int * int ->
  dist:int ->
  ?texture:texture -> unit -> scene

val add_text :
  scene ->
  font:string ->
  text:string ->
  ?thickness:float -> ?offset:float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float -> ?texture:texture -> unit -> scene


(** {4 Print to Screen} *)

val get_color : color:color -> string

val get_include : inc:inc_file -> string
val get_comment : com:string -> string
val get_background : color:color -> string
val get_light_source : location:float * float * float -> color:color -> string

val get_camera :
  location:float * float * float ->
  look_at:float * float * float ->
  ?kind:Camera.t -> ?angle:int -> unit -> string

val get_ambient_light : color:float * float * float -> string

val get_finish :
  ?ambient:float ->
  ?diffuse:float ->
  ?specular:float -> unit -> string

val get_texture :
  ?color:Color.t ->
  ?scale:int ->
  ?def:Textures.texture_def ->
  ?normal:normal ->
  ?finish:string -> unit -> string

val get_checker :
  color1:color ->
  color2:color ->
  ?scale:float ->
  ?finish:string -> unit -> string

val get_hexagon :
  color1:color ->
  color2:color ->
  color3:color ->
  ?scale:float ->
  ?finish:string -> unit -> string

val get_color_pattern :
  pat:pattern ->
  color_map:(float * Color.t) list ->
  ?scale:float ->
  ?finish:string -> unit -> string



(** {4 Prints shapes to the Screen} *)

val get_sphere :
  center:float * float * float ->
  radius:float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float ->
  ?texture:string -> unit -> string

val get_cylinder :
  center1:float * float * float ->
  center2:float * float * float ->
  radius:float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float ->
  ?texture:string -> unit -> string

val get_box :
  corner1:float * float * float ->
  corner2:float * float * float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float ->
  ?texture:string -> unit -> string

val get_cone :
  center1:float * float * float ->
  radius1:float ->
  center2:float * float * float ->
  radius2:float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float ->
  ?texture:string -> unit -> string

val get_torus :
  major:float ->
  minor:float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float ->
  ?texture:string -> unit -> string

val get_polygon :
  pnts:(float * float) list ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float ->
  ?texture:string -> unit -> string

val get_plane :
  norm:int * int * int ->
  dist:int ->
  ?texture:string -> unit -> string

val get_text :
  font:string ->
  text:string ->
  ?thickness:float -> ?offset:float ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float ->
  ?texture:string -> unit -> string


(** {3 CSG: Constructive Solid Geometry} *)

(** {5 Groups} *)

val get_union :
  group:string ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float -> unit -> string


val add_union : scene ->
  group:(scene -> scene) ->
  ?translate:float * float * float ->
  ?rotate:float * float * float ->
  ?scale:float * float * float -> unit -> scene



(** {5 CSG-Diff} *)

val get_difference :
  elem1:string -> elem2:string -> ?texture:string -> unit -> string

val add_difference : scene ->
  elem1:string -> elem2:string -> ?texture:texture -> unit -> scene


val add_elem : scene -> elem:string -> unit -> scene


(** {5 Intersection} *)

val get_intersection :
  elem1:string -> elem2:string -> ?texture:string -> unit -> string

val add_intersection : scene ->
  elem1:string -> elem2:string -> ?texture:texture -> unit -> scene



(** {4 Description Conv} *)

module Desc : sig
  val to_scene : scene_desc list -> scene

  val add : scene_desc -> scene_desc list -> scene_desc list
  val add_elems : scene_desc list -> scene_desc list -> scene_desc list
  (* [Desc.add_elems elems desc]
     adds [elems] to the description list [desc] *)

  val add_desc : scene -> scene_desc -> scene
  val add_descs : scene -> scene_desc list -> scene
end



(** {4 Selecting Floats or Ints} *)

module Float : sig

  val add_camera : scene ->
    location:float * float * float ->
    look_at:float * float * float ->
    ?kind:Camera.t -> ?angle:int -> unit -> scene

  val get_camera :
    location:float * float * float ->
    look_at:float * float * float ->
    ?kind:Camera.t -> ?angle:int -> unit -> string

  val add_plane :
    scene ->
    norm:float * float * float ->
    dist:float ->
    ?texture:texture -> unit -> scene

  val get_plane :
    norm:float * float * float ->
    dist:float ->
    ?texture:string -> unit -> string

end

module Int : sig

  val add_camera : scene ->
    location:int * int * int ->
    look_at:int * int * int ->
    ?kind:Camera.t -> ?angle:int -> unit -> scene

  val get_camera :
    location:int * int * int ->
    look_at:int * int * int ->
    ?kind:Camera.t -> ?angle:int -> unit -> string

end



(** {4 Meshes} *)

module Mesh : sig
  val get_mesh : triangles:triangle list ->
    ?translate:float * float * float ->
    ?rotate:float * float * float ->
    ?scale:float * float * float -> ?texture:texture -> unit -> string

  val add_mesh : scene ->
    triangles:triangle list ->
    ?translate:float * float * float ->
    ?rotate:float * float * float ->
    ?scale:float * float * float -> ?texture:texture -> unit -> scene
end


module MeshC : sig
(** one color by triangle *)

  val get_mesh : triangles:triangle_c list ->
    ?translate:float * float * float ->
    ?rotate:float * float * float ->
    ?scale:float * float * float -> unit -> string

  val add_mesh : scene ->
    triangles:triangle_c list ->
    ?translate:float * float * float ->
    ?rotate:float * float * float ->
    ?scale:float * float * float -> unit -> scene
end


module MeshD : sig
(** with face-indices *)

  val get_mesh :
    points:location array ->
    faces:face_indice array ->
    ?translate:float * float * float ->
    ?rotate:float * float * float ->
    ?scale:float * float * float -> ?texture:texture -> unit -> string

  val add_mesh : scene ->
    points:location array ->
    faces:face_indice array ->
    ?translate:float * float * float ->
    ?rotate:float * float * float ->
    ?scale:float * float * float -> ?texture:texture -> unit -> scene
end


module MeshD2 : sig
(** face-indices with indexed textures *)

  val get_mesh :
    points:location array ->
    faces:(face_indice * int) array ->
    textures:texture array ->
    ?translate:float * float * float ->
    ?rotate:float * float * float ->
    ?scale:float * float * float -> unit -> string

  val add_mesh : scene ->
    points:location array ->
    faces:(face_indice * int) array ->
    textures:texture array ->
    ?translate:float * float * float ->
    ?rotate:float * float * float ->
    ?scale:float * float * float -> unit -> scene

  (** [faces]: [face_indice], 3 indices from the [points] array,
      and an additional indice to select a [texture] from the [textures] array. *)
end


module MeshUV : sig
(** triangles with UV coordinates on an image *)

  val add_mesh :
    scene ->
    triangles:triangle_uv list ->
    image:string ->
    ?translate:float * float * float ->
    ?rotate:float * float * float ->
    ?scale:float * float * float -> unit -> scene

  val get_mesh :
    triangles:triangle_uv list ->
    image:string ->
    ?translate:float * float * float ->
    ?rotate:float * float * float ->
    ?scale:float * float * float -> unit -> string

end

(** {3 Official POV-Ray Documentation} *)

(** {{:https://www.povray.org/documentation/}
       https://www.povray.org/documentation/} *)

(** You can also find examples and documentation in:
    ["/usr/share/doc/povray"] *)

