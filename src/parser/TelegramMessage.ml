open Containers
open DiceLib

open CCParse
open CCParse.Infix

let slash = char '/'
let comma = char ','
let quote = char '"'

let trim p =
  skip_white *> p <* skip_white

let full_string =
  let non_quote_string = chars1_if (fun c -> c != '"') in
  let bind_trim s = pure (String.trim s) in

  quote *> non_quote_string <* quote
  >>= bind_trim

let sub_command_failure command =
  try_ (U.word >>=
      (fun sub ->
        fail (Format.sprintf
                "No known sub-command '%s' for command '%s'."
                sub
                command)))

let command s =
  slash *> string s <* skip_white

let sub_command s = trim (string s)

(* Syntax: '"%s" %d %d, ...' -> die name, min value, max value *)
module DieSideDescription = struct
  let range =
    trim U.int  >>=
    (fun min -> trim U.int >>=
    (fun max -> pure (Range.make min max)))

  let value =
    trim full_string >>=
    (fun valueName -> trim range >>=
    (fun range -> pure (DieFaceValue.make valueName range)))

  let parse =
    try_ (sep1 ~by:comma value)
end

module DieCommand = struct
  type t =
    | Create of string
    | Remove of string
    | AddSide of string * DieSide.t
    | RemoveSide of string * int * int
    | Show of string

  (* Create a new die *)
  (* Syntax: '/die create "%s"' -> die name *)
  let create =
    try_ (
      sub_command "create" *>
      full_string >>=
      (fun w -> pure (Create w))
    )

  (* Remove a die from the game by name *)
  (* Syntax: '/die remove "%s"' -> die name *)
  let remove =
    try_ (
      sub_command "remove" *>
      full_string >>=
      (fun w -> pure (Remove w))
    )

  (* Show all sides of a die *)
  (* Syntax: '/die show "%s"' -> die name *)
  let show =
    try_ (
      sub_command "show" *>
      full_string >>=
      (fun w -> pure (Show w))
    )

  (* Add a new side to a die *)
  (* Syntax: '/die addside "%s" %d die_value, ...', die name, number added *)
  let add_side =
    let make die_name numAdded value =
      pure (AddSide (die_name, (DieSide.make numAdded value)))
    in

    try_ (
      sub_command "addside" *>
      full_string >>=
      (fun die_name -> trim U.int >>=
      (fun numAdded -> trim DieSideDescription.parse >>=
      (fun value -> make die_name numAdded value)))
    )

  (* Remove a side frmo a die by its id*)
  (* Syntax: '/die removeside "%s" %d %d, die name, num to remove, side id*)
  let remove_side =
    let syntax =
      full_string >>=
      (fun die_name -> trim U.int >>=
      (fun n -> trim U.int >>=
      (fun side_id -> pure (RemoveSide (die_name, n, side_id)))))
    in

    try_ (sub_command "removeside" *> syntax)

  (* Parse any of the above *)
  let parse =
    try_ (command "die") *>
    (
      create <|>
      remove <|>
      show <|>
      add_side <|>
      remove_side
    )
end

module GameCommand = struct
  type t =
    | Create of string
    | Remove of string
    | Switch of string
    | Start
    | End
    | ListDice

  let game_command name =
    sub_command name *>
    full_string

  let create =
    try_ (
      game_command "create" >>=
      (fun w -> pure (Create w))
    )

  let remove =
    try_ (
      game_command "remove" >>=
      (fun w -> pure (Remove w))
    )

  let switch =
    try_ (
      game_command "switch" >>=
      (fun w -> pure (Switch w))
    )

  let start_game =
    try_ (
      sub_command "start" >>=
      (fun w -> pure Start)
    )

  let end_game =
    try_ (
      sub_command "end" >>=
      (fun w -> pure End)
    )

  let list_dice =
    try_ (
      sub_command "listdice" *>
      pure ListDice
    )

  (* Parse any of the above *)
  let parse =
    try_ (command "game") *>
    (
      create <|>
      remove <|>
      switch <|>
      start_game <|>
      end_game <|>
      list_dice <|>
      sub_command_failure "game"
    )
end

type die_roll = DieRoll of int * string

type t =
  | Roll of die_roll list
  | Die of DieCommand.t
  | Game of GameCommand.t

let die =
  U.int <*
  skip_white >>=
  (fun n -> full_string >>=
  (fun w -> pure (DieRoll (n, w))))

let dice =
  sep1 ~by:comma (trim die)

let make_roll ds = pure (Roll ds)

let roll_command =
  try_ (command "roll") *>
  dice >>=
  make_roll

let die_command =
  DieCommand.parse >>= (fun x -> pure (Die x))

let game_command =
  GameCommand.parse >>= (fun x -> pure (Game x))

let unknown_command =
  try_ (slash *> U.word >>= (fun w -> failf "Command '%s' does not exist." w))

let telegram_command =
  roll_command <|>
  die_command <|>
  game_command <|>
  unknown_command <?>
  "Incorrect syntax"

let parse s =
  parse_string telegram_command s
