describe("Array Create", function() {

    it("native", function() {
        return array(100, "a");
    });

    it("push", function() {
        local arr = [];
        for (local i=0; i<100; i++) arr.push("a");
        return arr;
    });

    it("resize", function() {
        local arr = [];
        arr.resize(100, "a");
        return arr;
    });

});