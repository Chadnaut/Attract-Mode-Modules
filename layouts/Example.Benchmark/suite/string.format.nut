describe("String Format", function() {

    it("native", function () {
        return format("%s;%s;%s;%s;%s;%s;%s;%s;%s;%s", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0");
    });

    it("add", function () {
        return "1" + ";" + "2" + ";" + "3" + ";" + "4" + ";" + "5" + ";" + "6" + ";" + "7" + ";" + "8" + ";" + "9" + ";" + "0";
    });

});