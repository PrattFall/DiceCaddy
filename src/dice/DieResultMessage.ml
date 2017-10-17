type t =
  | ResultCouldNotBeCalculated

let show m =
  match m with
  | ResultCouldNotBeCalculated -> "The result of your roll could not be calculated."
