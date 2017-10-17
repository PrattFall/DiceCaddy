open Containers
open Containers.Fun
open Lwt
open Cohttp
open Cohttp_lwt_unix

open DiceLib
open DiceParser

let parse_query query =
  "?" ^ query
  |> Uri.of_string
  |> (flip Uri.get_query_param) "message"
  |> Containers.Option.get_or ~default:"No param 'message' supplied.\n"
  |> Parser.TelegramMessage.parse

let send_response body =
  Server.respond_string ~status:`OK ~body:body ()

let respond db _conn req body =
  Cohttp_lwt.Body.to_string body
  >|= parse_query
  >>= send_response
