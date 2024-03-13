fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("timer");

local txt = fe.add_text("Start", 0, 0, fe.layout.width, fe.layout.height);
txt.char_size = fe.layout.height / 10;

local counter = 0;
function my_func() {
    txt.msg = counter++;
}

set_interval(my_func, 200);
