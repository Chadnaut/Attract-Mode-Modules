// fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("console");

::console <- Console();
::console.set_text_rgb(128, 116, 220);
::console.set_bg_rgb(68, 55, 165);
::console.font = "./fonts/C64_Pro_Mono-STYLE.ttf";
::console.char_size = 21;
::console.line_height = 21;
::console.x = floor(fe.layout.width / 20);
::console.y = floor(fe.layout.height / 20);
::console.width = floor(fe.layout.width * 18 / 20);
::console.height = floor(fe.layout.height * 18 / 20);

// C64 font is monospace so we can easily calculate columns and rows
::console.height -= ::console.height % ::console.line_height;
local line_cols = floor(::console.width / ::console.char_size);

::console.char_delay = 10;
::console.line_delay = 100;
::console.line_wait = true;

//===================================================

local bg = fe.add_text("", 0, 0, fe.layout.width, fe.layout.height);
bg.set_bg_rgb(128, 116, 220);
bg.zorder = -1;

//===================================================

local line1 = "**** CHADNAUT 64 BASIC V2 ****";
local line2 = "64K RAM SYSTEM  38911 BASIC BYTES FREE";

// This formatting adds spaces to center the text
// Doing this maintains the left-to-right type-in animation
::console.print(format("%"+floor((line_cols+line1.len())/2)+"s", line1));
::console.print();
::console.print(format("%"+floor((line_cols+line2.len())/2)+"s", line2));
::console.print();
::console.print("READY.");
::console.print(@"LOAD ""*"",8,1");
::console.print();
::console.print("SEARCHING FOR *");
::console.print("LOADING");
::console.print("READY.");
::console.print("RUN");

local col = @() 255 * rand() / RAND_MAX;
local rgb = @() [col(), col(), col()];
local ready_time = null;

fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    if (!(ttime % 5)) {
        if (::console.ready && !ready_time) {
            ready_time = ttime;
            ::console.line_delay = 0;
            ::console.char_delay = 0;
        }
        if (ready_time) {
            if ((ttime - ready_time) < 2000) {
                ::console.set_message(::console.lines_total - 1, rand());
                ::console.set_options(::console.lines_total - 1, { text_rgb = rgb(), bg_rgb = rgb() });
            } else {
                ::console.print(rand(), { text_rgb = rgb(), bg_rgb = rgb() });
            }
        }
    }
}
