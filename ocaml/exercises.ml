exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations


 (* Video homework helper *)
let first_then_apply array predicate consumer=
  match List.find_opt predicate array with 
  | None -> None
  | Some x -> consumer x


(* Video homework helper *)
let powers_generator base = 
   let rec generate_from power () = 
    Seq.Cons (power, generate_from (power * base))
  in 
  generate_from 1;;



    let meaningful_line_count filename =
      let meaningful_line line =
        let trimmed = String.trim line in
        String.length trimmed > 0 && not (String.get trimmed 0 = '#') (* String.starts_with instead *)
      in
      let the_file = open_in filename in
      let finally () = close_in the_file in
      let rec count_lines count =
        try
          let line = input_line the_file in
          if meaningful_line line then
            count_lines (count + 1)
          else
            count_lines count
        with
        | End_of_file -> count
      in
      Fun.protect ~finally (fun () -> count_lines 0)
    

 (* Video homework helper *)
 type shape =
 | Sphere of float
 | Box of float * float * float

let volume s =
 match s with
 | Sphere r -> Float.pi *. (r ** 3.) *. 4. /. 3.
 | Box (l, w, h) -> l *. w *. h

 let surface_area a =
  match a with
  | Sphere r -> Float.pi *. 4. *. r *. r
  | Box (l, w, h) -> 2.0 *. (l *. w +. w *. h +. h *. l)


 (* Video homework helper *)
 type 'a binary_search_tree =
 | Empty
 | Node of 'a binary_search_tree * 'a * 'a binary_search_tree

let rec size_helper = function
 | Empty -> 0
 | Node (l, _, r) -> 1 + size_helper l + size_helper r

let size tree = size_helper tree

let rec contains_helper v = function
 | Empty -> false
 | Node (l, x, r) -> v = x || contains_helper v (if v < x then l else r)

let contains v tree = contains_helper v tree

let rec inorder_helper = function
 | Empty -> []
 | Node (l, x, r) -> inorder_helper l @ [x] @ inorder_helper r

let inorder tree = inorder_helper tree

let rec insert_helper v = function
 | Empty -> Node (Empty, v, Empty)
 | Node (l, x, r) ->
   if v < x then Node (insert_helper v l, x, r)
   else if v > x then Node (l, x, insert_helper v r)
   else Node (l, x, r)

let insert v tree = insert_helper v tree
