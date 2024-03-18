class Retention {
    _dir = ::fe.module_dir;
    _obj = null;
    _prop = null;
    _prop_defaults = {
        persistance = 0.0,
    };

    constructor(obj) {
        _prop = clone _prop_defaults;

        local b = ::fe.add_surface(obj.width, obj.height);
        local c = b.add_clone(obj);
        b.visible = false;

        _obj = obj.add_clone(obj);
        _obj.shader = ::fe.add_shader(Shader.Fragment, _dir + "retention.frag")
        _obj.shader.set_texture_param("texture2", b);
    }

    function _get(idx) {
        return (idx in _prop) ? _prop[idx] : _obj[idx];
    }

    function _set(idx, val) {
        if (idx in _prop) _prop[idx] = val; else _obj[idx] = val;
        switch (idx) {
            case "persistance": _obj.shader.set_param(idx, val); break;
        }
    }

    // =============================================

    function set_pos(...) {                 _obj.set_pos.acall(vargv.insert(0, _obj) || vargv); }
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