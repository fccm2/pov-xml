(** Checks and report *)

val is_balanced : Xmlerr.t list -> bool

type bal_rep =
  | Balance_err_at of int
  | Balanced

val balance_rep : Xmlerr.t list -> bal_rep

val max_depth : Xmlerr.t list -> int
(** raises an exception if the tree is not balanced *)

val max_depth_opt : Xmlerr.t list -> int option
(** same than max_depth but returns None is the tree is not balanced *)

