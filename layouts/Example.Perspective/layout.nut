fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("perspective");

local img = "check.png";

local x = fe.layout.width * 0.05;
local y = x;
local w = fe.layout.width * 0.425;
local h = w;

local a = fe.add_image(img, x, y, w, h);
local b = fe.add_image(img, x*2+w, y, w, h);

b = Perspective(b);

function set_props(obj) {
    obj.pinch_x = w * 0.25;
    obj.pinch_y = w * 0.25;
}

set_props(a);
set_props(b);
