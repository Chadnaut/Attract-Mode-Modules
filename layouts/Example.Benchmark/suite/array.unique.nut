describe("Array Unique", function() {
    local arr1 = [1,1,2,2,3,3,4,4,5,5,4,4,3,3,2,2,1,1];

    it("find", function () {
        local result = [];
        foreach (value in arr1) if (result.find(value) == null) result.push(value);
        return result;
    });

    it("filter", function () {
        return arr1.filter(@(i, v) arr1.find(v) == i);
    });

    // assumes value can be made into a key
    it("key", function () {
        local obj = {};
        local result = [];
        foreach (value in arr1) obj[value] <- true;
        foreach (key, value in obj) result.push(key);
        return result;
    });

});