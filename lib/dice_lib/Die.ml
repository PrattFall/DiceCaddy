open Containers

type t =
  { name  : string
  ; faces : DieFaceGroup.t list
  }

let make ?(faces=[]) name =
 { name = name
 ; faces = faces
 }

let name d = d.name

let faces die = die.faces

let add_face face die =
  { die with faces =  DieFaceGroup.simplify_list (face :: die.faces) }

let roll d =
  let roll_random_element_from_list xs =
    let open Message in
    let open DieResultMessage in

    match List.get_at_idx (Rand.list_index xs) xs with
    | Some el -> Ok (DieFace.roll el)
    | None -> Error (DieResultMessage ResultCouldNotBeCalculated)
  in

  faces d
  |> List.flat_map DieFaceGroup.get_all
  |> roll_random_element_from_list
