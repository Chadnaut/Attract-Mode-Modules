describe("Array Filter", function() {
    local arr1 = [1,2,3,4,5,6,7,8,9,0];

    it("native", function () {
        local arr = clone arr1;
        return arr.filter(@(i, value) value > 5);
    });

    it("push", function () {
        local arr = clone arr1;
        local result = [];
        foreach (value in arr) if (value > 5) result.push(value);
        return result;
    });

    it("remove", function () {
        local arr = clone arr1;
        for (local i=arr.len()-1; i>=0; i--) if (!(arr[i] > 5)) arr.remove(i);
        return arr;
    });

});