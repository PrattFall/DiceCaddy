type t =
  { name : string
  ; total: int
  ; values : int list
  }

val name : t -> string

val total : t -> int

val values : t -> int list

val make : string -> int -> t

val to_string : t -> string

val add : int -> t -> t

val combine : t -> t -> t option
