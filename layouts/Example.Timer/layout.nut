/**
 * Example.Timer Layout
 *
 * @summary How to use the timer module.
 * @version 0.3.0 2025-03-27
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Modules
 *
 * @requires
 * @module timer 0.3.0 https://github.com/Chadnaut/Attract-Mode-Modules
 */

// -----------------------------------------------------------------------------

// Common variables
local flw = fe.layout.width
local flh = fe.layout.height

// Footer text
local msg = split(fe.script_dir, "/").top()
local txt = fe.add_text(msg, 0, flh * 0.95, flw, flh * 0.05)
txt.align = Align.BottomLeft
txt.zorder = 1000

// -----------------------------------------------------------------------------

// Load the module
fe.load_module("timer");

// Setup some text elements
local txt1 = fe.add_text("Interval", 0, flh * 0.4, flw, flh * 0.1);
local txt2 = fe.add_text("Timeout", 0, flh * 0.5, flw, flh * 0.1);
local t = 0;

// An interval function is called after each delay
set_interval(function() {
    txt1.msg = t++;
}, 1000);

// A timeout function is called once after a delay
set_timeout(function() {
    txt2.msg = "Done";
}, 4000);
