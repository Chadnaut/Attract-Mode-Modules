// Mask
//
// > 9-slice image masking
// > Version 0.3.1
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

local module_dir = ::fe.module_dir;

::MaskType <- {
    None = 0,
    Multiply = 1,
    Grayscale = 2,
    Alpha = 3,
    Cutout = 4,
};

class Mask {
    _obj = null;
    _prop = null;
    _prop_defaults = {
        mask = null,
        mask_type = MaskType.Multiply,
        mask_mirror_x = false,
        mask_mirror_y = false,
        mask_slice_left = 0,
        mask_slice_top = 0,
        mask_slice_right = 0,
        mask_slice_bottom = 0,
    };
    _has_callback = false;

    constructor(obj) {
        _obj = obj;
        _obj.shader = ::fe.add_shader(Shader.Fragment, module_dir + "nine-slice-mask.frag");
        _prop = clone _prop_defaults;

        width = _obj.width;
        height = _obj.height;
    }

    function _get(idx) {
        return (idx in _prop) ? _prop[idx]
            : (typeof _obj[idx] == "function") ? @(...) _obj[idx].acall(vargv.insert(0, _obj) || vargv)
            : _obj[idx];
    }

    function _set(idx, val) {
        if (idx in _prop) _prop[idx] = val; else _obj[idx] = val;
        switch (idx) {
            case "mask":
                if (val) {
                    update_target();
                    _obj.shader.set_texture_param("mask", val);
                }
                mask_type = mask_type;
                break;
            case "mask_type":
                _obj.shader.set_param("mask_type", !!mask ? val : 0);
                break;

            case "width":
            case "height":
            case "mask_mirror_x":
            case "mask_mirror_y":
            case "mask_slice_left":
            case "mask_slice_top":
            case "mask_slice_right":
            case "mask_slice_bottom":
                _obj.shader.set_param(idx, val);
                break;
        }
    }

    // =============================================

    function update_target() {
        if (!mask.file_name || mask.file_name.find(".") != null) {
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
        if (mask) _obj.shader.set_param("texture_size", mask.texture_width, mask.texture_height);
    }

    // =============================================

    function set_mask_slice(left, top, right, bottom) {
        mask_slice_left = left;
        mask_slice_top = top;
        mask_slice_right = right;
        mask_slice_bottom = bottom;
    }

    function set_pos(...) {
        x = vargv[0];
        y = vargv[1];
        if (vargv.len() == 4) {
            width = vargv[2];
            height = vargv[3];
        }
    }
}