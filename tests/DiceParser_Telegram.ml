open OUnit2

open DiceLib
open DiceParser

let full_string_trims_inside_contents =
  let open CCParse in

  let test _ =
    let expected_result = "Test" in

    let input = "\"   Test \t \"" in

    let parsed_input = parse_string TelegramMessage.full_string input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "full strings should be trimmed before output" in

  title >:: test

let roll_is_parsed_correctly =
  let test _ =
    let expected_result =
      (
        TelegramMessage.(Roll [
          DieRoll (1, "D20")
        ])
      )
    in

    let input = "/roll 1 \"D20\"" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "/roll command should return a Roll object with proper input" in

  title >:: test

let roll_works_on_multiple_dice =
  let test _ =
    let expected_result =
      (TelegramMessage.(Roll [
        DieRoll (3, "D8");
        DieRoll (5, "D6");
      ]))
    in

    let input = "/roll 3 \"D8\", 5 \"D6\"" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "/roll command should be able to parse multiple dice at once" in

  title >:: test

let roll_works_with_alternative_spacing =
  let test _ =
    let expected_result =
      (TelegramMessage.(Roll [
        DieRoll (3, "D8");
        DieRoll (5, "D6");
      ]))
    in

    let input = "/roll   3\t \"D8\" , 5 \"D6\"" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "/roll command should be able to parse multiple dice at once" in

  title >:: test

let die_side_parses_correctly =
  let open CCParse in

  let test _ =
    let expected_result =
      [ DieFaceValue.make "Basic" (Range.make 1 20) ]
    in

    let input = "\"Basic\" 1 20" in

    let parsed_input =
      parse_string TelegramMessage.DieSideDescription.parse input
    in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "DieSideDescription.parse correctly parses input" in

  title >:: test

let die_side_parses_multiple_correctly =
  let open CCParse in

  let test _ =
    let expected_result =
      [
        DieFaceValue.make "Basic" (Range.make 1 20);
        DieFaceValue.make "Basic" (Range.make 1  8);
      ]
    in

    let input = "\"Basic\" 1 20, \"Basic\" 1 8" in

    let parsed_input =
      parse_string TelegramMessage.DieSideDescription.parse input
    in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "DieSideDescription.parse correctly parses multiple values" in

  title >:: test

let die_side_parses_alternative_spacing =
  let open CCParse in

  let test _ =
    let expected_result =
      [
        DieFaceValue.make "Basic" (Range.make 1 20);
        DieFaceValue.make "Basic" (Range.make 1  8);
      ]
    in

    let input = "\"Basic\"1   20\t, \"Basic\"  1\t\t 8 " in

    let parsed_input =
      parse_string TelegramMessage.DieSideDescription.parse input
    in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "DieSideDescription.parse correctly parses multiple values" in

  title >:: test

let die_create_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Die (DieCommand.Create "D20"))
    in

    let input = "/die create \"D20\"" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "Die Create syntax is parsed correctly" in

  title >:: test

let die_remove_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Die (DieCommand.Remove "D20"))
    in

    let input = "/die remove \"D20\"" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "Die Remove syntax is parsed correctly" in

  title >:: test

let die_show_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Die (DieCommand.Show "D20"))
    in

    let input = "/die show \"D20\"" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "Die Show syntax is parsed correctly" in

  title >:: test

let die_add_side_is_parsed_correctly =
  let test _ =
    let expected_result =
      (TelegramMessage.(Die (DieCommand.AddSide ("D20", (DieSide.make 1 [
        DieFaceValue.make "Basic" (Range.make 1 20)
      ])))))
    in

    let input = "/die addside \"D20\" 1 \"Basic\" 1 20" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "Die Add Side syntax is parsed correctly" in

  title >:: test

let die_add_complex_side_is_parsed_correctly =
  let test _ =
    let expected_result =
      (TelegramMessage.(Die (DieCommand.AddSide ("Weird", (DieSide.make 1 [
        DieFaceValue.make "Yes" (Range.make 5 60);
        DieFaceValue.make "No"  (Range.make 1 55)
      ])))))
    in

    let input = "/die addside \"Weird\" 1 \"Yes\" 5 60, \"No\" 1 55" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title = "Die Add Side syntax is parsed correctly with complex side" in

  title >:: test

