::fe.load_module("regex");

describe("String Escape", function() {

    local str = @"escape""quotes""in""string";

    it("find", function () {
        local i = 0;
        local value = str;
        while ((i = value.find(@"""", i)) != null) {
            value = value.slice(0, i) + "\\" + value.slice(i);
            i += 2;
        }
        return value;
    });

    it("char", function () {
        local value = "";
        foreach (code in str) {
            if (code == '"') value += "\\";
            value += code.tochar();
        }
        return value;
    });

});