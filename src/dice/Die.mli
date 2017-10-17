type t =
  { name  : string
  ; faces : DieFaceGroup.t list
  }

val make : ?faces:(DieFaceGroup.t list) -> string -> t

val name : t -> string

val faces : t -> DieFaceGroup.t list

val add_face : DieFaceGroup.t -> t -> t

val roll : t -> (DieResultGroup.t, Message.t) result
