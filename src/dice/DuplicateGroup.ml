open Containers

module type Dup_Equal = sig
  type t
  val equals : t -> t -> bool
end

module Make = functor (Equal : Dup_Equal) -> struct
  type elt = Equal.t

  type t = { length : int
           ; value  : elt
           }

  let make length value =
    { length; value }

  let singleton value =
    { length = 1
    ; value = value
    }

  let value group = group.value

  let length group = group.length

  let same group1 group2 =
    Equal.equals group1.value group2.value

  let combine group1 group2 =
    if same group1 group2
    then { group1 with length = group1.length + group2.length }
    else group1

  let add value group =
    if Equal.equals value group.value
    then { group with length = group.length + 1 }
    else group

  let simplify_list =
    let exists_in xs x =
      List.fold_left (fun acc y -> acc || same x y) false xs
    in

    let update_existing_or_add acc x =
      if exists_in acc x
      then List.map (combine x) acc
      else x :: acc
    in

    List.fold_left update_existing_or_add []

  let get_all group =
    List.replicate group.length group.value
end
