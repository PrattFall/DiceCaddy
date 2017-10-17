module P = Postgresql

open DiceLib

val build_row :
  (P.connection, Message.t) result ->
  (P.result, Message.t) result ->
  DieFaceValue.t list * Message.t list

val get :
  face_id:int ->
  (P.connection, Message.t) result ->
  DieFaceValue.t list * Message.t list

val insert :
  face_id:int ->
  value:DieFaceValue.t ->
  (P.connection, Message.t) result ->
  (P.result, Message.t) result

val delete :
  face_id:int ->
  (P.connection, Message.t) result ->
  (P.result, Message.t) result
