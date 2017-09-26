module P = Postgresql

open DiceLib
open Containers

type connection = P.connection

let build_row conn die_faces_data =
  let open Result.Infix in

  let build_row_inner die_faces row =
    (DB.get_field row "face_name" die_faces) >>= (fun face_name ->
    (DB.get_field row "range_min" die_faces) >>= (fun range_min_string ->
    (DB.get_field row "range_max" die_faces) >>= (fun range_max_string ->
      let range = Range.make
        (int_of_string range_min_string)
        (int_of_string range_max_string)
      in

      Ok (DieFaceValue.make face_name range)
    )))
  in

  match die_faces_data with
  | Ok die_faces ->
    die_faces
    |> CommonM.for_all_rows conn (build_row_inner die_faces)
    |> CommonM.separate
  | Error e -> QueryResult.error e

let get ~face_id conn =
  let query_type = "get_face" in
  let sql = "SELECT * FROM DieFaceValue where face_id = $1;" in
  let params = [|string_of_int face_id|]in

  conn
  |> DB.prepare query_type sql
  |> DB.exec_prepared query_type ~params
  |> build_row conn

let insert ~face_id ~value conn =
  let query_type = "insert_face_value" in

  let sql =
    "INSERT INTO DieFaceValue (face_id, face_name, range_min, range_max) VALUES ($1,$2,$3,$4);"
  in

  let value_range = DieFaceValue.value value in

  let params =
    [| string_of_int face_id
     ; DieFaceValue.name value
     ; value_range |> Range.min |> string_of_int
     ; value_range |> Range.max |> string_of_int
    |]
  in

  conn
  |> DB.prepare query_type sql
  |> DB.exec_prepared query_type ~params

let delete ~face_id conn =
  let query_type = "delete_face_value" in
  let sql = "DELETE FROM DieFaceValue WHERE face_id = $1;" in
  let params = [|string_of_int face_id|] in

  conn
  |> DB.prepare query_type sql
  |> DB.exec_prepared query_type ~params
