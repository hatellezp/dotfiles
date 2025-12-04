type 'a node =
  | One of 'a
  | Many of 'a node list
;;

let flatten list =
  let rec aux acc current =
    match current with
    | [] -> acc
    | One x :: tl -> aux (x :: acc) t
    | Many l :: tl -> aux (aux acc l) t
  in
  List.rev (aux [] list)
;;



flatten [One "a"; Many [One "b"; Many [One "c" ;One "d"]; One "e"]];;