(** FSQ *)

module type S = sig
  type t
  type k

  val empty : int -> t
  val is_empty : t -> bool
  val size : t -> int
  val mem : k -> t -> bool
  val push : k -> t -> t
  val pop : t -> (k * t) option
  val fold : (k -> int -> 'a -> 'a) -> 'a -> t -> 'a
  val iter : (k -> int -> unit) -> t -> unit
  val to_list : t -> k list
  val of_list : int -> k list -> t
end

module type Ordered = sig
  type t
  val compare : t -> t -> int
end

module Make (K: Ordered) : S with type k = K.t = struct

  module I = struct
    type t = int
    let compare (a: int) b =
      compare a b
  end

  module PsqK = Psq.Make(K)(I)

  type k = K.t

  type t = {
      psq: PsqK.t;
      maxp: int;
      len: int;
    }

  let empty len =
    { psq = PsqK.empty;
      maxp = min_int;
      len }

  let is_empty t =
    PsqK.is_empty t.psq

  let size t =
    PsqK.size t.psq

  let mem k t =
    PsqK.mem k t.psq

  let pop t =
    match PsqK.pop t.psq with
      | Some ((k, _p), psq) -> Some (k, { t with psq })
      | _ -> None

  let push k t =
    let t =
      if t.maxp + PsqK.size t.psq < max_int
      then t
      else (* shift priorities down starting from min_int again *)
        let minp = match PsqK.min t.psq with
          | Some (_k,p) -> p
          | None -> min_int in
        let d = minp - min_int in
        PsqK.fold
          (fun k p t ->
            { t with
              psq = PsqK.adjust (fun p -> p - d) k t.psq;
              maxp = p - d })
          t t.psq in
    let maxp = t.maxp + 1 in
    let psq = PsqK.add k maxp t.psq in
    let t = { t with psq; maxp } in
    if PsqK.size t.psq <= t.len
    then t
    else { t with
           psq = match PsqK.pop t.psq with
                 | Some ((_k, _p), q) -> q
                 | _ -> t.psq }

  let fold f z t =
    let minp = match PsqK.min t.psq with
      | Some (_k,p) -> p
      | None -> min_int in
    PsqK.fold
      (fun k p z ->
        f k (p - minp) z)
      z t.psq

  let iter f t =
    let minp = match PsqK.min t.psq with
      | Some (_k,p) -> p
      | None -> min_int in
    PsqK.iter
      (fun k p ->
        f k (p - minp))
      t.psq

  let to_list t =
    List.map
      (fun (k,_p) -> k)
      (PsqK.to_list t.psq)

  let of_list len ks =
    let psq = PsqK.of_sorted_list @@
                List.mapi (fun p k -> (k, min_int + p + 1)) ks in
    let maxp = min_int + List.length ks in
    { psq; maxp; len }

end
