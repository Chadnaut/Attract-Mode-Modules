fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("logfile");
::logfile <- Logfile();

::logfile.time("Start");
::logfile.log();
::logfile.log("Object", { a = 1, b = 2.0, c = ["d", "e"] });
::logfile.info("Success");
::logfile.error("Failure");
::logfile.log();
::logfile.time("Finish");

local info = fe.add_text("See last_run.log", 0, 0, fe.layout.width, fe.layout.height);
info.char_size = fe.layout.height / 20;