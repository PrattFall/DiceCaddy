module RollError = struct
  type t =
    | IncorrectSyntax of string
    | DieOrPoolDoesntExist of string
end

(* type pool_error = *)
(*   | RecursionFound of Pool.t * Pool.t *)

module GameError = struct
  type t =
    | NoneLoaded
    (* | GameDoesNotExist of Game.t *)
    (* | DieDoesNotExist of Die.t *)
    (* | PoolDoesNotExist of Pool.t *)
end

type t =
  | RollError of RollError.t
  | GameError of GameError.t
(*   | Pool of pool_error *)
