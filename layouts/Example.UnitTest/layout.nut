fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("unittest");

local ut = UnitTest();
::describe <- ut.describe.bindenv(ut);
::fdescribe <- ut.fdescribe.bindenv(ut);
::xdescribe <- ut.xdescribe.bindenv(ut);

fe.do_nut("suite/unittest.nut");
fe.do_nut("suite/operators.nut");
fe.do_nut("suite/math.nut");

fe.do_nut("suite/fe_list_index.nut");
fe.do_nut("suite/fe_list_transition.nut");
fe.do_nut("suite/fe_filter_index.nut");
fe.do_nut("suite/fe_filter_transition.nut");

// // These suites require ALL displays to use this layout
// // - The display will be changed during these tests
// fe.do_nut("suite/fe_display_index.nut");
// fe.do_nut("suite/fe_display_transition.nut");

// // These suites require "scripts" in your AM folder (see the repo)
// // - Overlays will be shown during these tests
// // - Keypresses will be fired during these tests
// fe.do_nut("suite/fe_overlay_transition.nut");

ut.test();
