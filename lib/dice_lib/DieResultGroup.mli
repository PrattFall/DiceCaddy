type t

val empty : t

val find : string -> t -> DieResult.t option

val add : DieResult.t -> t -> t

val singleton : DieResult.t -> t

val fold : (DieResult.t -> 'a -> 'a) -> 'a -> t -> 'a

val combine : t -> t -> t

val to_list : t -> DieResult.t list

val to_string : t -> string
