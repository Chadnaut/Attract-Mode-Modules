describe("String Split", function() {

    local str = "1;2;3;4;5;6;7;8;9;0";
    local delim = ";";

    it("native", function () {
        return split(str, delim);
    });

    it("char", function () {
        local a = [];
        local item = "";
        local d = delim[0];
        foreach (c in str) {
            if (c == d) {
                a.push(item);
                item = "";
            } else {
                item += c.tochar();
            }
        }
        if (item != "") a.push(item);
        return a;
    });

    it("find", function () {
        local i1 = 0;
        local i2 = 0;
        local n = delim.len();
        local a = [];
        while ((i2 = str.find(delim, i1)) != null) {
            a.push(str.slice(i1, i2));
            i1 = i2 + n;
        }
        if (i1 < str.len()) a.push(str.slice(i1));
        return a;
    });

});