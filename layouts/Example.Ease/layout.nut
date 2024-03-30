fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("retention");
fe.load_module("ease");

local duration = 2000;
local rows = 5;
local cols = 10;

local easings = [
    ::ease.in_quad,
    ::ease.in_cubic,
    ::ease.in_quart,
    ::ease.in_quint,
    ::ease.in_sine,
    ::ease.in_expo,
    ::ease.in_circ,
    ::ease.in_elastic,
    ::ease.in_back,
    ::ease.in_bounce,

    ::ease.out_quad,
    ::ease.out_cubic,
    ::ease.out_quart,
    ::ease.out_quint,
    ::ease.out_sine,
    ::ease.out_expo,
    ::ease.out_circ,
    ::ease.out_elastic,
    ::ease.out_back,
    ::ease.out_bounce,

    ::ease.in_out_quad,
    ::ease.in_out_cubic,
    ::ease.in_out_quart,
    ::ease.in_out_quint,
    ::ease.in_out_sine,
    ::ease.in_out_expo,
    ::ease.in_out_circ,
    ::ease.in_out_elastic,
    ::ease.in_out_back,
    ::ease.in_out_bounce,

    ::ease.out_in_quad,
    ::ease.out_in_cubic,
    ::ease.out_in_quart,
    ::ease.out_in_quint,
    ::ease.out_in_sine,
    ::ease.out_in_expo,
    ::ease.out_in_circ,
    ::ease.out_in_elastic,
    ::ease.out_in_back,
    ::ease.out_in_bounce,

    ::ease.get_step_jump_start(10),
    ::ease.get_step_jump_end(10),
    ::ease.get_step_jump_none(10),
    ::ease.get_step_jump_both(10),
    ::ease.get_cubic_bezier(0.0, 0.0, 1.0, 1.0), // linear
    ::ease.get_cubic_bezier(1.0, 0.0, 0.5, 0.5),
    ::ease.get_cubic_bezier(0.25, 2.0, 0.75, -1.0),
    ::ease.get_cubic_bezier(0.5, 1.0, 0.65, 1.5),
    ::ease.linear,
    ::ease.none,
];

local s1 = fe.add_surface(fe.layout.width, fe.layout.height);
local s2 = Retention(s1);
s2.persistence = 0.98;

local items = [];
function add_item(x, y, w, h, ease) {
    local a = s2.add_text("", 0, 0, 6, 6);
    a.set_bg_rgb(255, 255, 255);
    items.push({
        x = x - a.width/2,
        y = y - a.height/2,
        w = w,
        h = h,
        obj = a,
        ease = ease,
    });
}

local i = 0;
local w = fe.layout.width / cols;
local h = fe.layout.height / rows;
for (local y=0; y<rows; y++) {
    for (local x=0; x<cols; x++) {
        add_item(x*w, y*h, w, h, easings[i++ % easings.len()]);
    }
}

fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    local t = (ttime % duration).tofloat();
    foreach (item in items) {
        item.obj.x = item.x + t / duration * item.w;
        item.obj.y = item.y + item.ease(t, item.h, -item.h, duration);
    }
};