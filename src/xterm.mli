open Brr

module Terminal : sig
  type t
  (** A terminal *)

  val to_jv : t -> Jv.t
  val of_jv : Jv.t -> t

  type opts
  (** Terminal options *)

  val opts_to_jv : opts -> Jv.t
  val opts_of_jv : Jv.t -> opts

  val opts : ?cursor_blink:bool -> unit -> opts
  (** Create some terminal options *)

  val v : ?opts:opts -> unit -> t
  (** Create a new terminal instance *)

  val open_ : t -> El.t -> unit
  (** Open a terminal in an element *)

  val write : t -> Jstr.t -> unit
  (** [write t s] writes [s] to terminal [t] *)

  val write' : t -> string -> unit
  (** Like {! write} but for OCaml strings *)

  val is_initialised : t -> bool
  (** Whether or not the terminal has been initialised *)

  val buffer_x : t -> int
  (** Where the buffer currently is *)

  val on_data : t -> (Jstr.t -> unit) -> unit
  (** Sets the on data IEvent handler for the terminal *)
end