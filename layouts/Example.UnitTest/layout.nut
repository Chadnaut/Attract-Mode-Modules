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

fe.do_nut("suite/fe.list.index.nut");
fe.do_nut("suite/fe.list.filter_index.nut");
// fe.do_nut("suite/fe.list.display_index.nut"); // This suite requires ALL displays to use this layout

ut.test();
