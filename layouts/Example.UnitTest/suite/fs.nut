local script_dir = ::fe.script_dir;
local support_dir = script_dir + "support/";
::fe.load_module("fs");

describe("FS", function() {

    local write_path = support_dir + "write.txt";
    local rename_path = support_dir + "rename.txt";
    local csv_path = support_dir + "test.csv";
    local pairs_path = support_dir + "pairs.txt";
    local missing_path = support_dir + "missing.txt";
    local dirname_flat = support_dir.slice(0, support_dir.len()-1);
    local dirname_slash = support_dir;

    // -------------------------------------

    it("should open and close", function() {
        local err1 = false;
        try { ::fs.open(pairs_path, "rb").close(); } catch(err) { err1 = true; }
        expect(err1).toBeFalse();
    });

    it("should len", function() {
        local f = ::fs.open(pairs_path, "rb");
        expect(f.len()).toBeGreaterThan(0);
        f.close();
    });

    it("should exists (open)", function() {
        local f = ::fs.open(pairs_path, "rb");
        expect(f.exists()).toBeTrue();
        f.close();
    });

    it("should rewind", function() {
        local f = ::fs.open(pairs_path, "rb");
        f.read_line();
        f.rewind();
        expect(f.read_line()).toBe("key value");
    });

    it("should end", function() {
        local f = ::fs.open(pairs_path, "rb");
        f.read_line();
        f.end();
        expect(f.read_line()).toBeNull();
    });

    it("should seek", function() {
        local f = ::fs.open(pairs_path, "rb");
        f.seek(1);
        expect(f.read_line()).toBe("ey value");
    });

    it("should read_line", function() {
        local f = ::fs.open(pairs_path, "rb");
        local res = f.read_line();
        expect(typeof res).toBe("string");
        expect(res.len()).toBeGreaterThan(0);
        f.close();
    });

    it("should read_lines", function() {
        local f = ::fs.open(pairs_path, "rb");
        local res = f.read_lines();
        expect(typeof res).toBe("array");
        expect(res.len()).toBeGreaterThan(0);
        f.close();
    });

    it("should read", function() {
        local f = ::fs.open(pairs_path, "rb");
        local res = f.read();
        expect(typeof res).toBe("string");
        expect(res.len()).toBeGreaterThan(0);
        f.close();
    });

    it("should write_line", function() {
        local f = ::fs.open(write_path, "wb");
        f.write_line("test");
        f.close();
        expect(::fs.read(write_path)).toBe("test\n");
        ::fs.unlink(write_path);
    });

    it("should write_lines", function() {
        local f = ::fs.open(write_path, "wb");
        f.write_lines(["test1","test2"]);
        f.close();
        expect(::fs.read(write_path)).toEqual("test1\ntest2\n");
        ::fs.unlink(write_path);
    });

    it("should write", function() {
        local f = ::fs.open(write_path, "wb");
        f.write("test");
        f.write("1");
        f.close();
        expect(::fs.read(write_path)).toEqual("test1");
        ::fs.unlink(write_path);
    });

    it("should read_csv_line", function() {
        local f = ::fs.open(csv_path, "rb");
        local res = f.read_csv_line();
        expect(typeof res).toBe("array");
        expect(res.len()).toBeGreaterThan(0);
        f.close();
    });

    it("should read_csv", function() {
        local f = ::fs.open(csv_path, "rb");
        local res = f.read_csv();
        expect(typeof res).toBe("array");
        expect(res.len()).toBeGreaterThan(0);
        f.close();
    });

    it("should write_csv_line", function() {
        local f = ::fs.open(write_path, "wb");
        f.write_csv_line(["test1","test2"]);
        f.close();
        expect(::fs.read(write_path)).toEqual("test1;test2\n");
        ::fs.unlink(write_path);
    });

    it("should write_csv", function() {
        local f = ::fs.open(write_path, "wb");
        f.write_csv([["test1","test2"],["test3","test4"]]);
        f.close();
        expect(::fs.read(write_path)).toEqual("test1;test2\ntest3;test4\n");
        ::fs.unlink(write_path);
    });

    it("should read_pairs_line", function() {
        local f = ::fs.open(pairs_path, "rb");
        local res;

        res = f.read_pairs_line();
        expect(typeof res).toBe("array");
        expect(res.len()).toBe(2);

        res = f.read_pairs_line();
        expect(typeof res).toBe("array");
        expect(res.len()).toBe(2);

        f.close();
    });

    it("should read_pairs", function() {
        local f = ::fs.open(pairs_path, "rb");
        local res = f.read_pairs();
        expect(typeof res).toBe("array");
        expect(res.len()).toBeGreaterThan(0);
        f.close();
    });

    it("should write_pairs_line", function() {
        local f = ::fs.open(write_path, "wb");
        f.write_pairs_line(["test1","test2"]);
        f.close();
        expect(::fs.read(write_path)).toEqual("test1 test2\n");
        ::fs.unlink(write_path);
    });

    it("should write_pairs", function() {
        local f = ::fs.open(write_path, "wb");
        f.write_pairs([["test1","test2"],["test3","test4"]]);
        f.close();
        expect(::fs.read(write_path)).toEqual("test1 test2\ntest3 test4\n");
        ::fs.unlink(write_path);
    });

    // -------------------------------------

    it("should add_trailing_slash", function() {
        expect(::fs.add_trailing_slash("a")).toBe("a/");
        expect(::fs.add_trailing_slash("a/")).toBe("a/");
        expect(::fs.add_trailing_slash("a\\")).toBe("a/");
    });

    it("should remove_trailing_slash", function() {
        expect(::fs.remove_trailing_slash("a")).toBe("a");
        expect(::fs.remove_trailing_slash("a/")).toBe("a");
        expect(::fs.remove_trailing_slash("a\\")).toBe("a");
    });

    it("should join", function() {
        expect(::fs.join("a", "b")).toBe("a/b");
        expect(::fs.join("a/", "b")).toBe("a/b");
        expect(::fs.join("a", "b/")).toBe("a/b/");
        expect(::fs.join("a/", "b/")).toBe("a/b/");
    });

    it("should readdir", function() {
        expect(::fs.readdir(pairs_path).len()).toBe(0);
        expect(::fs.readdir(dirname_flat).len()).toBeGreaterThan(0);
        expect(::fs.readdir(dirname_slash).len()).toBeGreaterThan(0);
        expect(::fs.readdir(missing_path).len()).toBe(0);
    });

    it("should exists", function() {
        expect(::fs.exists(pairs_path)).toBeTrue();
        expect(::fs.exists(dirname_flat)).toBeTrue();
        expect(::fs.exists(dirname_slash)).toBeTrue();
        expect(::fs.exists(missing_path)).toBeFalse();
    });

    it("should file_exists", function() {
        expect(::fs.file_exists(pairs_path)).toBeTrue();
        expect(::fs.file_exists(dirname_flat)).toBeFalse();
        expect(::fs.file_exists(dirname_slash)).toBeFalse();
        expect(::fs.file_exists(missing_path)).toBeFalse();
    });

    it("should directory_exists", function() {
        expect(::fs.directory_exists(pairs_path)).toBeFalse();
        expect(::fs.directory_exists(dirname_flat)).toBeTrue();
        expect(::fs.directory_exists(dirname_slash)).toBeTrue();
        expect(::fs.directory_exists(missing_path)).toBeFalse();
    });

    // -------------------------------------

    it("should rename", function() {
        ::fs.write(write_path, "test");
        if (::fs.file_exists(rename_path)) ::fs.unlink(rename_path);
        expect(::fs.file_exists(write_path)).toBeTrue();
        expect(::fs.file_exists(rename_path)).toBeFalse();
        ::fs.rename(write_path, rename_path);
        expect(::fs.file_exists(write_path)).toBeFalse();
        expect(::fs.file_exists(rename_path)).toBeTrue();
    });

    it("should copy", function() {
        ::fs.write(write_path, "test");
        if (::fs.file_exists(rename_path)) ::fs.unlink(rename_path);
        expect(::fs.file_exists(write_path)).toBeTrue();
        expect(::fs.file_exists(rename_path)).toBeFalse();
        ::fs.copy(write_path, rename_path);
        expect(::fs.file_exists(write_path)).toBeTrue();
        expect(::fs.file_exists(rename_path)).toBeTrue();
    });

    it("should move", function() {
        ::fs.write(write_path, "test");
        if (::fs.file_exists(rename_path)) ::fs.unlink(rename_path);
        expect(::fs.file_exists(write_path)).toBeTrue();
        expect(::fs.file_exists(rename_path)).toBeFalse();
        ::fs.move(write_path, rename_path);
        expect(::fs.file_exists(write_path)).toBeFalse();
        expect(::fs.file_exists(rename_path)).toBeTrue();
    });

    it("should crc32", function() {
        expect(typeof ::fs.crc32(pairs_path)).toBe("integer");
        local err1 = false;
        local err2 = false;
        try { ::fs.crc32(dirname_flat); } catch (err) { err1 = true; }
        try { ::fs.crc32(missing_path); } catch (err) { err2 = true; }
        expect(err1).toBeTrue();
        expect(err2).toBeTrue();
    });

    // -------------------------------------

    it("should file_size", function() {
        expect(::fs.file_size(pairs_path)).toBeGreaterThan(0);
        local err1 = false;
        local err2 = false;
        try { ::fs.file_size(dirname_flat); } catch (err) { err1 = true; }
        try { ::fs.file_size(missing_path); } catch (err) { err2 = true; }
        expect(err1).toBeTrue();
        expect(err2).toBeTrue();
    });

    // -------------------------------------

    local run_test = function(flag, init, change) {
        local f;
        local read_err = false
        local write_err = false
        local create_err = false
        local read = null;
        local write = null;
        local create = null;

        ::fs.write(write_path, init);

        try { f = ::fs.open(write_path, flag); read = f.read(); } catch(err) { read_err = true; }
        if (f) f.close();

        try { f = ::fs.open(write_path, flag); f.write(change); } catch(err) { write_err = true; }
        if (f) f.close();
        write = ::fs.read(write_path);

        ::fs.unlink(write_path);
        try { f = ::fs.open(write_path, flag); f.write(change); } catch(err) { create_err = true; }
        if (f) f.close();
        create = ::fs.file_exists(write_path);

        return {
            read_err = read_err,
            read = read,
            write_err = write_err,
            write = write,
            create_err = create_err,
            create = create,
        };
    }

    it("should flag", function() {
        local res = run_test("rb", "aaa", "b");
        expect(res.read_err).toBeFalse();
        expect(res.read).toBe("aaa");
        expect(res.write_err).toBeTrue();
        expect(res.write).toBe("aaa");
        expect(res.create_err).toBeTrue();
        expect(res.create).toBeFalse();

        local res = run_test("r+", "aaa", "b");
        expect(res.read_err).toBeFalse();
        expect(res.read).toBe("aaa");
        expect(res.write_err).toBeFalse();
        expect(res.write).toBe("baa");
        expect(res.create_err).toBeTrue();
        expect(res.create).toBeFalse();

        local res = run_test("wb", "aaa", "b");
        expect(res.read_err).toBeFalse();
        expect(res.read).toBe(null);
        expect(res.write_err).toBeFalse();
        expect(res.write).toBe("b");
        expect(res.create_err).toBeFalse();
        expect(res.create).toBeTrue();

        local res = run_test("w+", "aaa", "b");
        expect(res.read_err).toBeFalse();
        expect(res.read).toBe(null);
        expect(res.write_err).toBeFalse();
        expect(res.write).toBe("b");
        expect(res.create_err).toBeFalse();
        expect(res.create).toBeTrue();

        local res = run_test("a", "aaa", "b");
        expect(res.read_err).toBeTrue();
        expect(res.read).toBe(null);
        expect(res.write_err).toBeFalse();
        expect(res.write).toBe("aaab");
        expect(res.create_err).toBeFalse();
        expect(res.create).toBeTrue();

        local res = run_test("a+", "aaa", "b");
        expect(res.read_err).toBeFalse();
        expect(res.read).toBe("aaa");
        expect(res.write_err).toBeFalse();
        expect(res.write).toBe("aaab");
        expect(res.create_err).toBeFalse();
        expect(res.create).toBeTrue();
    });

    // -------------------------------------

    it("should unlink", function() {
        ::fs.write(write_path, "test");
        ::fs.write(rename_path, "test");
        expect(::fs.file_exists(write_path)).toBeTrue();
        expect(::fs.file_exists(rename_path)).toBeTrue();
        ::fs.unlink(write_path);
        ::fs.unlink(rename_path);
        expect(::fs.file_exists(write_path)).toBeFalse();
        expect(::fs.file_exists(rename_path)).toBeFalse();
    });
});