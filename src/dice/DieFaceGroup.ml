module DieFaceGroup_Inner = DuplicateGroup.Make(struct
  type t = DieFace.t
  let equals = DieFace.equals
end)

include DieFaceGroup_Inner

let to_string side =
  Format.sprintf "%dx %s" side.length (DieFace.to_string side.value)
