describe("Array Join", function() {
    local arr1 = [1,2,3,4,5,6,7,8,9,0];
    local delim = ",";

    it("native", function () {
        return arr1.reduce(@(r, v) r + delim + v);
    });

    it("shift", function () {
        local str = arr1[0];
        foreach (i, v in arr1.slice(1)) str += delim + v;
        return str;
    });

    it("slice", function () {
        local str = "";
        foreach (v in arr1) str += delim + v;
        return str.slice(delim.len());
    });

    it("ternary", function () {
        local str = "";
        foreach (i, v in arr1) str += i ? delim+v : v;
        return str;
    });

    it("set", function () {
        local str = "";
        local d = "";
        foreach (v in arr1) {
            str += d + v;
            d = delim;
        }
        return str;
    });

});