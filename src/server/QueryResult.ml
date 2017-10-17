open DiceLib

type 'a t = 'a list * Message.t list

let empty = ([],[])

let add_error e (rs, es) = (rs, e :: es)

let add_result r (rs, es) = (r :: rs, es)

let error e = empty |> add_error e

let result e = empty |> add_result e

let combine (rs1, es1) (rs2, es2) = (rs1 @ rs2, es1 @ es2)

(* There might be a better way of thinking through this problem. *)
(* When dealing with queries there will often be a result of type
   (ResultType, Message.t list) list
   This is slightly annoying at the very least to convert to the expected
   (ResultType list, Message.t list)
   That is all this function does. Hopefully I can find a more meaningful answer
   at some point.
*)
let combine_result_errors (results, errs) =
  let (new_results, new_errs) =
    List.fold_left
      (fun (xs1, ys1) (xs2, ys2) -> (xs2 :: xs1, ys2 @ ys1)) empty results
  in

  (new_results, new_errs @ errs)
