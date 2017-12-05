let get member_name json =
  json
  |> Yojson.Basic.Util.member member_name

let get_string member_name json =
  json
  |> get member_name
  |> Yojson.Basic.Util.to_string

let get_int member_name json =
  json
  |> get member_name
  |> Yojson.Basic.Util.to_int
