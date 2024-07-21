::fe.add_text(split(::fe.script_dir, "/").top(), 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomLeft;
//===================================================

::fe.load_module("logplus");

::logplus.show_time = true;
::logplus.show_frame = true;

::logplus("INFO", "ALERT", "WARNING");
::logplus({ a = 1, b = 2.0, c = ["d", "e"] });
::logplus(getconsttable().Transition);

// ::logplus(getconsttable()); // un-comment to log the entire constants table

::fe.add_text("See last_run.log", 0, 0, ::fe.layout.width, ::fe.layout.height).char_size = ::fe.layout.height / 20;