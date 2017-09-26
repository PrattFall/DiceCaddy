module P = Postgresql

open DiceLib

val sql_error : SQLMessage.t -> Message.t

val database_error : P.error -> Message.t

val connect :
  string ->
  unit ->
  (P.connection, Message.t) result

val prepare :
  string ->
  string ->
  (P.connection, Message.t) result ->
  (P.connection, Message.t) result

val exec_prepared :
  string ->
  params:string array ->
  (P.connection, Message.t) result ->
  (P.result, Message.t) result

val get_field :
  int ->
  string ->
  P.result ->
  (string, Message.t) result

val num_columns : P.result -> int

val num_rows : P.result -> int

val start_transaction : (P.connection, Message.t) result -> unit

val end_transaction : (P.connection, Message.t) result -> unit

val rollback_transaction : (P.connection, Message.t) result -> unit

val wrap_transaction :
  (unit -> P.result list * Message.t list) ->
  (P.connection, Message.t) result ->
  (P.result list * Message.t list)
