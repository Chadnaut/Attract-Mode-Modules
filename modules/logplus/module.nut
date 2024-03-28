if ("logplus" in this) return;

fe.load_module("stringify");

class LogPlus {

    show_time = false;
    show_diff = false;
    show_frame = false;
    show_specials = true;
    indent = "    ";
    delimiter = ", ";

    limit = null;
    before = null;
    after = null;
    filter = null;

    _has_fe_log = false;
    _count = 0;
    _frame = 0;
    _next_time = 0;
    _last_time = 0;

    // patterns for special values that dont get stringified
    OBJ = @"{.*}|<.*>";
    BULLET = @"[\s\t\r\n\-]+";
    KEYWORD = @"INFO|NOTICE|ALERT|DEBUG|ERROR|WARN(ING)?";
    DATETIME = @"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}";
    TIMEINFO = @"(\d+:\d{2}:\d{2}\.\d{3})?(\s?\+[\d#]+)?(\s?\[[\d#]+\])?";

    constructor() {
        _has_fe_log = ("log" in ::fe);
        ::fe.add_ticks_callback(this, "on_tick");
    }

    // Its a callable instance!
    function _call(...) {
        print_value(vargv.slice(1));
    }

    // =============================================

    // Format and output the value
    function print_value(args) {
        _next_time = ::fe.layout.time;
        local prefix = get_prefix();
        if (prefix) args.insert(0, prefix);
        local value = format_args(args);
        if (value != null) output_value(value);
    }

    // Add time, diff or frame
    function get_prefix() {
        local prefix = "";
        if (show_time) prefix += get_time();
        if (show_diff) prefix += format(" +%s", get_diff());
        if (show_frame) prefix += format(" [%s]", get_frame());
        prefix = strip(prefix);
        return (prefix != "") ? prefix : null;
    }

    // Check limits, return stringified value only on success
    function format_args(args) {
        if (limit && _count >= limit) return null;
        if (before && _next_time > before) return null;
        if (after && _next_time < after) return null;
        local value = stringify_args(args);
        if (filter && !regexp(filter).capture(value)) return null;
        _count++
        return value;
    }

    // Format args so they're ready for printing
    function stringify_args(args) {
        local value = "";
        foreach (i, v in args) {
            if (i) value += delimiter;
            value += (
                    show_specials
                    && typeof v == "string"
                    && !!regexp(@"("+OBJ+"|"+BULLET+"|"+KEYWORD+"|"+DATETIME+"|"+TIMEINFO+@")$").capture(v)
                ) ? v : ::stringify(v, indent);
        }
        return value;
    }

    // Output the value to last_run.log
    function output_value(value) {
        // use the new log method if available
        if (_has_fe_log) {
            ::fe.log(value);
            return;
        }

        local start = 0;
        local end = 0;
        local chunk = 2048 - 1;
        local length = value.len();

        // print the hard way
        while (end < length) {
            end += chunk;
            if (end > length) end = length;
            print(value.slice(start, end));
            start = end;
        }
        print("\n");
    }

    // =============================================

    function on_tick(ttime) {
        _frame++;
    }

    function crop_number(value) {
        return (value > 99999)
            ? "#####"
            : ("00000" + value).slice(-5);
    }

    function get_time() {
        return format(
            "%d:%s:%s.%s",
            _next_time / 3600000,
            ("00" + (_next_time / 60000 % 60)).slice(-2),
            ("00" + (_next_time / 1000 % 60)).slice(-2),
            ("000" + (_next_time % 1000)).slice(-3)
        );
    }

    function get_diff() {
        local diff = _next_time - _last_time;
        _last_time = _next_time;
        return crop_number(diff);
    }

    function get_frame() {
        return crop_number(_frame);
    }
}

::logplus <- LogPlus();
