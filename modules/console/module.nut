fe.load_module("stringify");

class Console {

    _space = "    ";
    _level = 3;
    _limit = null;
    _before = null;
    _after = null;
    _filter = null;

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

    // =============================================

    function _get(idx) {
        switch (idx) {
            case "space":   return _space;
            case "level":   return _level;
            case "limit":   return _limit;
            case "before":  return _before;
            case "after":   return _after;
            case "filter":  return _filter;
            default:        throw null;
        }
    }

    function _set(idx, val) {
        switch (idx) {
            case "space":   _space = val; break;
            case "level":   _level = val; break;
            case "limit":   _limit = val; break;
            case "before":  _before = val; break;
            case "after":   _after = val; break;
            case "filter":  _filter = val; print_chunks(@"console.filter = """ + val + @"""" + "\n"); break;
            default:        throw null;
        }
    }

    // =============================================

    function error(...) {
        if (_level < 1) return;
        vargv.insert(0, "WARNING");
        vargv.insert(0, this);
        write.acall(vargv);
    }

    function info(...) {
        if (_level < 2) return;
        vargv.insert(0, this);
        write.acall(vargv);
    }

    function log(...) {
        if (_level < 3) return;
        vargv.insert(0, this);
        write.acall(vargv);
    }

    function time(...) {
        if (_level < 3) return;
        vargv.insert(0, time_info());
        vargv.insert(0, this);
        write.acall(vargv);
    }

    // =============================================

    // Format args so they're ready for printing
    function compose(args, delimiter = ", ") {
        local value = "";
        local head = 1;
        local arg;

        foreach (i, v in args) {
            arg = stringify(v, _space);

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
    function print_chunks(value, chunk = 2047) {
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

    // Filter, compose and print
    function write(...) {
        if (_limit && _count >= _limit) return;
        if (_before && fe.layout.time > _before) return;
        if (_after && fe.layout.time < _after) return;
        local value = compose(vargv);
        if (_filter && !regexp(_filter).capture(value)) return;

        _count++
        print_chunks(value + "\n");
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

    function on_tick(ttime) {
        _frame++;
    }
}
