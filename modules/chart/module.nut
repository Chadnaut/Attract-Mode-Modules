// Chart
//
// > Plot events over time
// > Version 1.2.0
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

local module_dir = ::fe.module_dir;

class Chart {
    _once = null;
    _once_defaults = {
        width = ::fe.layout.width,
        thickness = 1,
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
        height = 60,
        alpha = 235,
        font = ::fe.layout.font,
        char_size = 20,
        outline = 0,
        align = null,
        margin = 10,
        scroll = false,
        pace = true,
        grid = 1000,
        theme = {
            background = [0, 0, 0],
            background_lag = [50, 0, 0],
            grid = [40, 40, 40],
            head = [255, 255, 255],
            head_lag = [255, 0, 0],
            text = [255, 255, 255, 255],
            chart = [
                [170, 255, 0],
                [255, 170, 0],
                [255, 0, 170],
                [170, 0, 255],
                [0, 170, 255],
            ],
        },
        zorder = 2147483647,
        visible = true,
    };

    _frame = 0;
    _last_time = 0;
    _timelines = null;
    _container = null;
    _bg = null;
    _head = null;

    _last_grid_tick = null;
    _last_tick_frames = null;
    _last_tick_lag = null;
    _frame_budget = ::ceil(1000.0 / ScreenRefreshRate);

    // =============================================

    constructor() {
        _once = clone _once_defaults;
        _prop = clone _prop_defaults;
        _timelines = {};
        ::fe.add_ticks_callback(this, "on_tick");
    }

    // =============================================

    // return _prop, _once or throw
    function _get(idx) {
        if (idx in _prop) {
            return _prop[idx];
        } else if (idx in _once) {
            return _once[idx];
        } else {
            throw null;
        }
    }

    // set prop
    function _set(idx, val) {
        // cast some props to integer to fix sub-pixel mismatches
        if (idx in _prop_int) val = val.tointeger();

        if (idx in _prop) {
            // set regular props
            _prop[idx] = val;
        } else if (idx in _once) {
            // set one-off props only if container not yet constructed
            if (!_container) _once[idx] = val;
        } else {
            throw null;
        }

        // refresh objects that use the set value
        switch (idx) {
            case "x":           refresh_container(); refresh_texts(); break;
            case "y":           refresh_container(); refresh_texts(); break;
            case "height":      refresh_container(); refresh_texts(); refresh_bars(); clear(); break;
            case "alpha":       refresh_container(); break;
            case "font":        refresh_texts(); break;
            case "char_size":   refresh_texts(); break;
            case "outline":     refresh_texts(); break;
            case "align":       refresh_texts(); break;
            case "margin":      refresh_texts(); break;
            case "theme":       refresh_texts(); refresh_bars(); break;
            case "scroll":      refresh_container(); refresh_texts(); break;
            case "zorder":      refresh_container(); refresh_texts(); break;
            case "visible":     refresh_container(); refresh_texts(); clear(); break;
        }
    }

    // =============================================

    // container gets created late so props can be adjusted beforehand
    function init_container() {
        if (_container) return;
        _container = ::fe.add_surface(width + thickness, ::fe.layout.height);
        _container.width = width;
        _container.subimg_width = width;
        _container.repeat = true;

        _bg = _container.add_image(module_dir + "pixel.png", 0, 0, 0, 0);
        _bg.width = thickness;

        _head = _container.add_clone(_bg);
        _head.width = thickness;

        refresh_container();
        clear();
        _frame = -1;
    }

    // update container props
    function refresh_container() {
        if (!_container) return;
        local total_height = _timelines.len() * height;

        _container.set_pos(x, y);
        _container.alpha = alpha;
        _container.zorder = zorder;
        _container.visible = visible && total_height;

        _head.visible = !scroll;
        _bg.height = total_height;
        _head.height = total_height;
    }

    // refresh ALL text objects
    function refresh_texts() {
        foreach (timeline in _timelines) refresh_text(timeline.text, timeline.index);
    }

