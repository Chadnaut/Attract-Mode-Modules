fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("unittest");

local run_self_tests = true;
local run_squirrel_tests = true;
local run_list_tests = true; // Require Confirm Favourites = No
local run_module_tests = true; // Require other modules from the repo
local run_display_tests = false; // Require ALL displays to use this layout
local run_overlay_tests = false; // Require "scripts" in your AM folder (see the repo)

local ut = UnitTest();
::describe <- ut.describe.bindenv(ut);
::fdescribe <- ut.fdescribe.bindenv(ut);
::xdescribe <- ut.xdescribe.bindenv(ut);

if (run_self_tests) {
    fe.do_nut("suite/unittest.nut");
}

if (run_squirrel_tests) {
    fe.do_nut("suite/operators.nut");
    fe.do_nut("suite/math.nut");
}

if (run_list_tests) {
    fe.do_nut("suite/fe_list_index.nut");
    fe.do_nut("suite/fe_list_transition.nut");
    fe.do_nut("suite/fe_filter_index.nut");
    fe.do_nut("suite/fe_filter_transition.nut");
}

if (run_module_tests) {
    fe.do_nut("suite/fs.nut");
    fe.do_nut("suite/regex.nut");
    fe.do_nut("suite/stringify.nut");
    fe.do_nut("suite/quicksort.nut");
}

if (run_display_tests) {
    fe.do_nut("suite/fe_display_index.nut");
    fe.do_nut("suite/fe_display_transition.nut");
}

if (run_overlay_tests) {
    fe.do_nut("suite/fe_overlay_transition.nut");
}

ut.test();
