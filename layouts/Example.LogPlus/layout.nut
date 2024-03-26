fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

local is_enabled = ("LogPlus" in fe.plugin);
local msg = "See last_run.log";

if (is_enabled) {
    fe.log("Start");
    fe.log();
    fe.log("Object", { a = 1, b = 2.0, c = ["d", "e"] });
    fe.log("INFO", "Success");
    fe.log("WARNING", "Failure");
    fe.log();
    fe.log("Finish");
} else {
    msg = "Please enable the LogPlus plugin"
}

local info = fe.add_text(msg, 0, 0, fe.layout.width, fe.layout.height);
info.char_size = fe.layout.height / 20;