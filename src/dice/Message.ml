type warning = ()

type t =
  | SQLMessage of SQLMessage.t
  | DieResultMessage of DieResultMessage.t
  | TestMessage of string (* DO NOT USE THIS *)

let to_string m =
  match m with
  | SQLMessage sql -> SQLMessage.show sql
  | DieResultMessage re -> DieResultMessage.show re
  | TestMessage m -> m
