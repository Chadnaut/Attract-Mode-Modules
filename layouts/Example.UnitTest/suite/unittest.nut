class myClass {};
local myFunc = function() {};
local myLambda = @() null;

describe("UnitTest", function() {
    it("should run toBeTrue", function() {
        expect(true).toBeTrue();
        expect(false).not().toBeTrue();
        expect(1).not().toBeTrue();
        expect(0).not().toBeTrue();
        expect(1.0).not().toBeTrue();
        expect(0.0).not().toBeTrue();
        expect("").not().toBeTrue();
        expect("a").not().toBeTrue();
        expect({a=1}).not().toBeTrue();
        expect({}).not().toBeTrue();
        expect([1]).not().toBeTrue();
        expect([]).not().toBeTrue();
        expect(null).not().toBeTrue();
        expect(myClass()).not().toBeTrue();
        expect(myFunc).not().toBeTrue();
        expect(myLambda).not().toBeTrue();
    });

    it("should run toBeFalse", function() {
        expect(true).not().toBeFalse();
        expect(false).toBeFalse();
        expect(1).not().toBeFalse();
        expect(0).not().toBeFalse();
        expect(1.0).not().toBeFalse();
        expect(0.0).not().toBeFalse();
        expect("a").not().toBeFalse();
        expect("").not().toBeFalse();
        expect({a=1}).not().toBeFalse();
        expect({}).not().toBeFalse();
        expect([1]).not().toBeFalse();
        expect([]).not().toBeFalse();
        expect(null).not().toBeFalse();
        expect(myClass()).not().toBeFalse();
        expect(myFunc).not().toBeFalse();
        expect(myLambda).not().toBeFalse();
    });

    it("should run toBeTruthy", function() {
        expect(true).toBeTruthy();
        expect(false).not().toBeTruthy();
        expect(1).toBeTruthy();
        expect(0).not().toBeTruthy();
        expect(1.0).toBeTruthy();
        expect(0.0).not().toBeTruthy();
        expect("a").toBeTruthy();
        expect("").toBeTruthy();
        expect({a=1}).toBeTruthy();
        expect({}).toBeTruthy();
        expect([1]).toBeTruthy();
        expect([]).toBeTruthy();
        expect(null).not().toBeTruthy();
        expect(myClass()).toBeTruthy();
        expect(myFunc).toBeTruthy();
        expect(myLambda).toBeTruthy();
    });

    it("should run toBeFalsy", function() {
        expect(true).not().toBeFalsy();
        expect(false).toBeFalsy();
        expect(1).not().toBeFalsy();
        expect(0).toBeFalsy();
        expect(1.0).not().toBeFalsy();
        expect(0.0).toBeFalsy();
        expect("a").not().toBeFalsy();
        expect("").not().toBeFalsy();
        expect({a=1}).not().toBeFalsy();
        expect({}).not().toBeFalsy();
        expect([1]).not().toBeFalsy();
        expect([]).not().toBeFalsy();
        expect(null).toBeFalsy();
        expect(myClass()).not().toBeFalsy();
        expect(myFunc).not().toBeFalsy();
        expect(myLambda).not().toBeFalsy();
    });

    it("should run toBeNull", function() {
        expect(true).not().toBeNull();
        expect(false).not().toBeNull();
        expect(1).not().toBeNull();
        expect(0).not().toBeNull();
        expect(1.0).not().toBeNull();
        expect(0.0).not().toBeNull();
        expect("a").not().toBeNull();
        expect("").not().toBeNull();
        expect({a=1}).not().toBeNull();
        expect({}).not().toBeNull();
        expect([1]).not().toBeNull();
        expect([]).not().toBeNull();
        expect(null).toBeNull();
        expect(myClass()).not().toBeNull();
        expect(myFunc).not().toBeNull();
        expect(myLambda).not().toBeNull();
    });

    it("should run toBeInstanceOf", function() {
        expect(true).toBeInstanceOf("bool");
        expect(false).toBeInstanceOf("bool");
        expect(1).toBeInstanceOf("integer");
        expect(0).toBeInstanceOf("integer");
        expect(1.0).toBeInstanceOf("float");
        expect(0.0).toBeInstanceOf("float");
        expect("a").toBeInstanceOf("string");
        expect("").toBeInstanceOf("string");
        expect({a=1}).toBeInstanceOf("table");
        expect({}).toBeInstanceOf("table");
        expect([1]).toBeInstanceOf("array");
        expect([]).toBeInstanceOf("array");
        expect(null).toBeInstanceOf("null");
        expect(myClass()).toBeInstanceOf("instance");
        expect(myFunc).toBeInstanceOf("function");
        expect(myLambda).toBeInstanceOf("function");
    });

    it("should run toBeGreaterThan", function() {
        expect(1).toBeGreaterThan(0);
        expect(0).not().toBeGreaterThan(0);
        expect(-1).not().toBeGreaterThan(0);
        expect("a").not().toBeGreaterThan("b");
        expect("b").not().toBeGreaterThan("b");
        expect("c").toBeGreaterThan("b");
    });

    it("should run toBeGreaterThanOrEqual", function() {
        expect(1).toBeGreaterThanOrEqual(0);
        expect(0).toBeGreaterThanOrEqual(0);
        expect(-1).not().toBeGreaterThanOrEqual(0);
        expect("a").not().toBeGreaterThanOrEqual("b");
        expect("b").toBeGreaterThanOrEqual("b");
        expect("c").toBeGreaterThanOrEqual("b");
    });

    it("should run toBeLessThan", function() {
        expect(1).not().toBeLessThan(0);
        expect(0).not().toBeLessThan(0);
        expect(-1).toBeLessThan(0);
        expect("a").toBeLessThan("b");
        expect("b").not().toBeLessThan("b");
        expect("c").not().toBeLessThan("b");
    });

    it("should run toBeLessThanOrEqual", function() {
        expect(1).not().toBeLessThanOrEqual(0);
        expect(0).toBeLessThanOrEqual(0);
        expect(-1).toBeLessThanOrEqual(0);
        expect("a").toBeLessThanOrEqual("b");
        expect("b").toBeLessThanOrEqual("b");
        expect("c").not().toBeLessThanOrEqual("b");
    });

    it("should run toContain", function() {
        expect([1]).toContain(1);
        expect([0]).not().toContain(1);
        expect([]).not().toContain(1);
        expect(["a"]).toContain("a");
        expect([{a=1}]).not().toContain({a=1});
        local obj = {a=1};
        expect([obj]).toContain(obj);
    });

    it("should run toContainEqual", function() {
        expect([{a=1}]).toContainEqual({a=1});
    });

    it("should run toContainCloseTo", function() {
        expect([{a=0.1 + 0.2}]).toContainCloseTo({a=0.3});
    });

    it("should run toBe", function() {
        expect({a=1}).not().toBe({a=1});
        local obj = {a=1};
        expect(obj).toBe(obj);
    });

    it("should run toBeCloseTo", function() {
        expect(0.1 + 0.2).not().toEqual(0.3);
        expect(0.1 + 0.2).toBeCloseTo(0.3);
    });

    it("should run toEqual", function() {
        expect(1).toEqual(1);
        expect(1.0).toEqual(1.00);
        expect(1).not().toEqual(1.0);
        expect(1).not().toEqual(true);
        expect([0,1,2]).toEqual([0,1,2]);
        expect([0,1,2]).not().toEqual([2,1,0]);
        expect({a=1}).toEqual({a=1});
        expect({a=1,b=[{c=2.0}]}).toEqual({a=1,b=[{c=2.0}]});
        expect({a=1}).not().toEqual({a=1,b=1});
        expect({a=1,b=1}).toEqual({b=1,a=1});
    });

    it("should run toMatch", function() {
        expect("Hello").toMatch(@"^H.{4}$");
        expect("Goodbye").not().toMatch(@"^H.{4}$");
    });

    it("should run arrayContaining", function() {
        expect(["a", "b", "c"]).toEqual(arrayContaining(["a", "b"]));
    });
});