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
      | h :: tl -> helper (accum ^ (string_of_float h) ^ "") tl
    in
    helper "" orig

let compute_mean l =
  let rec helper accum current_size rest =
    

let () =
  let l = Array.to_list (Array.sub Sys.argv 1 ((Array.length Sys.argv) - 1)) in
  let ll = from_list_string_to_float l in
  let sll = from_list_float_to_string ll in
  print_endline sll
