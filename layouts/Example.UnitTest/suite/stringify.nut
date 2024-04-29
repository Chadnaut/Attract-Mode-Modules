::fe.load_module("stringify");

class StringifyTestClass {
    function _tostring() { return "StringifyTestClass" }
}

describe("Stringify", function() {
    local arr1 = [4,2,5,1,3];

    it("should function", function() {
        expect(stringify(function(a, b, c){})).toEqual("function(a, b, c)");
    });

    it("should table", function() {
        expect(stringify({ a = 1, b = 2 })).toEqual("{ a = 1, b = 2 }");
    });

    it("should array", function() {
        expect(stringify([1, 2, 3])).toEqual("[1, 2, 3]");
    });

    it("should string", function() {
        expect(stringify("text")).toEqual(@"""text""");
    });

    it("should string verbatim", function() {
        expect(stringify(@"te""xt")).toEqual(@"@""te""""xt""");
    });

    it("should float", function() {
        expect(stringify(1.0)).toEqual("1.0");
    });

    it("should integer", function() {
        expect(stringify(123)).toEqual("123");
    });

    it("should null", function() {
        expect(stringify(null)).toEqual("null");
    });

    it("should bool", function() {
        expect(stringify(true)).toEqual("true");
        expect(stringify(false)).toEqual("false");
    });

    it("should class", function() {
        expect(stringify(StringifyTestClass)).toMatch(@"\(class : [a-z0-9]+\)");
    });

    it("should instance", function() {
        expect(stringify(StringifyTestClass())).toEqual("StringifyTestClass");
    });

    it("should other", function() {
        expect(stringify(::fe.overlay)).toMatch(@"<[A-Za-z0-9_]+>")
    });

});