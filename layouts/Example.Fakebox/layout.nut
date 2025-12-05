/**
 * Example.Fakebox Layout
 *
 * @summary A fake 3D spinning box with texture wrapped artwork.
 * @version 0.0.1 2025-12-05
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Modules
 *
 * @requires
 * @module fakebox 0.2.0 https://github.com/Chadnaut/Attract-Mode-Modules
 * @module perspective 0.6.0 https://github.com/Chadnaut/Attract-Mode-Modules
 *
 * @see https://emumovies.com/files/file/646-sega-genesis-boxes-texture-pack-1089/
 */

fe.load_module("fakebox")

local flw = fe.layout.width
local flh = fe.layout.height
local bg = fe.add_rectangle(0, 0, flw, flh)
bg.alpha = 230

// -----------------------------------

/**
 * Add a cover image containing back/spine/front to the given FakeBox
 * @param {feSurface} parent The container to create images on, usually `fe`
 * @param {FakeBox} obj The FakeBox object
 * @param {string($image)} filename The filename for the wrapped cover image
 * @param {float} spine The ratio of the spine in the cover image
 */
function apply_cover(parent, obj, filename, spine = 0.086) {
    if (!obj.art_front) {
        local img_top = parent.add_image("top.png")
        local img_edge = parent.add_image("edge.png")
        local img_cover = parent.add_image(filename)
        local img_shadow = parent.add_image("shadow.png")
        img_top.mipmap = true
        img_edge.mipmap = true
        img_cover.mipmap = true
        img_shadow.mipmap = true

        // The front image is cloned for the left and back sides
        obj.art_front = img_cover
        obj.art_left = fe.add_clone(img_cover)
        obj.art_back = fe.add_clone(img_cover)
        obj.art_right = img_edge
        obj.art_top = img_top
        obj.art_bottom = fe.add_clone(img_top) // bottom is cloned from top
        obj.art_shadow = img_shadow
        obj.art_shadow.set_rgb(0, 0, 0)
        obj.art_shadow.alpha = 48
    }

    obj.art_front.file_name = filename
    local cover_total = obj.art_front.texture_width // 1061
    local cover_spine = cover_total * spine // 91
    local cover_width = (cover_total - cover_spine) / 2.0

    // Adjust the cloned subimg to show the correct portion of the cover
    obj.art_front.subimg_width = cover_width
    obj.art_front.subimg_x = cover_total - cover_width
    obj.art_left.subimg_width = cover_spine
    obj.art_left.subimg_x = cover_width
    obj.art_back.subimg_width = cover_width
    obj.art_back.subimg_x = 0
}

// -----------------------------------

local x = flw * 0.5
local y = flh * 0.5
local size = min(flw, flh) * 0.75
local width = size * 0.3
local height = size * 0.35

// Create the box
local f = FakeBox(x, y, width, height)
f.thickness = 0.25
f.shift = 1.0
f.pinch = 0.025
f.shadow_dist = 0.25
f.shadow_size = 1.25

// Apply the cover using the helper method
apply_cover(fe, f, "Earthworm Jim (USA).jpg")

// -----------------------------------

fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    f.rotation = (ttime / 1000.0) * 45
}
