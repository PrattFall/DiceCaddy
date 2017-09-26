open OUnit2

open DiceLib
open DiceLib.Errors

let in_range_accepts_valid_ints =
  let test _ =
    try
      Rand.in_range (Range.make    1    20)  |> ignore;
      Rand.in_range (Range.make (-11)   20)  |> ignore;
      Rand.in_range (Range.make (-20) (-30)) |> ignore
    with
    | Invalid_argument _ -> assert_failure "Invalid Argument Exception"
  in

  let title = "'in_range' accepts all negative integers" in

  title >:: test

let in_range_returns_value_in_range =
  let test _ =
    let between_range mn mx =
      let rnd = Rand.in_range (Range.make mn mx) in
      rnd >= mn && rnd <= mx
    in

    assert_equal (between_range    1    20)  true;
    assert_equal (between_range (-11)   20)  true;
    assert_equal (between_range (-30) (-20)) true
  in

  let title = "'in_range' returns value in range" in

  title >:: test

let tests =
  "Rand" >:::
  [
    in_range_accepts_valid_ints;
    in_range_returns_value_in_range;
  ]
