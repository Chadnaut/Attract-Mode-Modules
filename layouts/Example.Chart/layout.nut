::fe.add_text(split(::fe.script_dir, "/").top(), 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomLeft;
//===================================================

::fe.load_module("chart");

::chart <- Chart();
::chart.x = ::fe.layout.width / 20;
::chart.y = ::fe.layout.height / 20;
::chart.width = ::fe.layout.width * 18 / 20;
::chart.height = 100;
::chart.thickness = 3;
::chart.char_size = 40;
::chart.outline = 5;
::chart.margin = 20;
::chart.alpha = 150;
::chart.align = Align.MiddleRight;

local budget = 1000.0 / ScreenRefreshRate; // 16.6666ms
::chart.add("frame", budget, 0, @(v, t) t - budget);
function my_func1() { ::chart.add("style", 10); }
function my_func2() { ::chart.add("shader", 10); }
function my_func3() { ::chart.add("geometry", 10); }
function my_func4() { ::chart.add("animation", 10); }

function randnum() { return 10.0 * rand() / RAND_MAX; }

::fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    for (local i=0, n=randnum(); i < n; i++) my_func1();
    for (local i=0, n=randnum(); i < n; i++) my_func2();
    for (local i=0, n=randnum(); i < n; i++) my_func3();
    for (local i=0, n=randnum(); i < n; i++) my_func4();
}

::fe.add_signal_handler("on_signal");
function on_signal(signal) {
    if (signal == "custom2") ::chart.visible = !::chart.visible;
}