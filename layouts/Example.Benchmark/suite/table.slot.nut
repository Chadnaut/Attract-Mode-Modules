describe("Table Slot", function() {

    local n = 100;

    it("create", function () {
        local obj = {};
        for (local i=0; i<n; i++) obj.x <- true;
    });

    it("check", function () {
        local obj = {};
        for (local i=0; i<n; i++) if (!("x" in obj)) obj.x <- true;
    });

});