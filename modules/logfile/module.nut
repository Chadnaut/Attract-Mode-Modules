fe.load_module("stringify");

class Logfile {

    space = "    ";
    level = 3;
    limit = null;
    before = null;
    after = null;
    filter = null;

    _count = 0;
    _frame = 0;
    _last_time = 0;

    // patterns for special values
    OBJ = @"{.*}|<.*>";
    BULLET = @"[\s\t\r\n\-]+";
    KEYWORD = @"INFO|NOTICE|ALERT|DEBUG|ERROR|WARN(ING)?";
    DATETIME = @"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}";
    TIMEINFO = @"\d+:\d{2}:\d{2}\.\d{3}(\s\+[\d#]+)?(\s\[[\d#]+\])?";

    constructor() {
        fe.add_ticks_callback(this, "on_tick");
    }

    function on_tick(ttime) {
        _frame++;
    }

    // =============================================

    function error(...) {
        if (level < 1) return;
        print_args(vargv.insert(0, "WARNING") || vargv);
    }

    function info(...) {
        if (level < 2) return;
        print_args(vargv.insert(0, "INFO") || vargv);
    }

    function log(...) {
        if (level < 3) return;
        print_args(vargv);
    }

    function time(...) {
        if (level < 3) return;
        print_args(vargv.insert(0, time_info()) || vargv);
    }

    // =============================================

    // Format and print
    function print_args(args) {
        local value = format_args(args);
        if (value != null) print_value(value);
    }

    // Filter and compose args into printable string
    function format_args(args) {
        if (limit && _count >= limit) return null;
        if (before && fe.layout.time > before) return null;
        if (after && fe.layout.time < after) return null;
        local value = compose_value(args) + "\n";
        if (filter && !regexp(filter).capture(value)) return null;

        _count++
        return value;
    }

    // Format args so they're ready for printing
    function compose_value(args, delimiter = ", ") {
        local value = "";
        local head = 1;
        local arg;

        foreach (i, v in args) {
            arg = stringify(v, space);

            if (i < head) {
                // no quotes if first value special
                arg = !!regexp(@"^""("+OBJ+"|"+BULLET+"|"+KEYWORD+"|"+DATETIME+"|"+TIMEINFO+@")""$").capture(arg)
                    ? arg.slice(1, arg.len() - 1)
                    : arg;

                // no comma if first value indent/bullet
                if (!!regexp(@"^[\s\-]*$").capture(arg)) head++;
            } else {
                value += delimiter;
            }

            value += (typeof arg != "string")
                ? "WARNING\n" + (typeof arg) + "\n" + v
                : arg;
        }

        return value;
    }

    // Chunk up value for printing, as print() crops long strings
    function print_value(value, chunk = 2047) {
        local start = 0;
        local end = 0;
        local chunk = 2048 - 1;
        local length = value.len();

        while (end < length) {
            end += chunk;
            if (end > length) end = length;
            print(value.slice(start, end));
            start = end;
        }
    }

    // Returns time, diff, frame information
    function time_info() {
        local next_time = fe.layout.time;
        local t_diff = next_time - _last_time;
        _last_time = next_time;

        local t = (next_time / 3600000)
            + ":" + ("00" + (next_time / 60000 % 60)).slice(-2)
            + ":" + ("00" + (next_time / 1000 % 60)).slice(-2)
            + "." + ("000" + (next_time % 1000)).slice(-3);
        local d = (t_diff > 9999) ? "####" : ("0000" + t_diff).slice(-4);
        local f = (_frame > 9999) ? "####" : ("0000" + _frame).slice(-4);
        return t + " +" + d + " [" + f + "]";
    }
}
