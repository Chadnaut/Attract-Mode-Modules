::fe.load_module("regex");

describe("String Strip", function() {

    local str = "   value   ";
    local space = ' ';

    it("native", function () {
        return strip(str);
    });

    it("slice", function () {
        local n = str.len();
        local s = 0;
        local e = n - 1;
        while ((s < n) && (str[s] == space)) { s++; };
        while ((e > -1) && (str[e] == space)) { e--; };
        return str.slice(s, e+1);
    });

});