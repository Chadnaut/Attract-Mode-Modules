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

::fe.add_text("Original", x1, y1 + h, w, th);
local a = ::fe.add_image(filename, x1, y1, w, h);

::fe.add_text("Blur", x2, y1 + h, w, th);
local b = Blur(::fe.add_image(filename, x2, y1, w, h));
b.blur_size = blur;

::fe.add_text("Blur Rotated 90°", x1, y2 + h, w, th);
local c = Blur(::fe.add_image(filename, x1, y2, w, h));
c.blur_size = blur;
c.blur_rotation = 90;

::fe.add_text("Blur 2-Pass", x2, y2 + h, w, th);
local ds = Blur(::fe.add_surface(w, h));
local di = Blur(ds.add_image(filename, 0, 0, w, h));
ds.set_pos(x2, y2);
ds.blur_size = blur;
di.blur_size = blur;
di.blur_rotation = 90;