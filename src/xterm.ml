open Brr

module Terminal = struct
  type t = Jv.t

  let to_jv (opts : t) : Jv.t = opts
  let of_jv (opts : Jv.t) : t = opts

  type opts = Jv.t

  let opts_to_jv (opts : opts) : Jv.t = opts
  let opts_of_jv (opts : Jv.t) : opts = opts

  let opts ?cursor_blink () =
    let o = Jv.obj [||] in
    Jv.Bool.set_if_some o "cursorBlink" cursor_blink;
    o

  let v ?opts () =
    let maker = Jv.get (Window.to_jv G.window) "Terminal" in
    let opts = Option.value ~default:(Jv.obj [||]) opts in
    Jv.new' maker [| opts |]

  let open_ t el =
    let _ : Jv.t = Jv.call t "open" [| El.to_jv el |] in
    ()

  let buffer_x t =
    let core = Jv.get t "_core" in
    let buffer = Jv.get core "buffer" in
    Jv.get buffer "x" |> Jv.to_int

  let write t s =
    let _ : Jv.t = Jv.call t "write" [| Jv.of_jstr s |] in
    ()

  let write' t s = write t (Jstr.of_string s)

  let is_initialised t = Jv.get t "_initialized" |> Jv.to_bool

  let on_data t fn =
    let fn' jv =
      fn (Jv.to_jstr jv)
    in
    let _ : Jv.t = Jv.call t "onData" [| Jv.callback ~arity:1 fn' |] in
    ()
end