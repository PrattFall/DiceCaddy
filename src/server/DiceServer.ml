open Containers
open Lwt
open Cohttp
open Cohttp_lwt_unix

open DiceLib
open DiceModels

let db_info =
  Format.sprintf "dbname=%s port=%s host=%s"
    Options.db_name
    Options.db_port
    Options.db_host

let route conn req body =
  let db = DB.connect db_info () in
  let uri_path =  req |> Cohttp.Request.uri |> Uri.path in

  match uri_path with
  | "/telegram" -> Controller.Telegram.respond db conn req body
  | _           -> Controller.NoRoute.respond uri_path

let server () =
  let mode = `TCP (`Port 8443) in
  let server_instance = Server.make ~callback:route () in

  print_endline "Starting server...";

  Server.create ~mode server_instance

let run () =
  server ()
  |> Lwt_main.run
  |> ignore
