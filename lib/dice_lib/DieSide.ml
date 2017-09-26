type t =
  { value : DieFace.t
  ; num : int
  }

let make num value =
  { value; num }

let name side = side.value

let num side = side.num

let num_values side = (DieFace.num_values side.value) * side.num

let simplify_list faces =
  let same_val x y =
    DieFace.equals x.value y.value
  in

  let exists_in xs x =
    xs |> List.fold_left (fun acc y -> acc || same_val x y) false
  in

  let update_if_equals x y =
    if same_val y x
    then { y with num = x.num + y.num }
    else y
  in

  let update_existing_or_add acc x =
    if exists_in acc x
    then List.map (update_if_equals x) acc
    else x :: acc
  in

  faces
  |> List.fold_left update_existing_or_add []

let roll side =
  let rec roll_iter result_group face iter =
    if iter > 0
    then
      roll_iter
        (DieResultGroup.combine (DieFace.roll face) result_group)
        face
        (iter - 1)
    else result_group
  in

  roll_iter DieResultGroup.empty side.value side.num

let to_string side =
  Format.sprintf "%dx %s" side.num (DieFace.to_string side.value)
