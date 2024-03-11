describe("Array Top", function() {
    local arr1 = [1,2,3,4,5,6,7,8,9,0];

    it("native", function () {
        return arr1.top();
    });

    it("len", function () {
        return arr1[arr1.len() - 1];
    });

    it("slice", function () {
        return arr1.slice(-1)[0];
    });

});