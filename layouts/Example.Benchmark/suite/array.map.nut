describe("Array Map", function() {
    local arr1 = [1,2,3,4,5,6,7,8,9,0];

    it("native", function () {
        return arr1.map(@(value) value * 2);
    });

    it("foreach", function () {
        local arr = [];
        foreach (value in arr1) arr.push(value * 2);
        return arr;
    });

    it("clone", function () {
        local arr = clone arr1;
        foreach (i, value in arr1) arr[i] = value * 2;
        return arr;
    });

});