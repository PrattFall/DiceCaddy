let () =
  (* Initialize Random Seed *)
  Random.self_init ();

  DiceServer.run ()
