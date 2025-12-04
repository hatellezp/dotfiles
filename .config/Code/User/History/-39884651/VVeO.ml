let from_list_string_to_float orig_list =
  let rec helper accum origg =
    match origg with 
      | [] -> accum
      | h :: tl -> helper ((float_of_string h) :: accum) tl
  in
  helper [] orig_list

let from_list_float_to_string orig =
    let rec helper accum origg =
      match origg with 
      | [] -> accum
      | h :: tl -> helper (accum ^ (string_of_float h) ^ " ") tl
    in
    helper "" orig

let compute_mean l =
  let rec helper accum current_size rest =
   match rest with
    | [] -> if current_size = 0 then 0. else (float_of_int accum) /. (float_of_int current_size)
    | hd :: tl -> helper (accum + hd) (current_size + 1) tl
  in
  helper 0 0 l

let () =
  let l = Array.to_list (Array.sub Sys.argv 1 ((Array.length Sys.argv) - 1)) in
  let ll = from_list_string_to_float l in
  let lll = List.map int_of_float ll in
  Printf.printf "\n%f\n" (compute_mean lll)
