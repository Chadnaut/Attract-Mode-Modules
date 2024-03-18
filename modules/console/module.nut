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
        text_red = 255,
        text_green = 255,
        text_blue = 255,
        text_alpha = 255,
        bg_red = 0,
        bg_green = 0,
        bg_blue = 0,
        bg_alpha = 0,
        alpha = 255,
        zorder = 2147483647,
        visible = true,
    };

    _container = null;
    _texts = null;
    _data = null;
    _item_default = null;
    _lines = 0;

    // =============================================

    constructor() {
        _once = clone _once_defaults;
        _prop = clone _prop_defaults;
        _texts = [];
        _data = [];
        _item_default = {
            message = "",
            text_rgb = [text_red, text_green, text_blue, text_alpha],
            bg_rgb = [bg_red, bg_green, bg_blue, bg_alpha],
        };
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
            case "text_alpha":
                _item_default.text_rgb = [text_red, text_green, text_blue, text_alpha];
                break;

            case "bg_red":
            case "bg_green":
            case "bg_blue":
            case "bg_alpha":
                _item_default.bg_rgb = [bg_red, bg_green, bg_blue, bg_alpha];
                break;
        }
    }

    function in_range(index) {      return index < _data.len(); }
    function get_message(index) {   return in_range(index) ? _data[index].message : null; }
    function get_text_rgb(index) {  return in_range(index) ? _data[index].text_rgb : null; }
    function get_bg_rgb(index) {    return in_range(index) ? _data[index].bg_rgb : null; }

    function set_message(index, message) {          if (in_range(index)) { _data[index].message = message; redraw(); } }
    function set_text_rgb(index, r, g, b, a = 255) {if (in_range(index)) { _data[index].text_rgb = [r,g,b,a]; redraw(); } }
    function set_bg_rgb(index, r, g, b, a = 255) {  if (in_range(index)) { _data[index].bg_rgb = [r,g,b,a]; redraw(); } }

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
        foreach (message in messages) _data.push({
            message = message,
            text_rgb = text_rgb,
            bg_rgb = bg_rgb,
        });

        // get the tail of the line array and redraw
        if (_data.len() > _lines) _data = _data.slice(-_lines);
        redraw();
    }

    // Clear lines and redraw
    function clear(theme_index = 0) {
        _data.clear();
        redraw();
    }

    // =============================================

    // Redraw all lines
    function redraw() {
        local len = _data.len();
        foreach (i, text in _texts) {
            local item = (i < len) ? _data[i] : _item_default;
            text.msg = item.message;
            local text_rgb = item.text_rgb;
            text.set_rgb(text_rgb[0], text_rgb[1], text_rgb[2]);
            text.alpha = (text_rgb.len() == 4) ? text_rgb[3] : 255;
            local bg_rgb = item.bg_rgb;
            text.set_bg_rgb(bg_rgb[0], bg_rgb[1], bg_rgb[2])
            text.bg_alpha = (bg_rgb.len() == 4) ? bg_rgb[3] : 255;
        }
    }
}
