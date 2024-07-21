::fe.add_text(split(::fe.script_dir, "/").top(), 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomLeft;
//===================================================

::fe.load_module("retention");

local s1 = ::fe.add_surface(::fe.layout.width, ::fe.layout.height);
local s2 = Retention(s1);
s2.persistence = 0.99;
s2.set_rotation_origin(0.5, 0.5);
s2.rotation = 0.5;

local img = s1.add_artwork("snap", 0, 0, 50, 50);
img.video_flags = Vid.ImagesOnly;
img.set_anchor(0.5, 0.5);
img.set_rotation_origin(0.5, 0.5);

local x_inc = 4;
local y_inc = 4;
local r_inc = 5;

::fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    img.x += x_inc;
    img.y += y_inc;
    img.rotation += r_inc;
    if (img.x >= ::fe.layout.width || img.x <= 0) { x_inc *= -1; r_inc *= -1; }
    if (img.y >= ::fe.layout.height || img.y <= 0) { y_inc *= -1; r_inc *= -1; }
};