class Frame {
    _dir = ::fe.module_dir;
    _obj = null;
    _prop = null;
    _prop_defaults = {
        x = 0,
        y = 0,
        width = 0,
        height = 0,
        padding_left = 0,
        padding_top = 0,
        padding_right = 0,
        padding_bottom = 0,
        slice_left = 0,
        slice_top = 0,
        slice_right = 0,
        slice_bottom = 0,
    };
    _has_callback = false;

    constructor(obj) {
        _obj = obj;
        _obj.shader = ::fe.add_shader(Shader.Fragment, _dir + "nine-slice.frag");
        _prop = clone _prop_defaults;

        update_target();
        x = _obj.x;
        y = _obj.y;
        width = _obj.width;
        height = _obj.height;
    }

    function _get(idx) {
        return (idx in _prop) ? _prop[idx] : _obj[idx];
    }

    function _set(idx, val) {
        if (idx in _prop) _prop[idx] = val; else _obj[idx] = val;
        switch (idx) {
            case "file_name":
                update_target();
                break;

            case "x":
                _obj[idx] = x - padding_left + _obj.anchor_x * (padding_left + padding_right);
                break;
            case "y":
                _obj[idx] = y - padding_top + _obj.anchor_x * (padding_top + padding_bottom);
                break;
            case "width":
                _obj.shader.set_param(idx, _obj[idx] = width + padding_left + padding_right);
                break;
            case "height":
                _obj.shader.set_param(idx, _obj[idx] = height + padding_top + padding_bottom);
                break;

            case "anchor_x":
                x = x;
                break;
            case "anchor_y":
                y = y;
                break;

            case "padding_left":
                x = x;
                width = width;
                break;
            case "padding_top":
                y = y;
                height = height;
                break;
            case "padding_right":
                x = x;
                width = width;
                break;
            case "padding_bottom":
                y = y;
                height = height;
                break;

            case "slice_left":
            case "slice_top":
            case "slice_right":
            case "slice_bottom":
                _obj.shader.set_param(idx, val);
                break;
        }
    }

    // =============================================

    function update_target() {
        if (!_obj.file_name || _obj.file_name.find(".") != null) {
            refresh_texture();
        } else if (!_has_callback) {
            _has_callback = true;
            ::fe.add_transition_callback(this, "on_transition");
        }
    }

    function on_transition(ttype, var, ttime) {
        switch (ttype) {
            case Transition.ToNewList:
            case Transition.FromOldSelection:
                refresh_texture();
                break;
        }
    }

    function refresh_texture() {
        _obj.shader.set_param("texture_size", _obj.texture_width, _obj.texture_height);
    }

    // =============================================

    function set_slice(left, top, right, bottom) {
        slice_left = left;
        slice_top = top;
        slice_right = right;
        slice_bottom = bottom;
    }

    function set_padding(left, top, right, bottom) {
        padding_left = left;
        padding_top = top;
        padding_right = right;
        padding_bottom = bottom;
    }

    // capture pos values
    function set_pos(...) {
        x = vargv[0];
        y = vargv[1];
        if (vargv.len() == 4) {
            width = vargv[2];
            height = vargv[3];
        }
    }

    function set_rgb(r, g, b) {             _obj.set_rgb(r, g, b); }
    function set_anchor(x, y) {             _obj.set_anchor(x, y); }
    function set_rotation_origin(x, y) {    _obj.set_rotation_origin(x, y); }
    function swap(other_img) {              _obj.swap(other_img); }
    function fix_masked_image() {           _obj.fix_masked_image(); }
    function rawset_index_offset(offset) {  _obj.rawset_index_offset(offset); }
    function rawset_filter_offset(offset) { _obj.rawset_filter_offset(offset); }
    function add_image(...) {        return _obj.add_image.acall(vargv.insert(0, _obj) || vargv); }
    function add_artwork(...) {      return _obj.add_artwork.acall(vargv.insert(0, _obj) || vargv); }
    function add_clone(...) {        return _obj.add_clone.acall(vargv.insert(0, _obj) || vargv); }
    function add_text(...) {         return _obj.add_text.acall(vargv.insert(0, _obj) || vargv); }
    function add_listbox(...) {      return _obj.add_listbox.acall(vargv.insert(0, _obj) || vargv); }
    function add_surface(...) {      return _obj.add_surface.acall(vargv.insert(0, _obj) || vargv); }
}