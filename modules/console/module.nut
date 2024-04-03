fe.load_module("stringify");

class Console {
    _once = null;
    _once_defaults = {
        width = fe.layout.width,
        height = fe.layout.height,
        font = fe.layout.font,
        char_size = 24,
        line_space = 0,
    };

    _prop = null;
    _prop_int = {
        x = true,
        y = true,
        width = true,
        height = true,
    };
    _prop_defaults = {
        x = 0,
        y = 0,
        char_delay = 0,
        line_delay = 0,
        line_wait = true,
        text_red = 255,
        text_green = 255,
        text_blue = 255,
        bg_red = 0,
        bg_green = 0,
        bg_blue = 0,
        alpha = 255,
        zorder = 2147483647,
        visible = true,
    };

    _container = null;
    _texts = null;
    _buffer = null;
    _data = null;
    _item_default = null;
    _lines = 0;

    _prev_ttime = 0;
    _line_delay_time = 0;
    _char_delay_time = 0;

    // =============================================

    constructor() {
        _once = clone _once_defaults;
        _prop = clone _prop_defaults;
        _texts = [];
        _buffer = [];
        _data = [];
        _item_default = {
            message = "",
            buffer = 0,
            text_rgb = [text_red, text_green, text_blue],
            bg_rgb = [bg_red, bg_green, bg_blue],
        };
        fe.add_ticks_callback(this, "on_tick");
    }

    // =============================================

    function _get(idx) {
        if (idx in _prop) {
            return _prop[idx];
        } else if (idx in _once) {
            return _once[idx];
        } else {
            switch (idx) {
                case "lines": return _lines;
                case "lines_total": return _data.len();
                case "ready":
                    if (_buffer.len()) return false;
                    foreach (item in _data) if (item.buffer < item.message.len()) return false;
                    return true;
            }
            throw null;
        }
    }

    function _set(idx, val) {
        if (idx in _prop_int) val = val.tointeger();
        if (idx in _prop) {
            _prop[idx] = val;
        } else if (idx in _once) {
            if (!_container) _once[idx] = val;
        } else {
            throw null;
        }

        switch (idx) {
            case "char_delay":
                refresh_buffer();
                if (!line_delay && !char_delay) flush();
                break;

            case "line_delay":
                if (!line_delay && !char_delay) flush();
                break;

            case "x":
            case "y":
            case "alpha":
            case "zorder":
            case "visible":
                refresh_container();
                break;

            case "text_red":
            case "text_green":
            case "text_blue":
                _item_default.text_rgb = [text_red, text_green, text_blue];
                break;

            case "bg_red":
            case "bg_green":
            case "bg_blue":
                _item_default.bg_rgb = [bg_red, bg_green, bg_blue];
                break;
        }
    }

    function in_range(index) {
        return index < _data.len();
    }

    function get_message(index = -1) {
        return in_range(index)
            ? _data[index].message
            : null;
        }

    function get_text_rgb(index = -1) {
        return in_range(index)
            ? _data[index].text_rgb
            : _item_default.text_rgb;
        }

    function get_bg_rgb(index = -1) {
        return in_range(index)
            ? _data[index].bg_rgb
            : _item_default.bg_rgb;
        }

    function set_message(index, message) {
        if (in_range(index)) {
            if (typeof message != "string") message = stringify(message);
            _data[index].message = message,
            _data[index].buffer = char_delay ? 0 : message.len(),
            redraw();
        }
    }
    function set_text_rgb(...) {
        switch (vargv.len()) {
            case 3:
                _item_default.text_rgb = vargv;
            case 4:
                local index = vargv[0];
                if (in_range(index)) {
                    _data[index].text_rgb = vargv.slice(1);
                    redraw();
                }
        }
    }
    function set_bg_rgb(...) {
        switch (vargv.len()) {
            case 3:
                _item_default.bg_rgb = vargv;
            case 4:
                local index = vargv[0];
                if (in_range(index)) {
                    _data[index].bg_rgb = vargv.slice(1);
                    redraw();
                }
        }
    }

    // =============================================

