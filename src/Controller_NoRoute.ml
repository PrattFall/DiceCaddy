open Containers
open Containers.Fun
open Lwt
open Cohttp
open Cohttp_lwt_unix

open DiceLib

let respond uri_path =
  let body =
    Format.sprintf "Route not found for path '%s'.\n" uri_path
  in

  Server.respond_string ~status:`Not_found ~body ()
