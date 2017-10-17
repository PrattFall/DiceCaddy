open DiceLib

module P = Postgresql

val make_dice :
  (P.connection, Message.t) result ->
  (P.result, Message.t) result ->
  Die.t list * Message.t list

val get :
  string ->
  (P.connection, Message.t) result ->
  Die.t list * Message.t list

val insert :
  game_id:int ->
  name:string ->
  (P.connection, Message.t) result ->
  P.result list * Message.t list