let die_add_side_alternative_spacing_is_parsed_correctly =
  let test _ =
    let expected_result =
      (TelegramMessage.(Die (DieCommand.AddSide ("Weird", (DieSide.make 1 [
        DieFaceValue.make "Yes" (Range.make 5 60);
        DieFaceValue.make "No"  (Range.make 1 55)
      ])))))
    in

    let input =
      "/die   addside\t \"Weird\"1 \"Yes\"\t5 60, \"No\"  1   55"
    in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x -> assert_equal expected_result x
  in

  let title =
    "Die Add Side syntax is parsed correctly with alternative spacing"
  in

  title >:: test

let die_remove_side_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Die (DieCommand.RemoveSide ("Test", 1, 1)))
    in

    let input = "/die removeside \"Test\" 1 1" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x    -> assert_equal expected_result x
  in

  let title = "Die Remove Side syntax is parsed correctly" in

  title >:: test

let die_remove_side_with_alternative_spacing_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Die (DieCommand.RemoveSide ("Test", 1, 1)))
    in

    let input = "/die   removeside\"Test\"\t\t 1  1" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x    -> assert_equal expected_result x
  in

  let title = "Die Remove Side syntax is parsed correctly" in

  title >:: test

let game_create_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Game (GameCommand.Create "Test"))
    in

    let input = "/game create \"Test\"" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x    -> assert_equal expected_result x
  in

  let title = "Game Create syntax is parsed correctly" in

  title >:: test

let game_remove_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Game (GameCommand.Remove "Test"))
    in

    let input = "/game remove \"Test\"" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x    -> assert_equal expected_result x
  in

  let title = "Game Remove syntax is parsed correctly" in

  title >:: test

let game_switch_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Game (GameCommand.Switch "Test"))
    in

    let input = "/game switch \"Test\"" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x    -> assert_equal expected_result x
  in

  let title = "Game Switch syntax is parsed correctly" in

  title >:: test

let game_start_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Game GameCommand.Start)
    in

    let input = "/game start" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x    -> assert_equal expected_result x
  in

  let title = "Game Start syntax is parsed correctly" in

  title >:: test

let game_end_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Game GameCommand.End)
    in

    let input = "/game end" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x    -> assert_equal expected_result x
  in

  let title = "Game End syntax is parsed correctly" in

  title >:: test

let game_list_dice_is_parsed_correctly =
  let test _ =
    let expected_result =
      TelegramMessage.(Game GameCommand.ListDice)
    in

    let input = "/game listdice" in

    let parsed_input = TelegramMessage.parse input in

    match parsed_input with
    | Error e -> assert_failure e
    | Ok x    -> assert_equal expected_result x
  in

  let title = "Game List Dice syntax is parsed correctly" in

  title >:: test

let tests =
  "Telegram Parser" >:::
  [
    full_string_trims_inside_contents;
    roll_is_parsed_correctly;
    roll_works_on_multiple_dice;
    roll_works_with_alternative_spacing;
    die_side_parses_correctly;
    die_side_parses_multiple_correctly;
    die_side_parses_alternative_spacing;
    die_create_is_parsed_correctly;
    die_remove_is_parsed_correctly;
    die_show_is_parsed_correctly;
    die_add_side_is_parsed_correctly;
    die_add_complex_side_is_parsed_correctly;
    die_add_side_alternative_spacing_is_parsed_correctly;
    die_remove_side_is_parsed_correctly;
    die_remove_side_with_alternative_spacing_is_parsed_correctly;
    game_create_is_parsed_correctly;
    game_remove_is_parsed_correctly;
    game_switch_is_parsed_correctly;
    game_start_is_parsed_correctly;
    game_end_is_parsed_correctly;
    game_list_dice_is_parsed_correctly;
  ]
