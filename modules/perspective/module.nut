// Perspective
//
// > Perspective correct texture mapping
// > Version 0.5.4
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

local module_dir = ::fe.module_dir;

class Perspective {
    _ver = OS == "OSX" ? "120" : "130";
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
        _obj.shader = ::fe.add_shader(
            Shader.VertexAndFragment,
            ::format("%sperspective-%s.vert", module_dir, _ver),
            ::format("%sperspective-%s.frag", module_dir, _ver)
        );
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
        return (idx in _prop) ? _prop[idx]
            : (typeof _obj[idx] == "function") ? @(...) _obj[idx].acall(vargv.insert(0, _obj) || vargv)
            : _obj[idx];
    }

    function _set(idx, val) {
        if (idx in _prop) _prop[idx] = val; else _obj[idx] = val;
        switch (idx) {
            case "skew_x":
                offset_bl_x = skew_x + pinch_x;
                offset_br_x = skew_x - pinch_x;
                break;
            case "skew_y":
                offset_tr_y = skew_y + pinch_y;
                offset_br_y = skew_y - pinch_y;
                break;
            case "pinch_x":
                offset_bl_x = skew_x + pinch_x;
                offset_br_x = skew_x - pinch_x;
                break;
            case "pinch_y":
                offset_tr_y = skew_y + pinch_y;
                offset_br_y = skew_y - pinch_y;
                break;

            case "width":
            case "offset_tl_x":
            case "offset_bl_x":
            case "offset_tr_x":
            case "offset_br_x":
                _obj.shader.set_param(idx, val * ScreenWidth / ::fe.layout.width);
                break;

            case "height":
            case "offset_tl_y":
            case "offset_bl_y":
            case "offset_tr_y":
            case "offset_br_y":
                _obj.shader.set_param(idx, val * ScreenHeight / ::fe.layout.height);
                break;

            case "rotation":
                _obj.shader.set_param(idx, val);
                break;
        }
    }

    // =============================================

    function set_offset(tl_x, tl_y, tr_x, tr_y, bl_x, bl_y, br_x, br_y) {
        offset_tl_x = tl_x;
        offset_tl_y = tl_y;
        offset_tr_x = tr_x;
        offset_tr_y = tr_y;
        offset_bl_x = bl_x;
        offset_bl_y = bl_y;
        offset_br_x = br_x;
        offset_br_y = br_y;
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
}