fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("unittest");

local ut = UnitTest();
::describe <- ut.describe.bindenv(ut);
::fdescribe <- ut.fdescribe.bindenv(ut);
::xdescribe <- ut.xdescribe.bindenv(ut);

fe.do_nut("suite/array.clear.nut");
fe.do_nut("suite/array.clone.nut");
fe.do_nut("suite/array.create.nut");
fe.do_nut("suite/array.extend.nut");
fe.do_nut("suite/array.filter.nut");
fe.do_nut("suite/array.find.nut");
fe.do_nut("suite/array.join.nut");
fe.do_nut("suite/array.loop.nut");
fe.do_nut("suite/array.map.nut");
fe.do_nut("suite/array.reduce.nut");
fe.do_nut("suite/array.sort.nut");
fe.do_nut("suite/array.top.nut");
fe.do_nut("suite/array.unique.nut");
fe.do_nut("suite/fs.read.nut");
fe.do_nut("suite/func.call.nut");
fe.do_nut("suite/func.nest.nut");
fe.do_nut("suite/string.escape.nut");
fe.do_nut("suite/string.format.nut");
fe.do_nut("suite/string.split.nut");
fe.do_nut("suite/string.strip.nut");
fe.do_nut("suite/table.slot.nut");
fe.do_nut("suite/variable.getter.nut");

ut.benchmark(100);
