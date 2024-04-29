fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("quicksort");

local flw = fe.layout.width;
local flh = fe.layout.height;
local text = fe.add_text("", 0, flh/6, flw, flh*4/6);
text.char_size = text.height / 10;
text.word_wrap = true;
text.align = Align.TopCentre;
text.margin = 0;

function log_arr(arr) {
    foreach (i, v in arr) text.msg += (i ? ", " : "") + v;
    text.msg += "\n";
}

//===================================================
// Instant quicksort

text.msg += "Quicksort\n";
local arr1 = [1,4,2,5,3];
log_arr(arr1);
::quicksort(arr1);
log_arr(arr1);

//===================================================
// Quicksort generator

text.msg += "\nGenerator\n";
local arr2 = ["a","d","b","e","c"];
log_arr(arr2);
local gen = ::quicksort_generator(arr2);

fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    if (gen) {
        if (gen.getstatus() != "dead") {
            // perform 1 sorting step each tick
            resume gen;
        } else {
            // sorting complete
            gen = null;
            log_arr(arr2);
        }
    }
}