    // refresh single text props
    function refresh_text(text, index) {
        text.set_pos(x, y + index * height, width, height);
        if (font && font != "") text.font = font;
        text.char_size = char_size;
        text.margin = margin;
        text.zorder = zorder;
        text.align = align ? align : scroll ? Align.TopRight : Align.TopLeft;

        local text_col = theme.text;
        text.set_rgb(text_col[0], text_col[1], text_col[2]);
        text.alpha = (text_col.len() == 4) ? text_col[3] : 255;

        local bg_col = theme.background;
        if ("set_outline_rgb" in text) {
            text.set_outline_rgb(bg_col[0], bg_col[1], bg_col[2]);
            text.outline = outline;
        }

        text.visible = visible && char_size && height >= (char_size + margin * 2);
    }

    // update ALL bars
    function refresh_bars() {
        foreach (timeline in _timelines) refresh_bar(timeline.bar, timeline.index);
    }

    // refresh single bar props
    function refresh_bar(bar, index) {
        local col = theme.chart[index % theme.chart.len()];
        bar.set_rgb(col[0], col[1], col[2]);
        bar.height = height;
        bar.y = index * height + height;
    }

    // if a tick takes more than a frame, change the thickness to fill the gap
    function set_tick_frames(frame_count) {
        local frame_thickness = frame_count * thickness;
        _bg.width = frame_thickness;
        _head.width = frame_thickness;
        foreach (timeline in _timelines) {
            timeline.bar.width = frame_thickness;
            timeline.bar.origin_x = frame_thickness;
        }
    }

    // =============================================

    // reset all timelines and clear the container image
    function clear() {
        _frame = 0;
        _last_time = ::fe.layout.time;
        if (_container) {
            _container.clear = true;
            _bg.x = 0;
            _head.x = 0;
            foreach (timeline in _timelines) timeline.bar.x = 0;
        }
    }

    // add a new timeline, or update an existing timeline
    function add(title, max = 100, step = 1, callback = null) {
        init_container();
        if (!(title in _timelines)) {
            local index = _timelines.len();

            local bar = _container.add_clone(_bg);
            bar.width = thickness;
            bar.origin_x = thickness;
            bar.rotation = 180;
            bar.visible = false;
            refresh_bar(bar, index);

            local text = ::fe.add_text(title, 0, 0, 0, 0);
            text.msg = title;
            refresh_text(text, index);

            _timelines[title] <- {
                index = index,
                text = text,
                bar = bar,
                max = max.tofloat(),
                callback = callback,
                value = 0,
            };

            refresh_container();
        }

        _timelines[title].value += step;
        return this;
    }

    // redraw all timelines, shift the container image if scrolling
    function on_tick(ttime) {
        if (!_container || !visible) return;
        _container.clear = false;

        local frame_time = ttime - _last_time;
        local grid_tick = !!grid && ((_last_time / grid).tointeger() != (ttime / grid).tointeger());
        _last_time = ttime;

        // check frame time, if more than expected AM is lagging
        local frame_count = 1;
        local tick_frames = (::ceil(frame_time / _frame_budget)).tointeger();

        // AM frequently has a single frame that goes over budget - ignore it!
        local tick_lag = (tick_frames != 1) && (_last_tick_frames != 1);
        local change_lag = (_last_tick_lag != tick_lag);
        _last_tick_frames = tick_frames;
        _last_tick_lag = tick_lag;

        if (pace && (change_lag || tick_lag)) {
            frame_count = tick_frames;
            set_tick_frames(tick_frames);
        }

        local pos = (_frame * thickness) % (width + (scroll ? thickness : 0));
        _bg.x = pos;
        if (change_lag || _last_grid_tick != grid_tick) {
            _last_grid_tick = grid_tick;
            local col = grid_tick ? theme.grid : (tick_lag ? theme.background_lag : theme.background);
            _bg.set_rgb(col[0], col[1], col[2]);
        }

        local value, bar;
        foreach (timeline in _timelines) {
            value = timeline.callback ? timeline.callback(timeline.value, frame_time) : timeline.value;
            value = ceil(value / timeline.max * height);
            value = (value > height) ? height : (value < 0) ? 0 : value;
            timeline.value = 0;
            bar = timeline.bar;
            bar.x = pos;
            bar.height = value;
            bar.visible = !!value;
        }

        _frame += frame_count;
        if (scroll) {
            _container.subimg_x = _frame * thickness;
        } else {
            _head.x = (_frame * thickness) % width;
            local col = tick_lag ? theme.head_lag : theme.head;
            _head.set_rgb(col[0], col[1], col[2]);
        }
    }
}
