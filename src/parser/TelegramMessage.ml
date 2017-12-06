open Containers
open DiceLib

open CCParse
open CCParse.Infix

type test_t = {
  chat_id : int;
  name : string;
  text : string;
}

type die_roll = DieRoll of int * string

type t =
  | Roll of die_roll list

let make chat_id  name text =
  { chat_id; name; text; }

let to_string tm =
  String.concat "\n" [
    Format.sprintf "Chat ID: %d" tm.chat_id;
    Format.sprintf "Text: %s" tm.text;
    Format.sprintf "Name: %s" tm.name
  ]

let user_name json =
  let user_json  = JSON.get "from" json in
  let first_name = JSON.get_string "first_name" user_json in
  let last_name  = JSON.get_string "last_name"  user_json in

  first_name ^ " " ^ last_name

let chat_id json =
  json
  |> JSON.get "chat"
  |> JSON.get_int "id"

let of_json json =
  let text = JSON.get_string "text" json in

  make (chat_id json) (user_name json) text

(* Returning a formatted string for now for testing purposes *)
let parse json_string =
  json_string
  |> Yojson.Basic.from_string
  |> of_json
  |> to_string
  |> Format.sprintf "%s\n"

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
