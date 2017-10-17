open Format

type t =
  | Database of string (*Postgresql.error*)
  | NoFieldWithName of string
  | NoResultFound

let show m =
  match m with
  | Database p -> sprintf "Database Error: %s" p
  | NoFieldWithName name -> sprintf "No such field with name '%s'" name
  | NoResultFound -> "No results found"
