(** FSQ: Functional Fixed-size Search Queue *)

(** Signature of fixed-size search queues. *)
module type S = sig

  type t
  (** A search queue. *)

  type k
  (** Keys in {{!t}[t]}. *)

  val empty : int -> t
  (** [empty max_size] is the search queue with [max_size]
      that contains no elements. *)

  val is_empty : t -> bool
  (** [is_empty t] is [true] iff [t] is {{!empty}[empty]}. *)

  val size : t -> int
  (** [size t] is the number of distinct elements in [t]. *)

  val mem : k -> t -> bool
  (** [find k t] is [true] iff [k] exists in [t]. *)

  val push : k -> t -> t
  (** [push k t] is [t] with [k] added to the queue.
      If the queue reached [max_size],
      the oldest element is [pop]ped from the queue.
      If [k] already exists in [t], no operation is performed *)

  val pop : t -> (k * t) option
  (** [pop t] is [(min t, rest t)], or [None]. *)

  val fold : (k -> int -> 'a -> 'a) -> 'a -> t -> 'a
  (** [fold f z t] is [f k0 p0 (f k1 p1 ... (f kn pn z))].
      Elements are folded over in insertion order
      where p is the index of the element starting from 0. *)

  val iter : (k -> int -> unit) -> t -> unit
  (** [iter f t] applies [f] to all elements in [t] in insertion order. *)

  val to_list : t -> k list
  (** [to_list t] are all the elements in [t] in insertion order. *)

  val of_list : int -> k list -> t
  (** [of_list max_size ks] is a [t] of [max_size] with the elements from [ks].
      The elements are [push]ed to to the queue from the beginning of the list,
      thus the last [max_size] elements from the list would end up in the queue. *)

end

(** Signature of ordered types. *)
module type Ordered = sig
  type t
  val compare : t -> t -> int
  (** [compare] is a total order on {{!t}[t]}. *)
end

(** [Make(K)] is the {{!S}fixed-size search queue} with keys [K.t]. *)
module Make (K: Ordered) : S with type k = K.t
