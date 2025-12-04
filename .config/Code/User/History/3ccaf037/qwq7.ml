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
  helper [] None list
;;

flatten [One "a"; Many [One "b"; Many [One "c" ;One "d"]; One "e"]];;
compress ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"];;