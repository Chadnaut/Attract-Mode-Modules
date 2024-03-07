class Chart {

    x = 0;
    y = 50;
    width = fe.layout.width;
    size = 60;
    alpha = 235;
    char_size = 15;
    margin = 10;
    thickness = 1;
    scroll = false;
    grid = 1000;
    theme = null;
    toggle = null;
    zorder = 2147483647;

    _nv_visible = "";
    _frame = 0;
    _last_time = 0;
    _timelines = null;
    _container = null;
    _bg = null;
    _head = null;

    static global = { id = 0 };

    // the first three colours are bg, grid, text, the remaining are for timelines
    static themes = {
        neon =   [[0, 0, 0], [40, 40, 40], [255, 255, 255], [170, 255,   0], [255, 170,   0], [255,   0, 170], [170,   0, 255], [  0, 170, 255]],
        autumn = [[0, 0, 0], [40, 40, 40], [255, 255, 255], [250, 222, 125], [253, 186, 149], [255, 107, 107], [129, 166, 132], [ 85, 161, 153]],
        metro =  [[0, 0, 0], [40, 40, 40], [255, 255, 255], [142, 193,  39], [244, 120,  53], [212,  18,  67], [162,   0, 255], [  0, 174, 219]],
    };

    constructor(config = null) {
        if (config) foreach (k, v in config) if (k in this) this[k] = v;
        if (!theme) theme = themes.neon;

        _nv_visible = "chart_" + global.id++;
        if (!(_nv_visible in fe.nv)) fe.nv[_nv_visible] <- true;
        if (!toggle) fe.nv[_nv_visible] = true;

        _container = fe.add_surface(width + thickness, fe.layout.height - y);
        _container.x = x;
        _container.y = y;
        _container.width = width;
        _container.subimg_width = width;
        _container.repeat = true;
        _container.zorder = zorder;
        _container.alpha = alpha;

        _bg = _container.add_image(fe.module_dir + "pixel.png", 0, 0, 0, 0);
        _bg.width = thickness;

        _head = _container.add_clone(_bg);
        _head.width = thickness;
        _head.visible = !scroll;

        _timelines = {};

        reset();
        fe.add_ticks_callback(this, "on_tick");
        if (toggle) fe.add_signal_handler(this, "on_signal");
    }

    function on_signal(signal) {
        if (signal == toggle) {
            fe.nv[_nv_visible] = !fe.nv[_nv_visible];
            reset();
        }
    }

    function reset() {
        _frame = 0;
        _last_time = fe.layout.time;
        _container.clear = !fe.nv[_nv_visible];
        _container.visible = fe.nv[_nv_visible] && _timelines.len();
        _bg.x = 0;
        _head.x = 0;
        foreach (timeline in _timelines) {
            timeline.text.visible = fe.nv[_nv_visible];
            timeline.bar.x = 0;
        }
        return this
    }

    function add(title, max = 100, step = 1, callback = null) {
        if (!(title in _timelines)) {
            local index = _timelines.len();
            local colour = theme[3 + (index % (theme.len() - 3))];
            local text_colour = theme[2];
            local top = index * size;

            local bar = _container.add_clone(_bg);
            bar.width = thickness;
            bar.height = size;
            bar.set_rgb(colour[0], colour[1], colour[2]);
            bar.rotation = 180;
            bar.y = top + size;
            bar.origin_x = thickness;
            bar.visible = false;

            local text = fe.add_text(title, x, y + top, width, size);
            text.align = scroll ? Align.TopRight : Align.TopLeft;
            text.char_size = char_size;
            text.margin = margin;
            text.msg = (char_size && size >= (char_size + margin * 2)) ? title : "";
            text.alpha = 235;
            text.set_rgb(text_colour[0], text_colour[1], text_colour[2]);
            text.zorder = zorder;
            text.visible = fe.nv[_nv_visible];

            _timelines[title] <- {
                text = text,
                bar = bar,
                max = max.tofloat(),
                callback = callback,
                value = 0,
            };

            local total_height = (index + 1) * size;
            _bg.height = total_height;
            _head.height = total_height;
            _container.visible = fe.nv[_nv_visible];
        }

        _timelines[title].value += step;
        return this;
    }

    function on_tick(ttime) {
        if (!fe.nv[_nv_visible]) return;

        local next_time = fe.layout.time;
        local frame_time = next_time - _last_time;
        local grid_tick = !!grid && ((_last_time / grid).tointeger() != (next_time / grid).tointeger());
        _last_time = next_time;

        local pos = (_frame * thickness) % (width + (scroll ? thickness : 0));
        local col = theme[grid_tick ? 1 : 0];
        _bg.set_rgb(col[0], col[1], col[2]);
        _bg.x = pos;

        local value;
        foreach (timeline in _timelines) {
            value = timeline.callback ? timeline.callback(timeline.value, frame_time) : timeline.value;
            value = ceil(value / timeline.max * size);
            value = (value > size) ? size : (value < 0) ? 0 : value;
            timeline.value = 0;
            timeline.bar.x = pos;
            timeline.bar.height = value;
            timeline.bar.visible = !!value;
        }

        _frame++;
        if (scroll) {
            _container.subimg_x = _frame * thickness;
        } else {
            _head.x = (_frame * thickness) % width;
        }
    }
}
