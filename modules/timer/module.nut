// Timer
//
// > Call a function at a later time
// > Version 0.2.0
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

class Timer {
    static _timers = {};

    static _timer_defaults = {
        start_time = 0,
        start_frame = 0,
        delay = 0,
        repeat = false,
        callback = null,
        iteration = 0,
    };

    static _global = {
        id = 0,
        frame = 0,
    };

    static add = function(callback, delay, repeat) {
        local timer_id = _global.id++;
        local timer = _timers[timer_id] <- clone _timer_defaults;
        timer.start_time = delay ? ::fe.layout.time : null;
        timer.start_frame = _global.frame;
        timer.delay = delay.tointeger();
        timer.repeat = !!repeat;
        timer.callback = callback;
        return timer_id;
    }

    static remove = function(id) {
        if (!(id in _timers)) return false;
        delete _timers[id];
        return true;
    }

    static on_tick = function(_ttime) {
        _global.frame++;
        local tick_time = ::fe.layout.time;
        local frame = _global.frame;
        local start_time;
        local delay;
        local repeat;
        local prev_iteration;
        local next_iteration;
        local callback;
        local iteration;

        foreach (id, timer in _timers) {
            start_time = timer.start_time;

            // special case (delay == 0) starts on next frame
            if (start_time == null && timer.start_frame == frame) {
                timer.start_time = tick_time;
                continue;
            }

            delay = timer.delay;
            repeat = timer.repeat;
            callback = timer.callback;

            prev_iteration = timer.iteration;
            next_iteration = delay ? ((tick_time - start_time) / delay) : (prev_iteration + 1);
            timer.iteration = next_iteration;

            // may need to fire callback multiple times if iteration is smaller than time passed
            for (iteration = prev_iteration; iteration < next_iteration; iteration++) {
                callback();
                if (!repeat) remove(id);

                // check timer still exists (may be removed during callback)
                if (!(id in _timers)) break;
            }
        }
    }
}

::fe.add_ticks_callback(Timer, "on_tick");

::set_timeout <- @(callback, delay = 0) Timer.add(callback, delay, false);
::set_interval <- @(callback, delay = 0) Timer.add(callback, delay, true);

::clear_timeout <- @(id) Timer.remove(id);
::clear_interval <- @(id) Timer.remove(id);
