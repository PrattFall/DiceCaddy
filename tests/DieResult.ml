open OUnit2

open DiceLib
open DiceLib.Errors

let shows_appropriate_operator =
  let test _ =
    let dr_positive = DieResult.make "Yup"   1 in
    let dr_zero     = DieResult.make "Yup"   0 in
    let dr_negative = DieResult.make "Yup" (-1) in

    assert_equal (DieResult.to_string dr_positive) ("+1 Yup (+1)");
    assert_equal (DieResult.to_string dr_zero)     ( "0 Yup (0)");
    assert_equal (DieResult.to_string dr_negative) ("-1 Yup (-1)")
  in

  let title = "'show' displays appropriate operators" in

  title >:: test

let adding_value_changes_total =
  let test _ =
    let dr1 = DieResult.add   11  (DieResult.make "Yup"  0) in
    let dr2 = DieResult.add (-11) (DieResult.make "Nope" 0) in

    assert_equal (DieResult.total dr1)   11;
    assert_equal (DieResult.total dr2) (-11)
  in

  let title = "'add' changes total appropriately" in

  title >:: test

let combine_values_combines_total =
  let test _ =
    let dr1 = DieResult.make "Yup"   5  in
    let dr2 = DieResult.make "Yup"  10  in
    let dr3 = DieResult.make "Yup" (-1) in

    let combined_total result1 result2 =
      match (DieResult.combine result1 result2) with
      | Some r -> DieResult.total r
      | None   -> assert_failure "Could not combine results."
    in

    assert_equal (combined_total dr1 dr2) 15;
    assert_equal (combined_total dr1 dr3)  4;
    assert_equal (combined_total dr2 dr3)  9
  in

  let title = "'combine' combines total" in

  title >:: test

let combine_values_combines_values =
  let test _ =
    let dr1 = DieResult.make "Yup"   5  in
    let dr2 = DieResult.make "Yup"  10  in
    let dr3 = DieResult.make "Yup" (-1) in

    let combined_total result1 result2 =
      match (DieResult.combine result1 result2) with
      | Some r -> DieResult.values r
      | None -> assert_failure "Could not combine results."
    in

    assert_equal (combined_total dr1 dr2) [ 5; 10];
    assert_equal (combined_total dr1 dr3) [-1;  5];
    assert_equal (combined_total dr2 dr3) [-1; 10]
  in

  let title = "'combine' combines values and sorts" in

  title >:: test

let tests =
  "Die Result" >:::
  [
    shows_appropriate_operator;
    adding_value_changes_total;
    combine_values_combines_total;
    combine_values_combines_values;
  ]
