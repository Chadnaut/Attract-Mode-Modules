/**
 * Example.Fakebox Layout3
 *
 * @summary A fake 3D spinning box with live controls (use mouse).
 * @version 0.0.1 2025-12-05
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Modules
 *
 * @requires
 * @module fakebox 0.2.0 https://github.com/Chadnaut/Attract-Mode-Modules
 * @module perspective 0.6.0 https://github.com/Chadnaut/Attract-Mode-Modules
 */

fe.load_module("fakebox")

local flw = fe.layout.width
local flh = fe.layout.height

local x = flw * 0.5
local y = flh * 0.5
local size = min(flw, flh) * 0.75
local width = size * 0.3
local height = size * 0.35

// -----------------------------------

// Create the box
local f = FakeBox(x, y, width, height)

f.art_front = fe.add_artwork("snap")
f.art_right = fe.add_artwork("snap")
f.art_back = fe.add_artwork("snap")
f.art_left = fe.add_artwork("snap")
f.art_top = fe.add_artwork("snap")
f.art_bottom = fe.add_artwork("snap")

f.art_front.index_offset = 0
f.art_right.index_offset = 1
f.art_back.index_offset = 2
f.art_left.index_offset = 3
f.art_top.index_offset = 4
f.art_bottom.index_offset = 5

// Silence!
f.art_front.video_flags = Vid.NoAudio
f.art_right.video_flags = Vid.NoAudio
f.art_back.video_flags = Vid.NoAudio
f.art_left.video_flags = Vid.NoAudio
f.art_top.video_flags = Vid.NoAudio
f.art_bottom.video_flags = Vid.NoAudio

// -----------------------------------

// State for out property editor
local mode = 0
local props = ["rotation", "thickness", "perspective", "shift", "pinch", "shade", "light"]
local scale = [
    [180, -180],
    [0.0, 1.0],
    [0.0, 1.0],
    [-1.0, 1.0],
    [-1.0, 1.0],
    [0.0, 1.0],
    [90, -90]
]
local left_state = false
local right_state = false
local title = fe.add_text("", 0, 0, flw, flh * 0.1)

// -----------------------------------

fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    // Get the mouse state
    local x = fe.get_input_pos("Mouse Left").tofloat()
    local left = fe.get_input_state("Mouse LeftButton")
    local right = fe.get_input_state("Mouse RightButton")

    // Change edit mode if a mouse button pressed
    if (!left && left_state) mode = modulo(mode + 1, props.len())
    if (!right && right_state) mode = modulo(mode - 1, props.len())
    left_state = left
    right_state = right

    // Set the default values
    f.rotation = 45
    f.thickness = 0.5
    f.perspective = 0.5
    f.shift = 0.0
    f.pinch = 0.0
    f.shade = 0.5
    f.light = 0.0

    // Update the edit mode value
    local p = props[mode]
    local v = mix(scale[mode][0], scale[mode][1], x / flw)
    f[p] = v
    title.msg = format("%s: %.2f", p, v)
}
