type t = DieFaceValue.t list

val singleton : string -> Range.t -> t

val num_values : t -> int

val equals : t -> t -> bool

val contains : DieFaceValue.t -> t -> bool

val roll : t -> DieResultGroup.t

val to_string : t -> string
