type t =
  { min : int
  ; max : int
  }

val make : int -> int -> t

val min : t -> int

val max : t -> int

val equals : t -> t -> bool

val total : t -> int

val to_string : t -> string
