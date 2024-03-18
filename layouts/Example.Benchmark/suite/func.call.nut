class FuncCallClass {
    value = 123;
    function get_value() { return value; }
}

describe("Func Call", function() {

    local obj = FuncCallClass();
    local call_arr = [obj, "get_value"];
    local call_bound = obj.get_value.bindenv(obj);

    it("array", function () {
        return call_arr[0][call_arr[1]]();
    });

    it("bound", function () {
        return call_bound();
    });

    it("instance", function () {
        return obj.get_value();
    });

    it("acall", function () {
        return obj.get_value.acall([obj]);
    });

});