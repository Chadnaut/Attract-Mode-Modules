// Blur
//
// > Gaussian blur
// > Version 0.1.0
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

local module_dir = ::fe.module_dir;
local log2 = 0.69314;

class Blur {
    _obj = null;
    _prop = null;
    _prop_defaults = {
        blur_mask = null,
        blur_size = 0.0,
        blur_rotation = 0.0,
        blur_channel = false,
        blur_fast = false,
        is_surface = false,
    };
    _default = {
        mask = null,
    };

    constructor(obj) {
        _obj = obj;
        _prop = clone _prop_defaults;

        // default mask
        if (!_default.mask) {
            _default.mask = ::fe.add_image(module_dir + "pixel.png", 0, 0, 1, 1);
            _default.mask.visible = false;
        }

        // re-set existing props to update shader
        is_surface = _obj.clear || _obj.redraw; // best-guess is target is shader
        blur_fast = false;
    }

    function _get(idx) {
        return (idx in _prop)
            ? _prop[idx]
            : (typeof _obj[idx] == "function") ? @(...) _obj[idx].acall(vargv.insert(0, _obj) || vargv)
            : _obj[idx];
    }

    function _set(idx, val) {
        if (idx in _prop) _prop[idx] = val;
        else _obj[idx] = val;
        switch (idx) {
            case "width":
            case "height":
            case "is_surface":
            case "blur_channel":
                _obj.shader.set_param(idx, val);
                break;
            case "blur_fast":
                _obj.shader = ::fe.add_shader(
                    Shader.Fragment,
                    module_dir + (val ? "blur-mipmap.frag" : "blur-gaussian.frag")
                );
                if (val) _obj.mipmap = true;
                width = _obj.width;
                height = _obj.height;
                foreach(k, v in _prop) if (k != idx) this[k] = v;
                break;
            case "blur_size":
                // approximate blur_size for LOD
                if (blur_fast) val = (::log(val) / log2) / 1.5;
                _obj.shader.set_param(idx, val);
                break;
            case "blur_rotation":
                _obj.shader.set_param(idx, (90 + val) / -180.0 * ::PI);
                break;
            case "blur_mask":
                _obj.shader.set_texture_param(idx, val || _default.mask);
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
}