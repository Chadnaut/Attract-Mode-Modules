// LogPlus
//
// > Extended logging functionality
// > Version 0.6.4
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

if ("logplus" in this) return;

::fe.load_module("stringify");

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
    _regex_filter = null;

    // regex for special values that dont get stringified
    _char_special = "✔️⚠️❌";
    _regex_special = regexp(format(
        @"^(%s|%s|%s|%s|%s)$",
        @"{.*}|<.*>",
        @"[\s\t\r\n\-]+",
        @"INFO|NOTICE|ALERT|DEBUG|ERROR|WARN(ING)?",
        @"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}",
        @"(\d+:\d{2}:\d{2}\.\d{3})?(\s?[\+\-][\d\.]+)?(\s?\[\d+\])?"
    ));

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
        if (refresh_filter() && !_regex_filter.capture(value)) return null;
        _count++
        return value;
    }

    // Make regex filter
    function refresh_filter() {
        if (filter && !_regex_filter) {
            _regex_filter = regexp(filter);
        } else if (!filter && _regex_filter) {
            _regex_filter = null;
        }
        return _regex_filter;
    }

    // Format args so they're ready for printing
    function stringify_args(args) {
        local value = "";
        foreach (i, v in args) {
            if (i) value += delimiter;
            value += (
                    show_specials
                    && typeof v == "string"
                    && ((_char_special.find(v) != null) || !!_regex_special.capture(v))
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

    function get_time() {
        return format(
            "%d:%02d:%02d.%03d",
            _next_time / 3600000,
            _next_time / 60000 % 60,
            _next_time / 1000 % 60,
            _next_time % 1000
        );
    }

    function get_diff() {
        local diff = _next_time - _last_time;
        _last_time = _next_time;
        return format("%03d", diff);
    }

    function get_frame() {
        return format("%03d", _frame);
    }
}

::logplus <- LogPlus();
