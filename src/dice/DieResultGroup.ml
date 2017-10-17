module DieResultMap = Map.Make(String)

type t = DieResult.t DieResultMap.t

let empty = DieResultMap.empty

let find name results =
  try Some (DieResultMap.find name results) with
  | Not_found -> None

let add new_result results =
  let name = DieResult.name new_result in

  let add_result result results =
    DieResultMap.add (DieResult.name result) result results
  in

  let add_combined result1 result2 results_list =
    match DieResult.combine result1 result2 with
    | Some combined_result -> add_result combined_result results_list
    | None -> results_list
  in

  match find name results with
  | Some existing_result -> add_combined new_result existing_result results
  | None -> add_result new_result results

let singleton result =
  add result empty

let fold f init xs =
  DieResultMap.fold (fun _ x y -> f x y) xs init

let combine rg1 rg2 =
  fold (fun x acc -> add x acc) rg1 rg2

let to_list results =
  results
  |> fold (fun x acc -> x :: acc) []
  |> List.sort (fun a b -> compare (DieResult.name a) (DieResult.name b))

let to_string results =
  results
  |> to_list
  |> List.map DieResult.to_string
  |> String.concat ", "
