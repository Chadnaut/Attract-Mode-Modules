/**
 * Perspective
 *
 * @summary Perspective correct texture mapping.
 * @version 0.6.0 2025-12-05
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Modules
 */

local module_dir = ::fe.module_dir
local shader_ver = OS == "OSX" ? "120" : "130"

/**
 * Correct perspective on given object.
 * @param {*} obj The Image or Surface to correct.
 * @returns {PerspectiveClass}
 */
function Perspective(obj) {
    // Do not re-wrap an object that already has perspective
    return "_perspectiveObj" in obj ? obj : PerspectiveClass(obj)
}

/**
 * Perspective correct texture mapping.
 * @property {float} offset_tl_x The top-left corner x offset.
 * @property {float} offset_tl_y The top-left corner y offset.
 * @property {float} offset_tr_x The top-right corner x offset.
 * @property {float} offset_tr_y The top-right corner y offset.
 * @property {float} offset_bl_x The bottom-left corner x offset.
 * @property {float} offset_bl_y The bottom-left corner y offset.
 * @property {float} offset_br_x The bottom-right corner x offset.
 * @property {float} offset_br_y The bottom-right corner y offset.
 * @type {PerspectiveClass}
 * @private
 */
class PerspectiveClass {
    /** @private Flag for checking previous wrapper */
    static _perspectiveObj = true

    /** @private The wrapped object */
    _obj = null

    /** @private Class properties */
    _prop = {
        skew_x = 0.0,
        skew_y = 0.0,
        pinch_x = 0.0,
        pinch_y = 0.0,
        offset_tl_x = 0.0,
        offset_tl_y = 0.0,
        offset_tr_x = 0.0,
        offset_tr_y = 0.0,
        offset_bl_x = 0.0,
        offset_bl_y = 0.0,
        offset_br_x = 0.0,
        offset_br_y = 0.0
    }

    /** @private X position to shader 0.0...1.0 */
    shaderX = @(x) (x * ScreenWidth) / ::fe.layout.width

    /** @private Y position to shader 0.0...1.0 */
    shaderY = @(y) (y * ScreenHeight) / ::fe.layout.height

    /**
     * Correct perspective on given object.
     * @constructor
     * @param {*} obj The Image or Surface to correct.
     * @augments obj Class inherit properties of obj.
     */
    constructor(obj) {
        _obj = obj
        _obj.shader = ::fe.add_shader(
            Shader.VertexAndFragment,
            ::format("%sperspective-%s.vert", module_dir, shader_ver),
            ::format("%sperspective-%s.frag", module_dir, shader_ver)
        )

        _prop = clone _prop

        // reset existing props to update shader
        width = _obj.width
        height = _obj.height
        rotation = _obj.rotation
        skew_x = _obj.skew_x
        skew_y = _obj.skew_y
        pinch_x = _obj.pinch_x
        pinch_y = _obj.pinch_y

        // clear obj props as the shader handles them now
        _obj.skew_x = 0
        _obj.skew_y = 0
        _obj.pinch_x = 0
        _obj.pinch_y = 0
    }

    /** Return class property or pass-thru */
    function _get(idx) {
        return idx in _prop
            ? _prop[idx]
            : typeof _obj[idx] == "function"
              ? @(...) _obj[idx].acall(vargv.insert(0, _obj) || vargv)
              : _obj[idx]
    }

    /** Set class property or pass-thru */
    function _set(idx, val) {
        if (idx in _prop) _prop[idx] = val
        else _obj[idx] = val
        switch (idx) {
            case "skew_x":
                offset_bl_x = skew_x + pinch_x
                offset_br_x = skew_x - pinch_x
                break
            case "skew_y":
                offset_tr_y = skew_y + pinch_y
                offset_br_y = skew_y - pinch_y
                break
            case "pinch_x":
                offset_bl_x = skew_x + pinch_x
                offset_br_x = skew_x - pinch_x
                break
            case "pinch_y":
                offset_tr_y = skew_y + pinch_y
                offset_br_y = skew_y - pinch_y
                break
            case "width":
            case "offset_tl_x":
            case "offset_bl_x":
            case "offset_tr_x":
            case "offset_br_x":
                _obj.shader.set_param(idx, shaderX(val))
                break
            case "height":
            case "offset_tl_y":
            case "offset_bl_y":
            case "offset_tr_y":
            case "offset_br_y":
                _obj.shader.set_param(idx, shaderY(val))
                break
            case "rotation":
                _obj.shader.set_param(idx, val)
                break
        }
    }

    /**
     * Sets the corner offsets.
     * @param {float} tl_x The top-left corner x offset.
     * @param {float} tl_y The top-left corner y offset.
     * @param {float} tr_x The bottom-left corner x offset.
     * @param {float} tr_y The bottom-left corner y offset.
     * @param {float} bl_x The top-right corner x offset.
     * @param {float} bl_y The top-right corner y offset.
     * @param {float} br_x The bottom-right corner x offset.
     * @param {float} br_y The bottom-right corner y offset.
     */
    function set_offset(tl_x, tl_y, tr_x, tr_y, bl_x, bl_y, br_x, br_y) {
        offset_tl_x = tl_x
        offset_tl_y = tl_y
        offset_tr_x = tr_x
        offset_tr_y = tr_y
        offset_bl_x = bl_x
        offset_bl_y = bl_y
        offset_br_x = br_x
        offset_br_y = br_y
    }

    /** @private Capture position values */
    function set_pos(...) {
        x = vargv[0]
        y = vargv[1]
        if (vargv.len() == 4) {
            width = vargv[2]
            height = vargv[3]
        }
    }
}
