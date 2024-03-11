fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("retention");
fe.load_module("ease");

local duration = 2000;
local rows = 5;
local cols = 10;

local easings = [
    ::ease.inQuad,
    ::ease.inCubic,
    ::ease.inQuart,
    ::ease.inQuint,
    ::ease.inSine,
    ::ease.inExpo,
    ::ease.inCirc,
    ::ease.inElastic,
    ::ease.inBack,
    ::ease.inBounce,

    ::ease.outQuad,
    ::ease.outCubic,
    ::ease.outQuart,
    ::ease.outQuint,
    ::ease.outSine,
    ::ease.outExpo,
    ::ease.outCirc,
    ::ease.outElastic,
    ::ease.outBack,
    ::ease.outBounce,

    ::ease.inOutQuad,
    ::ease.inOutCubic,
    ::ease.inOutQuart,
    ::ease.inOutQuint,
    ::ease.inOutSine,
    ::ease.inOutExpo,
    ::ease.inOutCirc,
    ::ease.inOutElastic,
    ::ease.inOutBack,
    ::ease.inOutBounce,

    ::ease.outInQuad,
    ::ease.outInCubic,
    ::ease.outInQuart,
    ::ease.outInQuint,
    ::ease.outInSine,
    ::ease.outInExpo,
    ::ease.outInCirc,
    ::ease.outInElastic,
    ::ease.outInBack,
    ::ease.outInBounce,

    @(t, b, c, d) ::ease.stepJumpStart(t, b, c, d, 10),
    @(t, b, c, d) ::ease.stepJumpEnd(t, b, c, d, 10),
    @(t, b, c, d) ::ease.stepJumpNone(t, b, c, d, 10),
    @(t, b, c, d) ::ease.stepJumpBoth(t, b, c, d, 10),
    ::ease.cubicBezier(0.0, 0.0, 1.0, 1.0), // linear
    ::ease.cubicBezier(1.0, 0.0, 0.5, 0.5),
    ::ease.cubicBezier(0.25, 2.0, 0.75, -1.0),
    ::ease.cubicBezier(0.5, 1.0, 0.65, 1.5),
    ::ease.linear,
    ::ease.none,
];

local s1 = fe.add_surface(fe.layout.width, fe.layout.height);
local s2 = Retention(s1);
s2.persistance = 0.98;

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