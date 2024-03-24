fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

local flw = fe.layout.width;
local flh = fe.layout.height;

fe.load_module("frame");

local frame = Frame(fe.add_image("frame.png"));
frame.set_anchor(0.5, 0.5);
frame.set_slice(50, 50, 50, 50);
frame.set_padding(50, 50, 50, 50);

local snap = fe.add_artwork("snap", flw/2, flh/2, flw/2, flh/2);
snap.set_anchor(0.5, 0.5);
snap.video_flags = Vid.ImagesOnly;
snap.alpha = 200;

local w_inc = 3;
local h_inc = 2;
fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    snap.width += w_inc;
    snap.height += h_inc;
    if ((snap.width > flw/2 && w_inc > 0) || (snap.width < flw/8 && w_inc < 0)) w_inc *= -1;
    if ((snap.height > flh/2 && h_inc > 0) || (snap.height < flh/8 && h_inc < 0)) h_inc *= -1;

    frame.set_pos(snap.x, snap.y, snap.width, snap.height);
}