    function init_container() {
        if (_container) return;
        _container = fe.add_surface(width, height);

        // measure line height
        local first = _container.add_text("", 0, 0, width, height);
        if (font && font != "") first.font = font;
        first.char_size = char_size;
        first.margin = 0;
        first.word_wrap = true;
        first.msg = "M";
        local h1 = first.msg_height;
        first.msg = first.msg + "\n" + first.msg;
        local h2 = first.msg_height;
        first.msg = "";

        // calc total lines
        local line_height = h2 - h1 + line_space;
        local line_head = h2 - h1 - char_size;
        _lines = floor(height / line_height);
        first.height = line_height;
        local remainder = _lines * line_height < height;

        // create text objects
        for (local i=0, n = _lines + (remainder ? 1 : 0); i<n; i++) {
            local line = (i == 0) ? first : _container.add_text("", 0, i * line_height, width, line_height);
            if (font && font != "") line.font = font;
            line.char_size = char_size;
            line.word_wrap = false;
            line.margin = line_head;
            line.align = Align.MiddleLeft;
            _texts.push(line);
        }

        refresh_container();
    }

    function refresh_container() {
        if (!_container) return;
        _container.x = x;
        _container.y = y;
        _container.alpha = alpha;
        _container.zorder = zorder;
        _container.visible = visible;
    }

    // =============================================

    // Add message to console
    function print(message = "", text_rgb = null, bg_rgb = null) {
        init_container();

        // split message into parts around carriage return
        if (message == "") message = " ";
        if (typeof message != "string") message = stringify(message, "    ");
        local messages = split(message, "\n");

        if (!text_rgb || typeof text_rgb != "array") text_rgb = clone _item_default.text_rgb;
        if (!bg_rgb || typeof bg_rgb != "array") bg_rgb = clone _item_default.bg_rgb;

        // add each part to lines array
        foreach (message in messages) _buffer.push({
            message = message,
            buffer = char_delay ? 0 : message.len(),
            text_rgb = text_rgb,
            bg_rgb = bg_rgb,
        });

        if (!line_delay && (!line_wait || (char_delay == 0))) {
            _data.extend(_buffer);
            _buffer.clear();
            redraw();
        }
    }

    // Clear lines and redraw
    function clear(theme_index = 0) {
        _buffer.clear();
        _data.clear();
        redraw();
    }

    // Print remaining buffer immediately
    function flush() {
        local changed = false;
        _data.extend(_buffer);
        _buffer.clear();
        foreach (item in _data) {
            item.buffer = item.message.len();
        }
        redraw();
    }

    function refresh_buffer() {
        local delay = char_delay;
        foreach (item in _buffer) {
            item.buffer = delay ? 0 : item.message.len();
        }
        if (delay == 0) {
            foreach (item in _data) {
                item.buffer = item.message.len();
            }
        }
    }

    // =============================================

    function on_tick(ttime) {
        if (!line_delay && !char_delay) return;

        local changed = false;
        local diff = ttime - _prev_ttime;
        _prev_ttime = ttime;

        if (line_wait && char_delay && !line_delay) {
            _line_delay_time = -(diff + 1);
        }

        if (char_delay) {
            _char_delay_time += diff;
            if (_char_delay_time >= char_delay) {
                _char_delay_time = 0;

                foreach (item in _data) {
                    if (item.buffer < item.message.len()) {
                        item.buffer++;
                        changed = true;
                    }
                }

                if (line_wait) {
                    if (changed) {
                        _line_delay_time = -(diff + 1);
                    } else if (!line_delay) {
                        _line_delay_time = 0;
                    }
                }
            }
        }

        if (line_delay || line_wait) {
            _line_delay_time += diff;

            if (_line_delay_time >= line_delay || !_data.len()) {
                _line_delay_time = 0;

                if (_buffer.len()) {
                    _data.push(_buffer[0]);
                    _buffer = _buffer.slice(1);
                    changed = true;
                }
            }
        }

        if (changed) redraw();
    }

    // =============================================

    // Redraw all lines
    function redraw() {
        if (_data.len() > _lines) _data = _data.slice(-_lines);
        local len = _data.len();
        foreach (i, text in _texts) {
            local item = (i < len) ? _data[i] : _item_default;
            text.msg = item.message.slice(0, item.buffer);
            local text_rgb = item.text_rgb;
            text.set_rgb(text_rgb[0], text_rgb[1], text_rgb[2]);
            local bg_rgb = item.bg_rgb;
            text.set_bg_rgb(bg_rgb[0], bg_rgb[1], bg_rgb[2])
        }
    }
}
