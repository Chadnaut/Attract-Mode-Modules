::fe.add_text(split(::fe.script_dir, "/").top(), 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomLeft;
::fe.add_text(split(::fe.script_file, ".")[0], 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomRight;
//===================================================

::fe.load_module("blur");

local flw = ::fe.layout.width;
local flh = ::fe.layout.height;
local x1 = floor(flw * 0.05);
local y1 = floor(flh * 0.05);
local w = (flw - (x1 * 3)) / 2;
local h = (flh - (y1 * 5)) / 2;
local th = y1 * 0.75;
local x2 = x1 * 2 + w;
local y2 = y1 * 2 + h;
local blur = w / 5;
local filename = "check.png";

//===================================================

::fe.add_text("2-Pass", x1, y1 + h, w, th);
local as = Blur(::fe.add_surface(w, h));
local ai = Blur(as.add_image(filename, 0, 0, w, h));
as.set_pos(x1, y1);
as.blur_size = blur;
ai.blur_size = blur;
ai.blur_rotation = 90;

::fe.add_text("2-Pass Anim", x2, y1 + h, w, th);
local bs = Blur(::fe.add_surface(w, h));
local bi = Blur(bs.add_image(filename, 0, 0, w, h));
bs.set_pos(x2, y1);
bs.blur_size = blur;
bi.blur_size = blur;
bi.blur_rotation = 90;

::fe.add_text("Fast", x1, y2 + h, w, th);
local c = Blur(::fe.add_image(filename, x1, y2, w, h));
c.blur_size = blur;
c.blur_fast = true;

::fe.add_text("Fast Anim", x2, y2 + h, w, th);
local d = Blur(::fe.add_image(filename, x2, y2, w, h));
d.blur_size = blur;
d.blur_fast = true;

//===================================================

::fe.add_ticks_callback("on_tick");

function on_tick(ttime) {
    local s = blur * (0.5 * cos(ttime / 1000.0 * PI) + 0.5);
    bs.blur_size = s;
    bi.blur_size = s;
    d.blur_size = s;
}