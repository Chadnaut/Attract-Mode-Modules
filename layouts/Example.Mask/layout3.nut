fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
fe.add_text(split(fe.script_file, ".")[0], 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomRight;
//===================================================

fe.load_module("mask");

// settings
local x = 50;
local y = 50;
local w = 90 * 2;
local h = 60 * 2;
local p = 20;
local row = 0;

// checkerboard background
local surf = fe.add_surface(16, 16);
local bg = surf.add_image("images/checker.png");
surf.set_pos(0, 0, fe.layout.width, fe.layout.height);
surf.subimg_width = fe.layout.width;
surf.subimg_height = fe.layout.height;
surf.repeat = true;
surf.alpha = 100;

// examples
function draw_example(title, mask_type = MaskType.Multiply) {
    local a = fe.add_artwork("snap", x, y + (row++) * (h + p) w, h);
    a.video_flags = Vid.ImagesOnly;

    // here we're using a surface as the mask
    // - the artwork inside uses preserve_aspect_ratio, which doesn't apply to the mask texture
    // - when the artwork is inside a surface it works fine
    local m = fe.add_surface(a.width, a.height);
    m.set_pos(a.x + w + p, a.y);
    local a2 = m.add_artwork("wheel", 0, 0, a.width, a.height);
    a2.preserve_aspect_ratio = true;

    local r = Mask(fe.add_clone(a));
    r.x = m.x + w + p;
    r.mask = m;
    r.mask_type = mask_type;
    r.mask_mirror_y = true;

    local t = fe.add_text(title, r.x + w + p, r.y, w*10, h);
    t.align = Align.MiddleLeft;
    t.char_size = h/2;
    t.margin = 0;
}

draw_example("Multiply", MaskType.Multiply);
draw_example("Grayscale", MaskType.Grayscale);
draw_example("Alpha", MaskType.Alpha);
draw_example("Cutout", MaskType.Cutout);
