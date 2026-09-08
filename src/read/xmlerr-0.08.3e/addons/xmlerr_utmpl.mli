(** Untemplating Utility functions *)

val extract :
  Xmlerr.t list ->
  Xmlerr.t list ->
  (string * string) list list
(** [extract tp xs] uses the template [tp] to extract elements in [xs] *)
