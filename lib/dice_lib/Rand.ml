(* Works for negative 'min' and 'max' values *)
let in_range r =
  let max_n = Range.max r in
  let min_n = Range.min r in

  if max_n < 0
  then (-(Random.int ((-min_n) + 1 + max_n))) + max_n
  else (Random.int (max_n + 1 - min_n)) + min_n

let list_index lst =
  let list_length = List.length lst in

  if list_length = 0
  then 0
  else
    list_length - 1
    |> Range.make 0
    |> in_range
