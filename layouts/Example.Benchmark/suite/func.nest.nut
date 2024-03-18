describe("Func Nest", function() {

    local func1 = @(a, b, c, d) a + b + c + d;
    local func2 = @(a, b, c, d) func1(a, b, c, d);

    it("flat", function () {
        return func1(1, 2, 3, 4);
    });

    it("nest", function () {
        return func2(1, 2, 3, 4);
    });

});