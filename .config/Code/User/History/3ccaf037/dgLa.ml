type 'a node =
  | One of 'a
  | Many of 'a node list


let flatten l =
  3
;;

flatten [One "a"; Many [One "b"; Many [One "c" ;One "d"]; One "e"]];;