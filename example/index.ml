open Brr
open Xterm

let command = ref @@ Jstr.empty

let prompt =
  let p = Jstr.v "\r\n4c-term$ " in
  fun term ->
  command := Jstr.empty;
  Terminal.write term p

let run_command term =
  let l = Jstr.length !command in
  if l > 0 then begin
    Console.log [ command ];
    for _ = 0 to l - 1 do
      Terminal.write' term "\b \b"
    done;
  end

let setup term =
  let on_data jstr =
    match Jstr.to_string jstr with
    | "\u{0003}" (* Ctrl+C *) ->
      Terminal.write' term "^C";
      prompt term
    | "\r" (* Enter *) ->
      run_command term;
      command := Jstr.empty
    | "\u{007F}" (* Backspace *) ->
      (* Don't delete our nice prompt! *)
      if Terminal.buffer_x term > 9 then begin
        Terminal.write' term "\b \b";
        let cmd_length = Jstr.length !command in
        if cmd_length > 0 then begin
          command := Jstr.sub ~start:0 ~len:(cmd_length - 1) !command
        end
      end
    | _ ->
      Console.log [ jstr ];
      command := Jstr.(!command + jstr);
      Terminal.write term jstr
  in
  Terminal.on_data term on_data

let () =
  match Document.find_el_by_id G.document (Jstr.v "terminal") with
  | None -> failwith "No terminal element"
  | Some el ->
    let opts = Terminal.opts () in
    let terminal = Xterm.Terminal.v ~opts () in
    Terminal.open_ terminal el;
    prompt terminal;
    setup terminal