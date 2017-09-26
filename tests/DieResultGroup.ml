open OUnit2

open DiceLib
open DiceLib.Errors

let optimizes_by_default =
  let test _ =
    let optimized_list =
      DieResultGroup.empty
      |> DieResultGroup.add (DieResult.make "Yup" 5)
      |> DieResultGroup.add (DieResult.make "Yup" 7)
      |> DieResultGroup.to_list
    in

    let test_results =
      [ { DieResult.name = "Yup"
        ; DieResult.total = 12
        ; DieResult.values = [ 5; 7 ]
        }
      ]
    in

    assert_equal test_results optimized_list
  in

  let title = "'add' optimizes results by default" in

  title >:: test

let tests =
  "Die Result Group" >:::
  [
     optimizes_by_default;
  ]
