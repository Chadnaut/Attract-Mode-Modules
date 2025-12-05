/**
 * Example.Fakebox Layout
 *
 * @summary A fake 3D spinning box with simple artwork.
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

// Do some math
local x = flw * 0.5
local y = flh * 0.5
local size = min(flw, flh) * 0.75
local width = size * 0.3
local height = size * 0.35

// Create the box
local f = FakeBox(x, y, width, height)
f.thickness = 0.5
f.perspective = 0.5
f.shift = 0.0
f.pinch = 0.0
f.shade = 0.5
f.light = 0.0

// Assign the sides
f.art_front = fe.add_artwork("snap")
f.art_right = fe.add_artwork("snap")
f.art_back = fe.add_artwork("snap")
f.art_left = fe.add_artwork("snap")
f.art_top = fe.add_artwork("snap")
f.art_bottom = fe.add_artwork("snap")

// Make all the sides different
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

// Rotate the box
fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    f.rotation = (ttime / 1000.0) * 45
}
