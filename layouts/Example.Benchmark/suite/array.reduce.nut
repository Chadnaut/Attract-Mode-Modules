describe("Array Reduce", function() {
    local arr1 = [1,2,3,4,5,6,7,8,9,0];

    it("native", function () {
        return arr1.reduce(@(r, v) r + v);
    });

    it("foreach", function () {
        local r = 0;
        foreach (v in arr1) r += v;
        return r;
    });

});