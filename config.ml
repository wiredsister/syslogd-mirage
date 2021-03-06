open Mirage

let stack = generic_stackv4 default_console tap0
let conduit_d = conduit_direct stack
let res_dns = resolver_dns stack

let port =
  let doc = Key.Arg.info ~doc:"Listening port" ["p" ; "port" ] in
    Key.(create "port" Arg.(opt ~stage:`Both int 514 doc))

let main =
  foreign
    ~keys:[Key.abstract port]
    "Unikernel.Main" (console @-> stackv4 @-> clock @-> resolver @-> conduit @-> job)

let () =
  add_to_opam_packages["syslog-message"; "irmin"; "lwt"; "decompress"; "mirage-git"];
  add_to_ocamlfind_libraries["syslog-message"; "irmin"; "irmin.git"; "irmin.mirage"; "irmin.mem"; "lwt.ppx"; "decompress"];
  register "syslogd" [main $ default_console $ stack $ default_clock $res_dns $ conduit_d]
