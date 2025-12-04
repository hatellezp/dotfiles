type 'a node =
  | One of 'a
  | Many of 'a node list
;;

let flatten list =
  let rec aux acc current =
    match current with
    | [] -> acc
    | One x :: tl -> aux (x :: acc) tl
    | Many l :: tl -> aux (aux acc l) tl
  in
  List.rev (aux [] list)
;;

let compress list =
  3
;;

flatten [One "a"; Many [One "b"; Many [One "c" ;One "d"]; One "e"]];;
compress ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"];;