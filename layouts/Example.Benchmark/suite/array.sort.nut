::fe.load_module("quicksort");

describe("Array Sort", function() {
    local arr1 = [4,7,2,5,9,6,0,3,1,8];
    local compare = @(a, b) a <=> b;

    it("native", function () {
        local arr2 = clone arr1;
        arr2.sort(compare);
        return arr2;
    });

    it("quicksort", function () {
        local arr2 = clone arr1;
        ::quicksort(arr2, compare);
        return arr2;
    });

});