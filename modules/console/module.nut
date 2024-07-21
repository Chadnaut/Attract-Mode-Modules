// Console
//
// > Coloured message list with animated typing
// > Version 0.9.1
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

::fe.load_module("stringify");

class Console {
    _once = null;
    _once_defaults = {
        width = ::fe.layout.width,
        height = ::fe.layout.height,
        font = ::fe.layout.font,
        char_size = 24,
        char_spacing = 1.0,
        line_margin = null,
        line_height = 0,
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
        align = Align.Left,
        alpha = 255,
        zorder = 0,
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
            align = Align.Left,
        };
        ::fe.add_ticks_callback(this, "on_tick");
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

            case "align":
                _item_default.align = val;
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

    // =============================================

    function format_text_rgb(value) {
        return (!value || (typeof value != "array") || (value.len() < 3))
            ? clone _item_default.text_rgb
            : value;
    }

    function format_bg_rgb(value) {
        return (!value || (typeof value != "array") || (value.len() < 3))
            ? clone _item_default.bg_rgb
            : value;
    }

    function format_align(value) {
        return (value != null) ? value : _item_default.align;
    }

    function format_message(value) {
        if (value == "") value = " ";
        if (typeof value != "string") value = stringify(value, "    ");
        return value;
    }

    // =============================================

    function get_item(index) {
        return (index < _data.len()) ? _data[index] : null;
    }

    function get_message(index) {
        local item = get_item(index);
        if (!item) return null;
        return item.message;
    }

    function set_message(index, message) {
        local item = get_item(index);
        if (!item) return null;
        message = format_message(message);
        item.message = message;
        item.buffer = char_delay ? 0 : message.len();
        redraw();
    }

    function get_options(index) {
        local item = get_item(index);
        if (!item) return null;
        item = clone item;
        delete item.message;
        delete item.buffer;
        return item;
    }

    function set_options(index, options) {
        local item = get_item(index);
        if (!item) return;

        foreach (key, val in options) {
            switch (key) {
                case "text_rgb":    item[key] = format_text_rgb(val); break;
                case "bg_rgb":      item[key] = format_bg_rgb(val); break;
                case "align":       item[key] = format_align(val); break;
            }
        }
        redraw();
    }

    function set_text_rgb(r, g, b) {
        text_red = r;
        text_green = g;
        text_blue = b;
    }

    function set_bg_rgb(r, g, b) {
        bg_red = r;
        bg_green = g;
        bg_blue = b;
    }

    // =============================================

    function init_container() {
        if (_container) return;
        _container = ::fe.add_surface(width, height);

        // measure line height
        local first = _container.add_text("", 0, 0, width, height);
        if (font && font != "") first.font = font;
        first.char_size = char_size;
        first.char_spacing = char_spacing;
        first.margin = 0;
        first.word_wrap = true;

        if (!line_height) {
            first.msg = "M";
            local h1 = first.msg_height;
            first.msg = first.msg + "\n" + first.msg;
            local h2 = first.msg_height;
            first.msg = "";
            _once["line_height"] = h2 - h1 + ((line_margin || 0) * 2);
        }

        // calc total lines
        local margin = (line_margin == null) ? ((line_height - char_size) / 2) : 0;
        _lines = floor(height / line_height);
        first.height = line_height;
        local remainder = _lines * line_height < height;

        // create text objects
        for (local i=0, n = _lines + (remainder ? 1 : 0); i<n; i++) {
            local line = (i == 0) ? first : _container.add_text("", 0, i * line_height, width, line_height);
            if (font && font != "") line.font = font;
            line.char_size = char_size;
            line.char_spacing = char_spacing;
            line.word_wrap = false;
            line.margin = margin;
            line.align = align;
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
    function print(message = "", options = null) {
        init_container();

        // split message into parts around carriage return
        local messages = split(format_message(message), "\n");

        //  text_rgb = null, bg_rgb = null
        if (options == null) options = {};
        local line_text_rgb = format_text_rgb(("text_rgb" in options) ? options.text_rgb : null);
        local line_bg_rgb = format_bg_rgb(("bg_rgb" in options) ? options.bg_rgb : null);
        local line_align = format_align(("align" in options) ? options.align : null);

        // add each part to lines array
        foreach (message in messages) _buffer.push({
            message = message,
            buffer = char_delay ? 0 : message.len(),
            text_rgb = line_text_rgb,
            bg_rgb = line_bg_rgb,
            align = line_align,
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

    // Redraw all lines
    function redraw() {
        if (_data.len() > _lines) _data = _data.slice(-_lines);
        local len = _data.len();
        foreach (i, text in _texts) {
            local item = (i < len) ? _data[i] : _item_default;
            text.msg = item.message.slice(0, item.buffer);
            text.align = item.align;
            local text_rgb = item.text_rgb;
            text.set_rgb(text_rgb[0], text_rgb[1], text_rgb[2]);
            local bg_rgb = item.bg_rgb;
            text.set_bg_rgb(bg_rgb[0], bg_rgb[1], bg_rgb[2])
        }
    }
}
