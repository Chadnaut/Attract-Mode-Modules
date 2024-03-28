fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("stringify");

local value = { a = 1, b = 2.0, c = ["d", "e"] };
local msg = stringify(value, "   ");

local info = fe.add_text(msg, 0, 0, fe.layout.width, fe.layout.height);
info.char_size = fe.layout.height / 20;
info.word_wrap = true;
info.align = Align.MiddleLeft;
