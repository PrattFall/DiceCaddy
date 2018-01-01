open Containers
open Containers.Fun
open Lwt
open Cohttp
open Cohttp_lwt_unix

open DiceLib
open DiceParser

(* ONLY FOR TESTING *)
let to_string x =
  match x with
  | TelegramMessage.Roll _    -> "Roll Command Detected"
  | TelegramMessage.Die _     -> "Die Command Detected"
  | TelegramMessage.Game _    -> "Game Command Detected"

let out x =
  match x with
  | Ok y    -> to_string y
  | Error e -> e

let parse_query query =
  "?" ^ query
  |> Uri.of_string
  |> (flip Uri.get_query_param) "message"
  |> Containers.Option.get_or ~default:"No param 'message' supplied.\n"
  |> TelegramMessage.parse
  |> out

let send_response body =
  Server.respond_string ~status:`OK ~body:body ()

let respond db _conn req body =
  Cohttp_lwt.Body.to_string body
  >|= parse_query
  >>= send_response
