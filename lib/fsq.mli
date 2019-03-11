(** FSQ: Functional Fixed-size Search Queue *)

(** Signature of fixed-size search queues. *)
module type S = sig

  type t
  (** A search queue. *)

  type k
  (** Keys in {{!t}[t]}. *)

  val empty : int -> t
  (** [empty] is the search queue that contains no elements. *)

  val is_empty : t -> bool
  (** [is_empty t] is [true] iff [t] is {{!empty}[empty]}. *)

  val size : t -> int
  (** [size t] is the number of distinct elements in [t]. *)

  val mem : k -> t -> bool
  (** [find k t] is [true] iff [k] exists in [t]. *)

  val push : k -> t -> t
  (** [push k t] is [t] with [k] added to the end of the queue *)

  val pop : t -> (k * t) option
  (** [pop t] is [(min t, rest t)], or [None]. *)

  val fold : (k -> int -> 'a -> 'a) -> 'a -> t -> 'a
  (** [fold f z t] is [f k0 p0 (f k1 p1 ... (f kn pn z))].
      Elements are folded over in key-ascending order
      where p is the index of the element starting from 0. *)

  val iter : (k -> int -> unit) -> t -> unit
  (** [iter f t] applies [f] to all elements in [t] in key-ascending order. *)

  val to_list : t -> k list
  (** [to_list t] are all the elements in [t] in key-ascending order. *)

  val of_list : int -> k list -> t
  (** [of_list ks] is a [t] with the elements from [ks]. *)

end

(** Signature of ordered types. *)
module type Ordered = sig
  type t
  val compare : t -> t -> int
  (** [compare] is a total order on {{!t}[t]}. *)
end

(** [Make(K)] is the {{!S}fixed-size search queue} with keys [K.t]. *)
module Make (K: Ordered) : S with type k = K.t
