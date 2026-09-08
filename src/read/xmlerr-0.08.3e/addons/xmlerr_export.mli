(** exports to s-expression, an input xml-content *)

val file_to_sexpr : fn:string -> string
(** returns the input xml-file, formatted in s-expr *)

val to_sexpr : s:string -> string
(** the same, but from xml into a [string] *)

