(** Convert to a Tree structure *)

type attr = string * string  (** (attr_name, attr_val) *)
type attrs = attr list 

type tree =
  | CTag of string * attrs * tree list  (** rec Sub_t *)
  | CData of string  (** PCData *)
  | CComm of string  (** Comments *)

val dump_tree : Xmlerr.t list -> tree list
(** converts a tag list into a tree structure *)

val test_data : tree list

val print_tree : tree -> unit
val print_trees : tree list -> unit

val is_balanced : Xmlerr.t list -> bool

val test_data_in : Xmlerr.t list

