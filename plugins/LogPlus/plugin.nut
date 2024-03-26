class UserConfig</ help="Extended functionality for fe.log (v0.5)" /> {}

// Only show config if fe.log exists
if ("log" in ::fe) {
    UserConfig["show_time"] <- "No";
    UserConfig.setattributes("show_time", {
        label = "Show Time",
        options = "Yes,No",
        help = "Add layout time to each log",
        order = 1,
    });
    UserConfig["show_diff"] <- "No";
    UserConfig.setattributes("show_diff", {
        label = "Show Diff",
        options = "Yes,No",
        help = "Add duration since last log to each log",
        order = 2,
    });
    UserConfig["show_frame"] <- "No";
    UserConfig.setattributes("show_frame", {
        label = "Show Frame",
        options = "Yes,No",
        help = "Add frame number to each log",
        order = 3,
    });
    UserConfig["indent"] <- "4";
    UserConfig.setattributes("indent", {
        label = "Indent",
        options = "0,2,4",
        help = "Indent size for pretty-printed objects",
        order = 4,
    });
    UserConfig["delimiter"] <- "Comma";
    UserConfig.setattributes("delimiter", {
        label = "Delimiter",
        options = "Comma,Space",
        help = "Character printed between values",
        order = 5,
    });
    UserConfig["specials"] <- "Yes";
    UserConfig.setattributes("specials", {
        label = "Specials",
        options = "Yes,No",
        help = "Allow special strings to be printed without quotes",
        order = 6,
    });
} else {
    UserConfig["warning"] <- "Warning";
    UserConfig.setattributes("warning", {
        label = "Warning",
        help = "This plugin requires Attract-Mode Plus v3.0.9 or higher",
        options = "Warning",
        order = 1,
    });
}

::fe.do_nut(::fe.script_dir + "stringify.nut");

class LogPlus {

    limit = null;
    before = null;
    after = null;
    filter = null;

    _fe_log = null;
    _count = 0;
    _frame = 0;
    _next_time = 0;
    _last_time = 0;

    _show_time = false;
    _show_diff = false;
    _show_frame = false;
    _indent = "    ";
    _delimiter = ", ";
    _specials = true;

    // patterns for special values that dont get stringified
    OBJ = @"{.*}|<.*>";
    BULLET = @"[\s\t\r\n\-]+";
    KEYWORD = @"INFO|NOTICE|ALERT|DEBUG|ERROR|WARN(ING)?";
    DATETIME = @"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}";
    TIMEINFO = @"(\d+:\d{2}:\d{2}\.\d{3})?(\s?\+[\d#]+)?(\s?\[[\d#]+\])?";

    // override fe.log with our own version
    constructor() {
        local config = ::fe.get_config();
        _show_time = config["show_time"] == "Yes";
        _show_diff = config["show_diff"] == "Yes";
        _show_frame = config["show_frame"] == "Yes";
        _indent = { ["0"] = "", ["2"] = "  ", ["4"] = "    " }[config["indent"]];
        _delimiter = { Comma = ", ", Space = " " }[config["delimiter"]];
        _specials = config["specials"] == "Yes";

        local self = this;
        _fe_log = ::fe.log;
        ::fe.log <- @(...) self.print_value(vargv);

        ::fe.add_ticks_callback(this, "on_tick");
    }

    // =============================================

    // Format and log the value to last_run.log
    function print_value(args) {
        _next_time = ::fe.layout.time;
        local prefix = get_prefix();
        if (prefix) args.insert(0, prefix);
        local value = format_args(args);
        if (value != null) _fe_log(value);
    }

    // Add time, diff or frame
    function get_prefix() {
        local prefix = "";
        if (_show_time) prefix += get_time();
        if (_show_diff) prefix += format(" +%s", get_diff());
        if (_show_frame) prefix += format(" [%s]", get_frame());
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
            if (i) value += _delimiter;
            value += (
                    _specials
                    && typeof v == "string"
                    && !!regexp(@"("+OBJ+"|"+BULLET+"|"+KEYWORD+"|"+DATETIME+"|"+TIMEINFO+@")$").capture(v)
                ) ? v : stringify(v, _indent);
        }
        return value;
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

// only add plugin if fe.log exists
if ("log" in ::fe) ::fe.plugin["LogPlus"] <- LogPlus();
