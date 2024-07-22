::fe.add_text(split(::fe.script_dir, "/").top(), 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomLeft;
::fe.add_text(split(::fe.script_file, ".")[0], 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomRight;
//===================================================

::fe.load_module("blur");
::fe.do_nut("utils.nut");

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

local mask1 = ::fe.add_image("masks/zoom.png");
mask1.visible = false;

//===================================================

::fe.add_text("Channels", x1, y1+h, w, th);
draw_channels(mask1, x1, y1, w, h);

::fe.add_text("Directional", x2, y1+h, w, th);
local b = Blur(::fe.add_image(filename, x2, y1, w, h));
b.blur_size = blur;
b.blur_mask = mask1;
b.blur_channel = true;

::fe.add_text("Directional Rotated 90°", x1, y2+h, w, th);
local c = Blur(::fe.add_image(filename, x1, y2, w, h));
c.blur_size = blur;
c.blur_mask = mask1;
c.blur_channel = true;
c.blur_rotation = 90;

::fe.add_text("Directional Anim", x2, y2+h, w, th);
local d = Blur(::fe.add_image(filename, x2, y2, w, h));
d.blur_size = blur;
d.blur_mask = mask1;
d.blur_channel = true;
d.blur_rotation = 90;

//===================================================

::fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    d.blur_rotation = ttime / 10.0;
}