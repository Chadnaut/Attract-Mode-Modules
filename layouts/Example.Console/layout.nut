fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("console");

::console <- Console();
::console.x = floor(fe.layout.width / 20);
::console.y = floor(fe.layout.height / 20);
::console.width = floor(fe.layout.width * 18 / 20);
::console.height = floor(fe.layout.height * 17 / 20);
::console.bg_blue = 255;
::console.bg_alpha = 80;

::console.print("Success", [0, 255, 0]);
::console.print("Neutral");
::console.print({ a = 1, b = 2.0 });
::console.print();
::console.print("Failure", null, [200, 0, 0, 255]);

function rgb() { return 255 * rand() / RAND_MAX; }

fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    if (ttime > 1500 && !(ttime % 5)) {
        if (ttime < 3000) {
            ::console.set_message(::console.lines_total - 1, rand());
            ::console.set_bg_rgb(::console.lines_total - 1, rgb(), rgb(), rgb(), 200);
        } else {
            ::console.print(rand(), [rgb(), rgb(), rgb()], [rgb(), rgb(), rgb(), 200]);
        }
    }
}

fe.add_signal_handler("on_signal");
function on_signal(signal) {
    if (signal == "custom2") ::console.visible = !::console.visible;
}