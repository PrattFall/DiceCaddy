open Containers

type t =
  { min : int
  ; max : int
  }

let make n1 n2 =
  { min = min n1 n2
  ; max = max n1 n2
  }

let min r = r.min

let max r = r.max

let equals r1 r2 =
  (r1.min = r2.min) && (r1.max = r2.max)

let total r = r.max - r.min  + 1

let to_string r =
  Format.sprintf "(%d, %d)" r.min r.max
