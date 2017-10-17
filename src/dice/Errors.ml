module RollError = struct
  type t =
    | IncorrectSyntax of string
    | DieOrPoolDoesntExist of string
end

module GameError = struct
  type t =
    | NoneLoaded
    (* | GameDoesNotExist of Game.t *)
    (* | DieDoesNotExist of Die.t *)
end

type t =
  | RollError of RollError.t
  | GameError of GameError.t
