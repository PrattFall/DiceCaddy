open Containers
open CCList.Infix

module P = Postgresql

let for_all_rows conn map_f data  =
  let num_rows = data#ntuples in
  if num_rows = 0
  then []
  else List.map map_f (0 -- (num_rows - 1))

let separate results =
  List.fold_left (fun (oks, ers) x ->
      match x with
      | Ok y    -> (y :: oks, ers)
      | Error e -> (oks, e :: ers)
    ) ([],[]) results
