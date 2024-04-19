describe("String Format", function() {

    it("Native", function () {
        return format("%s;%s;%s;%s;%s;%s;%s;%s;%s;%s", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0");
    });

    it("Add", function () {
        return "1" + ";" + "2" + ";" + "3" + ";" + "4" + ";" + "5" + ";" + "6" + ";" + "7" + ";" + "8" + ";" + "9" + ";" + "0";
    });

});