describe("Array Extend", function() {
    local arr1 = [1,2,3,4,5,6,7,8,9,0];
    local arr2 = [1,2,3,4,5,6,7,8,9,0];

    it("native", function () {
        local arr = clone arr1;
        arr.extend(arr2);
        return arr;
    });

    it("push", function () {
        local arr = clone arr1;
        foreach (value in arr2) arr.push(value);
        return arr;
    });

});