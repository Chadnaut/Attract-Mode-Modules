fe.load_module("chart");
::chart <- Chart();

local budget = 1000.0 / ScreenRefreshRate; // 16.6666ms
::chart.add("frame", budget, 0, @(v, t) t - budget);
function my_func1() { ::chart.add("style", 100); }
function my_func2() { ::chart.add("shader", 100); }
function my_func3() { ::chart.add("geometry", 100); }
function my_func4() { ::chart.add("animation", 100); }

fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    local m = (ttime < 3000) ? (ttime.tofloat() / 30.0) : 100.0;
    for (local i=0, n=(m * rand() / RAND_MAX); i < n; i++) my_func1();
    for (local i=0, n=(m * rand() / RAND_MAX); i < n; i++) my_func2();
    for (local i=0, n=(m * rand() / RAND_MAX); i < n; i++) my_func3();
    for (local i=0, n=(m * rand() / RAND_MAX); i < n; i++) my_func4();
}

on_tick(0);