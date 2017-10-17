open Containers
open Containers.Fun

type t = DieFaceValue.t list

let singleton name range =
  [ DieFaceValue.make name range ]

let num_values side =
  List.fold_left (fun acc x ->
      acc + (Range.total (DieFaceValue.value x))
  ) 0 side

let equals face1 face2 =
  List.map2 DieFaceValue.equals face1 face2
  |> List.fold_left (fun acc x -> acc || x) false

let contains value face =
  List.fold_left
    (fun acc x -> acc || (DieFaceValue.equals x value))
    false
    face

let roll side =
  side
  |> List.map DieFaceValue.roll
  |> DieResultGroup.(List.fold_left (flip add) empty)

let to_string face =
  face
  |> List.map DieFaceValue.to_string
  |> String.concat ", "
  |> Format.sprintf "[%s]"
