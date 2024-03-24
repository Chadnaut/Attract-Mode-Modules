fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("mask");

local flw = fe.layout.width;
local flh = fe.layout.height;

//===================================================
// corners

local mask = fe.add_image("mask.png");
mask.visible = false;

local snap = Mask(fe.add_artwork("snap", flw/2, flh/2, flw/2, flh/2));
snap.video_flags = Vid.ImagesOnly;
snap.set_anchor(0.5, 0.5);
snap.mask = mask;
snap.set_mask_slice(50, 50, 50, 50);

//===================================================
// text

local gradient = fe.add_image("gradient.png");
gradient.visible = false;

local surf = Mask(fe.add_surface(flw, flh/8));
local text = surf.add_text("Gradient", 0, 0, surf.width, surf.height);
surf.set_pos(0, flh*5/16);
surf.mask = gradient;
surf.mask_mirror_y = true;

//===================================================
// text cutout

local surf2 = fe.add_surface(flw, flh/8);
local text2 = surf2.add_text("Cutout", 0, 0, surf2.width, surf2.height);
text2.set_bg_rgb(255, 255, 255);
text2.bg_alpha = 255;
text2.set_rgb(0, 0, 0);
surf2.visible = false;

local gradient2 = Mask(fe.add_image("gradient.png", 0, flh*7/16, flw, flh/8));
gradient2.mask = surf2;
gradient2.mask_type = MaskType.Grayscale;
gradient2.mask_mirror_y = true;

//===================================================

local w_inc = 3;
local h_inc = 2;
fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    snap.width += w_inc;
    snap.height += h_inc;
    if ((snap.width > flw/1.25 && w_inc > 0) || (snap.width < flw/6 && w_inc < 0)) w_inc *= -1;
    if ((snap.height > flh/1.25 && h_inc > 0) || (snap.height < flh/6 && h_inc < 0)) h_inc *= -1;
}