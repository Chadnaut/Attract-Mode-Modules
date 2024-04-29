fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

::fe.load_module("regex");

local flw = fe.layout.width;
local flh = fe.layout.height;
local text = fe.add_text("", 0, flh/6, flw, flh*4/6);
text.char_size = text.height / 10;
text.word_wrap = true;
text.margin = 0;

local str = "Cat Dog";
local pattern = "([A-Z])([a-z]+)";
local matches = Regex(str).match_all(pattern);

text.msg = format("%s\n", str) + format("%s\n", pattern) + "\n";
text.msg += "[";
foreach (m, match in matches) {
    text.msg += (m ? ", " : "") + "[";
    foreach (g, group in match) {
        text.msg += (g ? ", " : "") + format(@"""%s""", group);
    }
    text.msg += "]";
}
text.msg += "]";
