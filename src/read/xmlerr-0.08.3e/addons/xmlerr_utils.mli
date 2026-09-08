(** Utility functions *)

val extract :
  Xmlerr.t list ->
  Xmlerr.t list ->
  string list list
(** [extract tp xs] uses the template [tp] to extract elements in [xs] *)

val webstr : string -> string
(** translate web-encoded chars,
    as for example %20 and %7E into ' ' and '~' *)
