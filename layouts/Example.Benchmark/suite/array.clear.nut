describe("Array Clear", function() {
    local arr1 = [1,2,3,4,5,6,7,8,9,0];

    it("native", function() {
        local arr = clone arr1;
        arr.clear();
        return arr;
    });

    it("assign", function() {
        local arr = clone arr1;
        arr = [];
        return arr;
    });

    it("resize", function() {
        local arr = clone arr1;
        arr.resize(0);
        return arr;
    });

    it("remove", function() {
        local arr = clone arr1;
        while (arr.len()) arr.remove(0);
        return arr;
    });

});