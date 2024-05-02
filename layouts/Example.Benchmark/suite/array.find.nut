describe("Array Find", function() {
    local arr1 = ["a", "b", "c", "d", "e", "f", "g", "h"];
    local obj1 = { a = true, b = true, c = true, d = true, e = true, f = true, g = true, h = true };

    it("find", function () {
        return arr1.find("f") != null;
    });

    it("key", function () {
        return ("f" in obj1);
    });

});