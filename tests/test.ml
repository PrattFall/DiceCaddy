open OUnit2

module Range = struct
  let tests =
    "Range" >:::
    []
end

module Die = struct
  let tests =
    "Die" >:::
    []
end

let () =
  run_test_tt_main
    ("Dice Server" >:::
     [
       DieResult.tests;
       DieResultGroup.tests;
       Rand.tests;
       DieFace.tests;
       DieFaceGroup.tests;
       Die.tests;
       DiceParser_Telegram.tests;
     ])
