::fe.load_module("fs");

local filename = FeConfigDirectory + "attract.cfg";

describe("FileSystem Read", function() {

    it("read_line", function () {
        local f = ::fs.open(filename, "rb");
        local v;
        while (v = f.read_line()) {}
        f.close();
    });

    it("read_lines", function () {
        local f = ::fs.open(filename, "rb");
        local v = f.read_lines();
        f.close();
    });

    it("read_pairs_line", function () {
        local f = ::fs.open(filename, "rb");
        local v;
        while (v = f.read_pairs_line()) {}
        f.close();
    });

    it("read_pairs", function () {
        local f = ::fs.open(filename, "rb");
        local v = f.read_pairs();
        f.close();
    });

    it("read", function () {
        local f = ::fs.open(filename, "rb");
        local v = f.read();
        f.close();
    });
});