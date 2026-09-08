type pos = float * float * float
type triangle = pos * pos * pos

(** You can provide a [triangle list] to the function:
    [Povray.Mesh.add_mesh]
 *)

val get_octahedron : s:float -> h:float -> triangle list
(** [s] is the [side] distance from the center, and
    [h] is the distance of the [height] from the center. *)

val get_pyramid : s:float -> h:float -> triangle list

val get_tetrahedron : s:float -> h:float -> triangle list

val get_icosahedron : unit -> triangle list

type uv = float * float
type triangle_2d = uv * uv * uv
type triangle_uv = triangle * triangle_2d

val get_pyramid_uv : s:float -> h:float -> triangle_uv list

