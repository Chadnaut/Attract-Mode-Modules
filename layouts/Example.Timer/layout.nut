::fe.add_text(split(::fe.script_dir, "/").top(), 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomLeft;
//===================================================

::fe.load_module("timer");

print(::fe.layout.time + " - Layout started\n");
local done = false;

local title = "Interval";
local txt = ::fe.add_text(title + "\nStart", 0, 0, ::fe.layout.width, ::fe.layout.height);
txt.char_size = ::fe.layout.height / 10;
txt.word_wrap = true;

local counter = 0;
function my_func() {
    txt.msg = title + "\n" + counter++;
    if (!done) print(".\n");
}

set_interval(my_func, 200);

//===================================================

set_timeout(function() {
    print(::fe.layout.time + " - Timeout Fired\n");
    title = "Timeout";
    done = true;
}, 1000);