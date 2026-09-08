(** Templating Helper functions *)
(** Templating Helper functions,
    for the "htmluxtr" command line tool. *)

type t =
  | S of string
  | Var of string

val read_tmpl : string -> t list

val f :
  t list ->
  x:(string * string) list ->
  t list

val fe :
  t list ->
  x:(string * string) list ->
  string

val print : t list -> unit
