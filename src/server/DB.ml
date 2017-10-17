module P = Postgresql

open DiceLib

let sql_error e =
  (Message.SQLMessage e)

let database_error e =
  sql_error (SQLMessage.Database (P.string_of_error e))

let connect info () =
  try
    Ok (new P.connection ~conninfo:info ())
  with
  | P.Error e -> Error (database_error e)

let prepare query_type query conn =
  try
    match conn with
    | Ok c -> c#prepare query_type query; Ok c
    | Error e -> Error e
  with
  | P.Error e -> Error (database_error e)

let exec_prepared query_type ~params (conn : (P.connection, Message.t) result) =
  try
    match conn with
    | Ok c    -> Ok (c#exec_prepared ~params query_type)
    | Error e -> Error e
  with
  | P.Error e -> Error (database_error e)

let get_field row_num name result =
  try
    Ok (result#getvalue row_num (result#fnumber name))
  with
  | P.Error e -> Error (database_error e)
  | Not_found -> Error (sql_error (SQLMessage.NoFieldWithName name))

let num_columns result = result#nfields

let num_rows result = result#ntuples

let start_transaction conn =
  conn
  |> prepare "begin_transaction" "BEGIN;"
  |> exec_prepared "begin_transaction" ~params:[||]
  |> ignore

let end_transaction conn =
  conn
  |> prepare "commit_transaction" "COMMIT;"
  |> exec_prepared "commit_transaction" ~params:[||]
  |> ignore

let rollback_transaction conn =
  conn
  |> prepare "rollback_transaction" "ROLLBACK;"
  |> exec_prepared "rollback_transaction" ~params:[||]
  |> ignore

let wrap_transaction func conn : P.result QueryResult.t =
  start_transaction conn;

  let (items, errors) = func () in

  if List.length errors > 0
  then rollback_transaction conn
  else end_transaction conn;

  (items, errors)
