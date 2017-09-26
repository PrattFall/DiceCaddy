open Containers
open CCList.Infix

open DiceLib

type get_result = ((Die.t * Message.t list), Message.t) result list

module P = Postgresql

let make_dice conn dice_data =
  let build_row dice row =
    let open Result.Infix in
    (DB.get_field row "id" dice)       >>= (fun id_string ->
    (DB.get_field row "die_name" dice) >>= (fun die_name ->
      let die_id = int_of_string id_string in
      let faces, errors = DieFaceM.get die_id conn in

      Ok (Die.make die_name ~faces, errors)
    ))
  in

  match dice_data with
  | Ok dice ->
    dice
    |> CommonM.for_all_rows conn (build_row dice)
    |> CommonM.separate
    |> QueryResult.combine_result_errors
  | Error e -> QueryResult.error e

let get die_name conn =
  conn
  |> DB.prepare "get_dice"  "SELECT * FROM die WHERE die_name = $1;"
  |> DB.exec_prepared "get_dice" ~params:[|die_name|]
  |> make_dice conn

let get_all_by_game game_id conn =
  conn
  |> DB.prepare "get_dice_by_game" "SELECT * FROM die WHERE game_id = $1;"
  |> DB.exec_prepared "get_dice_by_game" ~params:[|game_id|]
  |> make_dice conn

let insert ~game_id ~name conn =
  let query_type = "insert_die" in

  let sql =
    "INSERT INTO Die (game_id, die_name) VALUES ($1, $2) RETURNING id;"
  in

  let params = [| string_of_int game_id
                ; name
               |]
  in

  match
    conn
    |> DB.prepare query_type sql
    |> DB.exec_prepared query_type ~params
  with
  | Ok result -> QueryResult.result result
  | Error err -> QueryResult.error err

