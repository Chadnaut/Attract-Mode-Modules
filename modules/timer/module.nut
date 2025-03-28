/**
 * Timer
 *
 * @summary Call a function at a later time.
 * @version 0.3.0 2025-03-27
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Modules
 */

/**
 * Static class used to create Timer objects
 * @private
 */
class Timer {
    /** @private Stores all created timers */
    static _timers = {};

    /** @private Stores last timer id */
    static _global = {
        id = 0,
        frame = 0,
    };

    /** @private Default settings for new timer */
    static _timer_defaults = {
        start_time = 0,
        start_frame = 0,
        delay = 0,
        repeat = false,
        callback = null,
        iteration = 0,
    };

    /**
     * Creates a new Timer
     *
     * Returns an id that can be use to cancel the timer.
     * @param {function} callback The function to call
     * @param {integer} delay The delay between calls
     * @param {boolean} repeat Whether to repeatedly call
     * @returns {integer}
     */
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

    /**
     * Cancels a Timer
     * @param {integer} id The id of the timer to cancel
     * @returns {boolean}
     */
    static remove = function(id) {
        if (!(id in _timers)) return false;
        delete _timers[id];
        return true;
    }

    /**
     * Process all registered Timers
     * @param {integer} _ttime Milliseconds since the layout started
     */
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

// Process the Timers every tick
::fe.add_ticks_callback(Timer, "on_tick");

/**
 * Sets a timer which executes a function after a delay.
 *
 * Returns an id that can be passed to `clear_timeout` to cancel the timer.
 * @param {function} callback The function to call.
 * @param {integer} delay Milliseconds to wait before call.
 * @returns {integer}
 */
set_timeout <- @(callback, delay = 0) Timer.add(callback, delay, false);

/**
 * Sets a timer which repeatedly calls a function with a delay between each call.
 *
 * Returns an id that can be passed to `clear_interval` to cancel the timer.
 * @param {function} callback The function to call.
 * @param {integer} delay Milliseconds between calls.
 * @returns {integer}
 */
set_interval <- @(callback, delay = 0) Timer.add(callback, delay, true);

/**
 * Cancels a `set_timeout` timer.
 * @param {integer} id The id of the timer.
 * @returns {boolean}
 */
clear_timeout <- @(id) Timer.remove(id);

/**
 * Cancels a `set_interval` timer.
 * @param {integer} id The id of the timer.
 * @returns {boolean}
 */
clear_interval <- @(id) Timer.remove(id);
