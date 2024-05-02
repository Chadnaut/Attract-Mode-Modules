::fe.load_module("stringify");
::fe.load_module("fs");

describe("FileSystem Read", function() {

    it("stringify", function () {
        local f = ::fs.open(FeConfigDirectory + "attract.cfg", "r");
        local v = stringify(f.read_lines());
        f.close();
    });

    it("read_lines", function () {
        local f = ::fs.open(FeConfigDirectory + "attract.cfg", "r");
        local v = f.read_lines();
        f.close();
    });

    it("read", function () {
        local f = ::fs.open(FeConfigDirectory + "attract.cfg", "r");
        local v = f.read();
        f.close();
    });

    it("crc32", function () {
        local v = ::fs.crc32(FeConfigDirectory + "attract.cfg");
    });

    it("size", function () {
        local v = ::fs.file_size(FeConfigDirectory + "attract.cfg");
    });
});