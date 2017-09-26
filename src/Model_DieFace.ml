module P = Postgresql

open DiceLib
open Containers

type connection = P.connection

type error_list = Message.t list

let make_die_face_group conn groups_data =
  let build_row groups row =
    let open Result.Infix in
    (DB.get_field row "length" groups) >>= (fun length_string ->
    (DB.get_field row "id" groups) >>= (fun id_string ->
      let length  = int_of_string length_string in
      let face_id = int_of_string id_string in
      let (values, errors) = DieFaceValueM.get face_id conn in

      Ok (DieFaceGroup.make length values, errors);
    ))
  in

  match groups_data with
  | Ok groups ->
    groups
    |> CommonM.for_all_rows conn (build_row groups)
    |> CommonM.separate
    |> QueryResult.combine_result_errors
  | Error e -> QueryResult.error e

let get die_id conn =
  let sql = "SELECT * FROM DieFace WHERE die_id = $1;" in
  conn
  |> DB.prepare "get_die_face_group" sql
  |> DB.exec_prepared "get_die_face_group" ~params:[|string_of_int die_id|]
  |> make_die_face_group conn

let insert ~die_id ~amount ~values conn =
  let query_type = "insert_face" in

  let sql =
    "INSERT INTO DieFace (die_id, length) VALUES ($1, $2) RETURNING id;"
  in

  let params = [| string_of_int die_id
                ; string_of_int amount
               |]
  in

  let do_insert () =
    let open Result.Infix in

    let insert_value conn face_id value =
      DieFaceValueM.insert ~face_id ~value conn
    in

    match
      conn
      |> DB.prepare query_type sql
      |> DB.exec_prepared query_type ~params
      >>= (DB.get_field 0 "id")
      >>= (fun face_id_string -> Ok (int_of_string face_id_string))
    with
    | Ok face_id ->
      List.map (insert_value conn face_id) values
      |> CommonM.separate
    | Error e -> QueryResult.error e
  in

  DB.wrap_transaction do_insert conn
