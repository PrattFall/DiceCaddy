open OUnit2

open DiceLib
open DiceLib.Errors

let simplify_list_simplifies_duplicates =
  let test _ =
    let die_face = DieFace.singleton "Base" (Range.make 1 1) in
    let die_side = DieFaceGroup.singleton die_face in
    let die_side_list = [ die_side; die_side ] in
    let simplified_list =
      [ DieFaceGroup.make 2 die_face ]
    in

    assert_equal (DieFaceGroup.simplify_list die_side_list) simplified_list;
  in

  let title = "'simplify_list' simplifies duplicate faces" in

  title >:: test

let tests =
  "Die Face Group" >:::
  [
    simplify_list_simplifies_duplicates;
  ]
