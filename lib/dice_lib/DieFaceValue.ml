open Containers

type t =
  { name : string
  ; value : Range.t
  }

let make name value =
  { name; value }

let value dfv = dfv.value

let name dfv = dfv.name

let equals side1 side2 =
  (side1.name = side2.name) && (Range.equals side1.value side2.value)

let roll dfv =
  DieResult.make dfv.name (Rand.in_range dfv.value)

let to_string dfv =
  Format.sprintf "'%s' %s" dfv.name (Range.to_string dfv.value)
