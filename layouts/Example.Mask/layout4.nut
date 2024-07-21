::fe.add_text(split(::fe.script_dir, "/").top(), 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomLeft;
::fe.add_text(split(::fe.script_file, ".")[0], 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomRight;
//===================================================

::fe.load_module("mask");

local flw = ::fe.layout.width;
local flh = ::fe.layout.height;

//===================================================
// moving mask within surface

local surf = ::fe.add_surface(flw/2, flh/2);
surf.visible = false;

local mask = surf.add_image("images/circle.png", 0, 0, 200, 200);
mask.set_anchor(0.5, 0.5);

local snap = Mask(::fe.add_artwork("snap", flw/2, flh/2, flw/2, flh/2));
snap.video_flags = Vid.ImagesOnly;
snap.set_anchor(0.5, 0.5);
snap.mask = surf;

//===================================================

// some animation to move mask
local x_inc = 4;
local y_inc = 3;
::fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    mask.x += x_inc;
    mask.y += y_inc;
    if ((mask.x > surf.width && x_inc > 0) || (mask.x < 0 && x_inc < 0)) x_inc *= -1;
    if ((mask.y > surf.height && y_inc > 0) || (mask.y < 0 && y_inc < 0)) y_inc *= -1;
}