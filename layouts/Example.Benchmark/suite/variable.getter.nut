class MyVariableGetterClass {
    prop = 123;
    static static_prop = 123;
    function get_prop() { return prop; }
    static function get_static_prop() { return static_prop; }
    function _get(idx) { if (idx == "meta_prop") return 123; throw null; }
}

describe("Variable Getter", function() {

    local obj = MyVariableGetterClass();
    local var = 123;
    local func = function() { return 123; }
    local lambda = @() 123;

    ::myVariableGetterVar <- 123;
    ::myVariableGetterFunc <- function() { return 123; }
    ::myVariableGetterLambda <- @() 123;

    it("local var", function () {
        return var;
    });

    it("local func", function () {
        return func();
    });

    it("local lambda", function () {
        return lambda();
    });

    it("root var", function () {
        return ::myVariableGetterVar;
    });

    it("root func", function () {
        return ::myVariableGetterFunc();
    });

    it("root lambda", function () {
        return ::myVariableGetterLambda();
    });

    it("instance prop", function () {
        return obj.prop;
    });

    it("instance getter", function () {
        return obj.get_prop();
    });

    it("instance meta", function () {
        return obj.meta_prop;
    });

    it("class prop", function () {
        return MyVariableGetterClass.static_prop;
    });

    it("class getter", function () {
        return MyVariableGetterClass.get_static_prop();
    });

});