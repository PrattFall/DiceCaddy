open DiceParser

let get =
  (* I can't believe something like this isn't in the standard library *)
  let read_file f =
    let ic = open_in f in
    let n = in_channel_length ic in
    let s = Bytes.create n in
    really_input ic s 0 n;
    close_in ic;
    s
  in

  let config =
    read_file "./config.json"
    |> Yojson.Basic.from_string
  in

  begin fun member ->
    JSON.get_string member config
  end

let api_key =
  get "api_key"

let db_name =
  get "db_name"

let db_port =
  get "db_port"

let db_host =
  get "db_host"
