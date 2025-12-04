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
  let rec helper accum witness current =
    match current with
    | [] -> (if Option.is_none witness then accum else ((Option.get witness) :: accum))
    | hd :: tl -> (
      if Option.is_none witness then (helper accum (Some hd) current)
      else
        let un_witness = Option.get witness in
        if un_witness = hd then helper accum (Some hd) tl
        else helper (un_witness :: accum) (Some hd) tl
    )
      in
  List.rev (helper [] None list)
;;

let rec compress2 list =
  match list with
  | a :: (b :: _ as t) -> if a = b then compress t else a :: compress t
  | smaller -> smaller;;
;;

let pack list =
  let rec helper accum inter current =
    match current with
    | a :: (b :: _ as t) -> if a = b then helper accum 
    

flatten [One "a"; Many [One "b"; Many [One "c" ;One "d"]; One "e"]];;
compress ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"];;
compress2 ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"];;
pack ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "d"; "e"; "e"; "e"; "e"];;



