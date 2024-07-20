::fe.add_text(split(::fe.script_dir, "/").top(), 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomLeft;
::fe.add_text(split(::fe.script_file, ".")[0], 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomRight;
//===================================================

::fe.load_module("blur");

local flw = ::fe.layout.width;
local flh = ::fe.layout.height;
local x1 = flw * 0.05;
local y1 = flh * 0.05;
local w = (flw - (x1 * 3)) / 2;
local h = (flh - (y1 * 5)) / 2;
local th = y1*0.75;
local x2 = x1*2 + w;
local y2 = y1*2 + h;
local blur = w / 5;
local filename = "check.png";

//===================================================

local mask1 = ::fe.add_image("masks/linear.png");
mask1.visible = false;

local mask2 = ::fe.add_surface(256, 256);
local mask2i = mask2.add_image("masks/radial.png");
mask2i.repeat = true;
mask2.visible = false;

//===================================================

::fe.add_text("Linear Mask", x1, y1+h, w, th);
local a = ::fe.add_clone(mask1);
a.visible = true;
a.set_pos(x1, y1, w, h);

::fe.add_text("Linear Mask 2-Pass", x2, y1+h, w, th);
local bs = Blur(::fe.add_surface(w, h));
local bi = Blur(bs.add_image(filename, 0, 0, w, h));
bs.set_pos(x2, y1);
bs.blur_size = blur;
bs.blur_mask = mask1;
bi.blur_size = blur;
bi.blur_mask = mask1;
bi.blur_rotation = 90;

::fe.add_text("Radial Mask", x1, y2+h, w, th);
local c = ::fe.add_clone(mask2);
c.visible = true;
c.set_pos(x1, y2, w, h);

::fe.add_text("Radial Mask 2-Pass", x2, y2+h, w, th);
local ds = Blur(::fe.add_surface(w, h));
local di = Blur(ds.add_image(filename, 0, 0, w, h));
ds.set_pos(x2, y2);
ds.blur_size = blur;
ds.blur_mask = mask2;
di.blur_size = blur;
di.blur_mask = mask2;
di.blur_rotation = 90;

//===================================================

::fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    mask2i.subimg_x = ttime / 20.0;
}