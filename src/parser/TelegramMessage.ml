open Containers
open DiceLib

type t = {
  chat_id : int;
  name : string;
  text : string;
}

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
