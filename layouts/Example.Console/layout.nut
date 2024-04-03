// fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("console");

::console <- Console();
::console.x = floor(fe.layout.width / 20);
::console.y = floor(fe.layout.height / 20);
::console.width = floor(fe.layout.width * 18 / 20);
::console.height = floor(fe.layout.height * 17 / 20);
::console.set_text_rgb(128, 116, 220);
::console.set_bg_rgb(68, 55, 165);

::console.char_delay = 10;
::console.line_delay = 100;
::console.line_wait = true;

//===================================================

local bg = fe.add_text("", 0, 0, fe.layout.width, fe.layout.height);
bg.set_bg_rgb(128, 116, 220);
bg.zorder = -1;

//===================================================

::console.print("    **** CHADNAUT 64 BASIC V2 ****");
::console.print();
::console.print(" 64K RAM SYSTEM  38911 BASIC BYTES FREE")
::console.print();
::console.print("READY.");
::console.print(@"LOAD ""*"",8,1");
::console.print();
::console.print("SEARCHING FOR *");
::console.print("LOADING");
::console.print("READY.");
::console.print("RUN");

function rgb() { return 255 * rand() / RAND_MAX; }

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
                ::console.set_bg_rgb(::console.lines_total - 1, rgb(), rgb(), rgb());
            } else {
                ::console.print(rand(), [rgb(), rgb(), rgb()], [rgb(), rgb(), rgb()]);
            }
        }
    }
}
