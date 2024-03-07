class Perspective {
    _obj = null;
    _prop = null;
    _prop_defaults = {
        skew_x = 0.0,
        skew_y = 0.0,
        pinch_x = 0.0,
        pinch_y = 0.0,
        offset_tl_x = 0.0,
        offset_tl_y = 0.0,
        offset_bl_x = 0.0,
        offset_bl_y = 0.0,
        offset_tr_x = 0.0,
        offset_tr_y = 0.0,
        offset_br_x = 0.0,
        offset_br_y = 0.0,
    };

    constructor(obj) {
        _obj = obj;
        _obj.shader = ::fe.add_shader(Shader.VertexAndFragment, ::fe.module_dir + "perspective.vert", ::fe.module_dir + "perspective.frag");
        _prop = clone _prop_defaults;

        // re-set existing props to update shader
        width = _obj.width;
        height = _obj.height;
        rotation = _obj.rotation;
        skew_x = _obj.skew_x;
        skew_y = _obj.skew_y;
        pinch_x = _obj.pinch_x;
        pinch_y = _obj.pinch_y;

        // clear obj props as the shader handles them now
        _obj.skew_x = 0;
        _obj.skew_y = 0;
        _obj.pinch_x = 0;
        _obj.pinch_y = 0;
    }

    function _get(idx) {
        return (idx in _prop) ? _prop[idx] : _obj[idx];
    }

    function _set(idx, val) {
        switch (idx) {
            // capture props to replicate classic AM skew & pinch
            case "skew_x":
                _prop[idx] = val;
                offset_bl_x = _prop.skew_x + _prop.pinch_x;
                offset_br_x = _prop.skew_x - _prop.pinch_x;
                break;
            case "skew_y":
                _prop[idx] = val;
                offset_tr_y = _prop.skew_y + _prop.pinch_y;
                offset_br_y = _prop.skew_y - _prop.pinch_y;
                break;
            case "pinch_x":
                _prop[idx] = val;
                offset_bl_x = _prop.skew_x + _prop.pinch_x;
                offset_br_x = _prop.skew_x - _prop.pinch_x;
                break;
            case "pinch_y":
                _prop[idx] = val;
                offset_tr_y = _prop.skew_y + _prop.pinch_y;
                offset_br_y = _prop.skew_y - _prop.pinch_y;
                break;

            // additional values required by the shader
            case "width":
            case "height":
            case "rotation":
                _obj[idx] = val;
                _obj.shader.set_param(idx, val);
                break;

            // vertex offsets may be set directly
            case "offset_tl_x":
            case "offset_tl_y":
            case "offset_bl_x":
            case "offset_bl_y":
            case "offset_tr_x":
            case "offset_tr_y":
            case "offset_br_x":
            case "offset_br_y":
                _prop[idx] = val;
                _obj.shader.set_param(idx, val);
                break;

            // pass through all other props
            default:
                _obj[idx] = val;
                break;
        }
    }

    // =============================================

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

    function add_image(...) {   return _obj.add_image.acall(vargv.insert(0, _obj) || vargv);    }
    function add_artwork(...) { return _obj.add_artwork.acall(vargv.insert(0, _obj) || vargv);  }
    function add_clone(...) {   return _obj.add_clone.acall(vargv.insert(0, _obj) || vargv);    }
    function add_text(...) {    return _obj.add_text.acall(vargv.insert(0, _obj) || vargv);     }
    function add_listbox(...) { return _obj.add_listbox.acall(vargv.insert(0, _obj) || vargv);  }
    function add_surface(...) { return _obj.add_surface.acall(vargv.insert(0, _obj) || vargv);  }
}