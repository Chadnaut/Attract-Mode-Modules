::fe.load_module("quicksort");

describe("Quicksort", function() {
    local arr1 = [4,2,5,1,3];

    it("should sort", function() {
        local arr2 = clone arr1;
        ::quicksort(arr2)
        expect(arr2).toEqual([1,2,3,4,5]);
    });

    it("should sort method", function() {
        local arr2 = clone arr1;
        ::quicksort(arr2, @(a,b) b <=> a)
        expect(arr2).toEqual([5,4,3,2,1]);
    });

    it("should sort generator", function() {
        local arr2 = clone arr1;
        local gen = ::quicksort_generator(arr2)
        while (gen.getstatus() != "dead") resume gen;
        expect(arr2).toEqual([1,2,3,4,5]);
    });

});