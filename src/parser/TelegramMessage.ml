open Containers
open DiceLib

open CCParse
open CCParse.Infix

type die_roll = DieRoll of int * string

let slash = char '/'
let comma = char ','
let quote = char '"'

let command s =
  slash *> string s <* skip_white

let trim p =
  skip_white *> p <* skip_white

let full_string =
  let quoted p = quote *> p <* quote in

  quoted (chars1_if (fun c -> c != '"'))

(* Syntax: '"%s" %d %d, ...' -> die name, min value, max value *)
module DieSideDescription = struct
  let range =
    trim U.int  >>=
    (fun min -> trim U.int >>=
    (fun max -> return (Range.make min max)))

  let value =
    trim full_string >>=
    (fun sideName -> trim range >>=
    (fun range -> return (DieFaceValue.make sideName range)))

  let parse = sep1 ~by:comma value
end

module DieCommand = struct
  type t =
    | Create of string
    | Remove of string
    | AddSide of string * DieSide.t
    | RemoveSide of int * string
    | Show of string

  let die_command = command "die"

  (* Create a new die *)
  (* Syntax: '/die create "%s"' -> die name *)
  let create =
    die_command *>
    trim (string "create") *>
    full_string >>=
    (fun w -> return (Create w))

  (* Remove a die from the game by name *)
  (* Syntax: '/die remove "%s"' -> die name *)
  let remove =
    die_command *>
    trim (string "remove") *>
    full_string >>=
    (fun w -> return (Remove w))

  (* Show all sides of a die *)
  (* Syntax: '/die show "%s"' -> die name *)
  let show =
    die_command *>
    trim (string "show") *>
    full_string >>=
    (fun w -> return (Show w))

  (* Add a new side to a die *)
  (* Syntax: '/die addside "%s" %d "%s" %d %d, ...', die name, number added,
   *         value name, min value, max value
   *)
  let add_side =
    die_command *>
    trim (string "addside") *>
    full_string >>=
    (fun die_name -> trim U.int >>=
    (fun numAdded -> trim DieSideDescription.parse >>=
    (fun value -> return (AddSide (die_name, (DieSide.make numAdded value))))))

  (* Remove a side frmo a die by its id*)
  (* Syntax: '/die removeside "%s" , die name, side id*)
  let remove_side =
    die_command *>
    trim (string "removeside") *>
    full_string >>=
    (fun die_name -> U.int >>=
    (fun side_id -> return (RemoveSide (side_id, die_name))))
end

module GameCommand = struct
  type t =
    | Create of string
    | Remove of string
    | Start of string
    | Switch of string
    | ListDice

  let game_command = command "game"

  let sub_command name =
    game_command *>
    trim (string name) *>
    full_string

  let create =
    sub_command "create" >>=
    (fun w -> return (Create w))

  let remove =
    sub_command "remove" >>=
    (fun w -> return (Remove w))

  let start =
    sub_command "start" >>=
    (fun w -> return (Start w))

  let switch =
    sub_command "switch" >>=
    (fun w -> return (Switch w))

  let list_dice =
    string "listDice" *>
    return ListDice
end

type t =
  | Roll of die_roll list
  | Die of DieCommand.t
  | Game of GameCommand.t

let die =
  U.int <*
  skip_white >>=
  (fun n -> full_string >>=
  (fun w -> return (DieRoll (n, w))))

let dice =
  sep ~by:comma (trim die)

let make_roll ds = return (Roll ds)

let roll_command =
  command "roll" *>
  dice >>=
  make_roll

let parse json_string =
  "Test"
