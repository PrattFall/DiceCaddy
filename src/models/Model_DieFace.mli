module P = Postgresql

open DiceLib

val make_die_face_group :
  (P.connection, Message.t) result ->
  (P.result, Message.t) result ->
  DieFaceGroup.t list * Message.t list

val get :
  int ->
  (P.connection, Message.t) result ->
  DieFaceGroup.t list *  Message.t list

val insert :
  die_id:int ->
  amount:int ->
  values:DieFaceValue.t list ->
  (P.connection, Message.t) result ->
  P.result list * Message.t list
