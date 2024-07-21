::fe.add_text(split(::fe.script_dir, "/").top(), 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomLeft;
::fe.add_text(split(::fe.script_file, ".")[0], 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomRight;
//===================================================

::fe.load_module("mask");

// settings
local x = 50;
local y = 50;
local w = 90;
local h = 60;
local p = 20;
local row = 0;

// checkerboard background
local surf = ::fe.add_surface(16, 16);
local bg = surf.add_image("images/checker.png");
surf.set_pos(0, 0, ::fe.layout.width, ::fe.layout.height);
surf.subimg_width = ::fe.layout.width;
surf.subimg_height = ::fe.layout.height;
surf.repeat = true;
surf.alpha = 100;

// examples
function draw_example(title, name, mask_type = MaskType.Multiply) {
    local a = ::fe.add_artwork("snap", x, y + (row++) * (h + p) w, h);
    a.video_flags = Vid.ImagesOnly;

    local m = ::fe.add_image("images/" + name + ".png", a.x + w + p, a.y, a.width, a.height);
    local r = Mask(::fe.add_clone(a));
    r.x = m.x + w + p;
    r.mask = m;
    r.mask_type = mask_type;

    local t = ::fe.add_text(title, r.x + w + p, r.y, w*10, h);
    t.align = Align.MiddleLeft;
    t.char_size = h/2;
    t.margin = 0;
}

draw_example("White Solid", "solid_white");
draw_example("White Transparent", "grad_white");
draw_example("Black Solid", "solid_black");
draw_example("Black Transparent", "grad_black");
draw_example("Red Solid", "solid_red");
draw_example("Red Transparent", "grad_red");
draw_example("Gradient", "grayscale");
draw_example("Gradient + MaskType.Grayscale", "grayscale", MaskType.Grayscale);
