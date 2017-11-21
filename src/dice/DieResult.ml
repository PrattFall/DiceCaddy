type t =
  { name : string
  ; values : int list
  }

let name dr = dr.name

let total dr = List.fold_left (+) 0 dr.values

let values dr = dr.values

let make name first_total =
  { name = name
  ; values = [ first_total ]
  }

let to_string result =
  let show_value v =
    match v with
    | n when n > 0 -> "+" ^ (string_of_int n)
    | n            -> string_of_int n
  in

  let values =
    result.values
    |> List.map show_value
    |> String.concat ", "
  in

  show_value result.total ^ " " ^ result.name ^ " (" ^ values ^ ")"

let add value result =
  { result with values = value :: result.values
  }

let combine result1 result2 =
  let create_new () =
    let new_values =
      result1.values @ result2.values
      |> List.sort compare
    in

    { name   = result1.name
    ; values = new_values
    }
  in

  if result1.name = result2.name
  then Some (create_new ())
  else None
