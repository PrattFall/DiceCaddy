open OUnit2

open DiceLib
open DiceLib.Errors

let name_always_returns_name =
  let test _ =
    let face_value_single = DieFaceValue.make "Base" (Range.make 1 1) in
    let face_value_range = DieFaceValue.make "D20" (Range.make 1 20) in
    let die_side = [ face_value_single ] in
    let die_side_range = [ face_value_range ] in

    assert_equal (DieFace.contains face_value_single die_side) true;
    assert_equal (DieFace.contains face_value_range die_side_range) true
  in

  let title = "'name' always returns a name" in

  title >:: test

let num_faces_returns_correct_number =
  let test _ =
    let die_side = DieFace.singleton "Base" (Range.make 1 1)  in

    let make_range name n1 n2 =
      DieFace.singleton name (Range.make n1 n2);
    in

    let die_side_range1 = make_range "D20"     1    20  in
    let die_side_range2 = make_range "D20"  (-11)   20  in
    let die_side_range3 = make_range "D-11" (-20) (-30) in

    assert_equal (DieFace.num_values die_side) 1;
    assert_equal (DieFace.num_values die_side_range1) 20;
    assert_equal (DieFace.num_values die_side_range2) 32;
    assert_equal (DieFace.num_values die_side_range3) 11
  in

  let title = "'num_faces' returns correct number" in

  title >:: test

let roll_side_always_returns_same_value =
  let test _ =
    let die_side = DieFace.singleton "Base" (Range.make 1 1) in
    let res =
      DieResultGroup.empty
      |> DieResultGroup.add (DieResult.make "Base" 1)
    in

    assert_equal (DieFace.roll die_side) res
  in

  let title = "'roll' on Side always returns same value" in

  title >:: test

let roll_range_returns_value_between_range =
  let test _ =
    let die_range =
      DieFace.singleton "Base" (Range.make 1 20)
    in

    let roll_value =
      DieFace.roll die_range
      |> DieResultGroup.fold (fun x acc -> acc + (DieResult.total x)) 0
    in

    assert_bool "Die Result out of range 1-20" (roll_value >= 1 && roll_value <= 20)
  in

  let title = "'roll' on Range returns value between range" in

  title >:: test

let tests =
  "Die Face" >:::
  [
    name_always_returns_name;
    num_faces_returns_correct_number;
    roll_side_always_returns_same_value;
    roll_range_returns_value_between_range;
  ]
