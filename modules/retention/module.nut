// Retention
//
// > Surface image persistence
// > Version 0.7.2
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

local module_dir = ::fe.module_dir;

class Retention {
    _obj = null;
    _prop = null;
    _prop_defaults = {
        persistence = 0.0,
        falloff = 0.0,
    };

    constructor(obj) {
        _prop = clone _prop_defaults;

        local b = ::fe.add_surface(obj.width, obj.height);
        b.mipmap = true;
        local c = b.add_clone(obj);
        _obj = obj.add_clone(b);
        _obj.zorder = -2147483647;
        _obj.shader = ::fe.add_shader(Shader.Fragment, module_dir + "retention.frag")
        _obj.shader.set_texture_param("texture2", obj);
        c.set_pos(0, 0);
        b.visible = false;
    }

    function _get(idx) {
        return (idx in _prop) ? _prop[idx]
            : (typeof _obj[idx] == "function") ? @(...) _obj[idx].acall(vargv.insert(0, _obj) || vargv)
            : _obj[idx];
    }

    function _set(idx, val) {
        if (idx in _prop) _prop[idx] = val; else _obj[idx] = val;
        switch (idx) {
            case "persistence":
            case "falloff": _obj.shader.set_param(idx, val); break;
        }
    }
}