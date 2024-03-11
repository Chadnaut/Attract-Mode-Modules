describe("Array Clone", function() {
    local arr1 = [1,2,3,4,5,6,7,8,9,0];

    it("native", function () {
        return clone arr1;
    });

    it("slice", function () {
        return arr1.slice(0);
    });

    it("push", function () {
        local arr = [];
        foreach (value in arr1) arr.push(value);
        return arr;
    });

    it("map", function () {
        return arr1.map(@(v) v);
    });

});