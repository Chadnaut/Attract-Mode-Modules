/**
 * FakeBox
 *
 * @summary A fake 3D spinning box.
 * @version 0.2.0 2025-12-05
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Modules
 */

if (FeVersionNum < 320) fe.log("Warning: FakeBox requires Attract-Mode Plus v3.2.0 or higher")

fe.load_module("perspective")

/**
 * A fake 3D spinning box.
 * @property {float} x The x position of the box centre.
 * @property {float} y The y position of the box centre.
 * @property {float} width The width of the box.
 * @property {float} height The height of the box.
 * @property {float} rotation The rotation of the 3D box.
 * @property {float} thickness The thickness of the box [0.0...1.0]
 * @property {float} perspective The distortion of the 3D effect [0.0...1.0]
 * @property {float} shift The vertical shift of the 3D effect [-1.0...1.0]
 * @property {float} pinch The pinch of the 3D effect [-1.0...1.0]
 * @property {float} shade The strength of the shading [0.0...1.0]
 * @property {float} light The angle of the light source, `0` = front [0...360]
 * @property {float} shadow_dist The distance of the shadow from the box bottom, [0.0...1.0]
 * @property {float} shadow_size The size of the shadow
 * @property {integer} zorder The zorder of the lowest image
 * @property {feImage} art_front The object for the front face
 * @property {feImage} art_right The object for the right face
 * @property {feImage} art_back The object for the back face
 * @property {feImage} art_left The object for the left face
 * @property {feImage} art_top The object for the top face
 * @property {feImage} art_bottom The object for the bottom face
 * @property {feImage} art_shadow The object for the shadow
 * @type {FakeBox}
 */
class FakeBox {
    /** @private Class properties */
    _prop = {
        x = 0.0,
        y = 0.0,
        width = 0.0,
        height = 0.0,
        rotation = 0.0,
        thickness = 1.0,
        perspective = 0.25,
        shift = 0.0,
        pinch = 0.0,
        shade = 0.5,
        light = 0.0,
        shadow_dist = 0.25,
        shadow_size = 1.0,
        zorder = 0,
        art_front = null,
        art_right = null,
        art_back = null,
        art_left = null,
        art_top = null,
        art_bottom = null,
        art_shadow = null
    }

    /**
     * Create a fake box.
     * @constructor
     * @param {float} x The x position of the box centre.
     * @param {float} y The y position of the box centre.
     * @param {float} width The width of the box.
     * @param {float} height The height of the box.
     * @augments obj Class inherit properties of obj.
     */
    constructor(x = 0, y = 0, width = 0, height = 0) {
        _prop = clone _prop
        set_pos(x, y, width, height)
    }

    /**
     * Set the position of the box
     * @param {float} x The x position of the box centre.
     * @param {float} y The y position of the box centre.
     * @param {float} width The width of the box.
     * @param {float} height The height of the box.
     */
    function set_pos(x, y, width = null, height = null) {
        _prop.x = x
        _prop.y = y
        if (width != null) _prop.width = width
        if (height != null) _prop.height = height
        redraw()
    }

    /** @private Calculate point positions */
    function geom(d, mul, add) {
        local r = rotation / 180.0
        local r1 = (r + d + 0.75) * PI
        local r2 = (r - d + 0.25) * PI
        local r3 = (r + d - 0.25) * PI
        local r4 = (r - d - 0.75) * PI
        local m = Vec2(width, height * perspective).componentMul(mul)
        return [
            Vec2(cos(r1), sin(r1)).componentMul(m) + add,
            Vec2(cos(r2), sin(r2)).componentMul(m) + add,
            Vec2(cos(r3), sin(r3)).componentMul(m) + add,
            Vec2(cos(r4), sin(r4)).componentMul(m) + add
        ]
    }

    /** @private Darken art depending on rotation */
    function apply_shade(art, r) {
        if (shade == null) return
        local m = 0
        if (r != null) m = shade * max(cos(radians(rotation - light + r)), 0)
        local c = (1.0 - shade + m) * 255
        art.set_rgb(c, c, c)
    }

    /** @private Set all the perspective offsets */
    function apply_offset(art, a, b, c, d) {
        art.set_pos(x, y, 0.01, 0.01)
        art.set_offset(a.x, a.y, b.x, b.y, c.x, c.y, d.x, d.y)
    }

    /** @private Redraw all the sides */
    function redraw() {
        local rad1 = (1.0 - thickness) * 0.25
        local rad2 = (1.0 - thickness * shadow_size) * 0.25
        local top_mul = Vec2(1.0 + min(pinch, 0.0), shift - perspective)
        local bot_mul = Vec2(1.0 - max(pinch, 0.0), shift + perspective)
        local offset = Vec2(0, height)
        local z0 = perspective > 0 ? 2 : 3
        local z1 = perspective > 0 ? 3 : 2

        local t = geom(rad1, top_mul, -offset)
        local b = geom(rad1, bot_mul, offset)
        local s = geom(rad2, bot_mul * shadow_size, offset * (1.0 + shadow_dist))

        if (art_front) {
            apply_offset(art_front, t[0], t[1], b[0], b[1])
            art_front.zorder = zorder + (t[0].x < t[1].x ? z1 : z0)
            apply_shade(art_front, 0)
        }
        if (art_right) {
            apply_offset(art_right, t[1], t[2], b[1], b[2])
            art_right.zorder = zorder + (t[1].x < t[2].x ? z1 : z0)
            apply_shade(art_right, -90)
        }
        if (art_back) {
            apply_offset(art_back, t[2], t[3], b[2], b[3])
            art_back.zorder = zorder + (t[2].x < t[3].x ? z1 : z0)
            apply_shade(art_back, -180)
        }
        if (art_left) {
            apply_offset(art_left, t[3], t[0], b[3], b[0])
            art_left.zorder = zorder + (t[3].x < t[0].x ? z1 : z0)
            apply_shade(art_left, -270)
        }
        if (art_top) {
            apply_offset(art_top, t[3], t[2], t[0], t[1])
            art_top.zorder = zorder + (top_mul.y > 0 ? 4 : 1)
            apply_shade(art_top, null)
        }
        if (art_bottom) {
            apply_offset(art_bottom, b[0], b[1], b[3], b[2])
            art_bottom.zorder = zorder + (bot_mul.y < 0 ? 4 : 1)
            apply_shade(art_bottom, null)
        }
        if (art_shadow) {
            apply_offset(art_shadow, s[0], s[1], s[3], s[2])
            art_shadow.zorder = zorder
        }
    }

    /** Return class property or pass-thru */
    function _get(idx) {
        if (idx in _prop) return _prop[idx]
        throw null
    }

    /** Set class property or pass-thru */
    function _set(idx, val) {
        if (idx in _prop) _prop[idx] = val
        else throw null
        switch (idx) {
            case "art_front":
            case "art_right":
            case "art_back":
            case "art_left":
            case "art_top":
            case "art_bottom":
            case "art_shadow":
                _prop[idx] = Perspective(val)
                break
        }
        redraw()
    }
}
