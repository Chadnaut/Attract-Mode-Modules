fe.load_module("stringify");

class Console {
    x = 0;
    y = 0;
    width = fe.layout.width;
    height = fe.layout.height;
    char_size = 20;
    toggle = null;
    zorder = 2147483647;
    margin = 10;
    log_file = true;

    text_colour = [[255,255,255], [0,255,0], [255,0,0]];
    bg_colour = [[0,0,0,200], [0,40,0,200], [40,0,0,200]];

    _space = "    ";
    _level = 3;
    _limit = null;
    _before = null;
    _after = null;
    _filter = null;

    _nv_visible = "";
    _count = 0;
    _frame = 0;
    _last_time = 0;
    _text = null;
    _textlines = null;
    _maxlines = 0;

    // patterns for special values
    OBJ = @"{.*}|<.*>";
    BULLET = @"[\s\t\r\n\-]+";
    KEYWORD = @"INFO|NOTICE|ALERT|DEBUG|ERROR|WARN(ING)?";
    DATETIME = @"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}";
    TIMEINFO = @"\d+:\d{2}:\d{2}\.\d{3}(\s\+[\d#]+)?(\s\[[\d#]+\])?";

    static global = { id = 0 };

    constructor(config = null) {
        if (config) foreach (k, v in config) if (k in this) this[k] = v;
        _nv_visible = "console_" + global.id++;
        if (!(_nv_visible in fe.nv)) fe.nv[_nv_visible] <- false;
        if (!toggle) fe.nv[_nv_visible] = true;
        if (config) create_messages();

        fe.add_ticks_callback(this, "on_tick");
        fe.add_signal_handler(this, "on_signal");
    }

    function on_tick(ttime) {
        _frame++;
    }

    function on_signal(signal) {
        if (signal == toggle) {
            fe.nv[_nv_visible] = !fe.nv[_nv_visible];
            refresh_messages();
        }
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
            case "filter":  _filter = val; print_log(@"console.filter = """ + val + @"""" + "\n"); break;
            default:        throw null;
        }
    }

    // =============================================

    function error(...) {
        if (_level < 1) return;
        vargv.insert(0, "WARNING");
        vargv.insert(0, this);
        local value = format_value.acall(vargv);
        if (!value) return;
        print_log(value);
        print_message(value.slice(9), 2);
    }

    function info(...) {
        if (_level < 2) return;
        vargv.insert(0, "INFO");
        vargv.insert(0, this);
        local value = format_value.acall(vargv);
        if (!value) return;
        print_log(value);
        print_message(value.slice(6), 1);
    }

    function log(...) {
        if (_level < 3) return;
        vargv.insert(0, this);
        local value = format_value.acall(vargv);
        if (!value) return;
        print_log(value);
        print_message(value, 0);
    }

    function time(...) {
        if (_level < 3) return;
        vargv.insert(0, time_info());
        vargv.insert(0, this);
        local value = format_value.acall(vargv);
        if (!value) return;
        print_log(value);
        print_message(value, 0);
    }

    // =============================================

    // Filter, compose and print
    function format_value(...) {
        if (_limit && _count >= _limit) return null;
        if (_before && fe.layout.time > _before) return null;
        if (_after && fe.layout.time < _after) return null;
        local value = compose(vargv) + "\n";
        if (_filter && !regexp(_filter).capture(value)) return null;

        _count++
        return value;
    }

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
    function print_log(value, chunk = 2047) {
        if (!log_file) return;
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

    // =============================================

    // Create a text object for message display
    function create_text() {
        local obj = fe.add_text("", x, y, width, height);
        obj.char_size = char_size;
        obj.word_wrap = true;
        obj.align = Align.TopLeft;
        obj.margin = margin;
        obj.zorder = zorder;
        return obj;
    }

    // Create a series of text objects for message colours
    function create_messages() {
        _text = [];
        _textlines = [];
        foreach (col in text_colour) {
            local text = create_text();
            text.set_rgb(col[0], col[1], col[2]);
            _text.push(text);
            _textlines.push([]);
        }
        _maxlines = _text[0].lines;
        clear_messages();
    }

    // Add lines to the corresponding message array
    function print_message(value, index) {
        if (!_text) return;
        local parts = (value == "\n") ? [""] : split(value, "\n");
        foreach (line in parts) {
            foreach (i, lines in _textlines) {
                lines.push((i == index) ? line : "");
            }
        }
        foreach (i, lines in _textlines) {
            if (lines.len() > _maxlines) _textlines[i] = lines.slice(-_maxlines);
        }
        refresh_messages();
    }

    // Clear all messages
    function clear_messages() {
        foreach (line in _textlines) line.clear();
        refresh_messages();
        background(0);
    }

    // Draw the message arrays in the display objects
    function refresh_messages() {
        foreach (i, text in _text) {
            text.visible = fe.nv[_nv_visible];
            if (!text.visible) continue;
            local msg = "";
            foreach (line in _textlines[i]) msg += line + "\n";
            text.msg = msg;
        }
    }

    // Set the background colour
    function background(index) {
        local col = bg_colour[index];
        _text[0].set_bg_rgb(col[0], col[1], col[2]);
        _text[0].bg_alpha = col[3];
    }
}
