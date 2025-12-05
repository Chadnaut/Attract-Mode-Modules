/**
 * Example.Perspective Layout
 *
 * @summary How to use the perspective module.
 * @version 0.6.0 2025-03-11
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Modules
 *
 * @requires
 * @module perspective 0.6.0 https://github.com/Chadnaut/Attract-Mode-Modules
 */

// -----------------------------------------------------------------------------

// Common variables
local flw = fe.layout.width
local flh = fe.layout.height

// Footer text
local msg = format("%s - %s", split(fe.script_dir, "/").top(), fe.script_file.slice(0, -4))
local txt = fe.add_text(msg, 0, flh * 0.95, flw, flh * 0.05)
txt.align = Align.BottomLeft
txt.zorder = 1000

// -----------------------------------------------------------------------------

// Load the module
fe.load_module("perspective")

// Image setup
local x = flw * 0.05
local y = flh * 0.2
local w = flw * 0.425
local h = flh * 0.6
local img = "check.png"

// Wrap an Image with the Perspective class
local a = fe.add_image(img, x, y, w, h)
local b = Perspective(fe.add_image(img, x * 2 + w, y, w, h))

// -----------------------------------------------------------------------------

// Image animate
fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    local s = w * cos(ttime / 1000.0) * 0.25
    a.pinch_x = s
    a.pinch_y = s
    b.pinch_x = s
    b.pinch_y = s
}
