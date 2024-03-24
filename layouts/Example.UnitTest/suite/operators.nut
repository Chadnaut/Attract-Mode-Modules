describe("Operators", function() {

    it("should not", function() {
        expect(!-1).toBeFalse();
        expect(!0).toBeTrue();
        expect(!1).toBeFalse();
    });

    it("should not equal", function() {
        expect(1 != 1).toBeFalse();
        expect(1 != 0).toBeTrue();
    });

    it("should or", function() {
        expect(false || false).toBeFalse();
        expect(true || false).toBeTrue();
        expect(false || true).toBeTrue();
        expect(true || true).toBeTrue();
    });

    it("should equal", function() {
        expect(1 == 1).toBeTrue();
        expect(1 == 0).toBeFalse();
    });

    it("should and", function() {
        expect(false && false).toBeFalse();
        expect(true && false).toBeFalse();
        expect(false && true).toBeFalse();
        expect(true && true).toBeTrue();
    });

    it("should greater than or equal", function() {
        expect(0 >= 0).toBeTrue();
        expect(1 >= 0).toBeTrue();
        expect(0 >= 1).toBeFalse();
    });

    it("should less than or equal", function() {
        expect(0 <= 0).toBeTrue();
        expect(1 <= 0).toBeFalse();
        expect(0 <= 1).toBeTrue();
    });

    it("should greater than", function() {
        expect(0 > 0).toBeFalse();
        expect(1 > 0).toBeTrue();
        expect(0 > 1).toBeFalse();
    });

    it("should less than", function() {
        expect(0 < 0).toBeFalse();
        expect(1 < 0).toBeFalse();
        expect(0 < 1).toBeTrue();
    });

    it("should three way compare", function() {
        expect(0 <=> 0).toBe(0);
        expect(1 <=> 0).toBe(1);
        expect(0 <=> 1).toBe(-1);
    });

    it("should add", function() {
        expect(0 + 0).toBe(0);
        expect(0 + 1).toBe(1);
    });

    it("should add assign", function() {
        local n = 0;
        expect(n+=1).toBe(1);
        expect(n+=1).toBe(2);
    });

    it("should subtract", function() {
        expect(0 - 0).toBe(0);
        expect(0 - 1).toBe(-1);
    });

    it("should subtract assign", function() {
        local n = 0;
        expect(n-=1).toBe(-1);
        expect(n-=1).toBe(-2);
    });

    it("should divide", function() {
        local e = null;
        try { 0 / 0 } catch (err) { e = err; }
        expect(e).not().toBeNull();
        expect(0 / 1).toBe(0);
        expect(1 / 1).toBe(1);
    });

    it("should divide assign", function() {
        local n = 1.0;
        expect(n/=2.0).toBe(0.5);
        expect(n/=2.0).toBe(0.25);
    });

    it("should multiply", function() {
        expect(0 * 0).toBe(0);
        expect(0 * -1).toBe(0);
        expect(1 * 1).toBe(1);
    });

    it("should multiply assign", function() {
        local n = 1;
        expect(n*=2).toBe(2);
        expect(n*=2).toBe(4);
    });

    it("should modulus (negative)", function() {
        expect(0 % 0).toBe(0);
        expect(0 % 1).toBe(0);
        expect(1 % 1).toBe(0);
        expect(10 % 2).toBe(0);
        expect(11 % 2).toBe(1);
        expect(11 % 3).toBe(2);
        expect(-10 % 2).toBe(0);
        expect(-11 % 2).toBe(-1);
        expect(-11 % 3).toBe(-2);
    });

    it("should modulus assign (negative)", function() {
        local n = 10;
        expect(n%=2).toBe(0);
        n = 11;
        expect(n%=2).toBe(1);
        n = -11;
        expect(n%=2).toBe(-1);
    });

    it("should increment", function() {
        local n = 0;
        expect(n++).toBe(0);
        expect(n).toBe(1);
        expect(++n).toBe(2);
    });

    it("should decrement", function() {
        local n = 0;
        expect(n--).toBe(0);
        expect(n).toBe(-1);
        expect(--n).toBe(-2);
    });

    it("should add slot", function() {
        local t = {};
        t.x <- 123;
        expect(t.x).toBe(123);
    });

    it("should assign", function() {
        local n;
        expect(n = 123).toBe(123);
    });

    it("should bitwise and", function() {
        expect(0x0001 & 0x0001).toBe(0x0001);
        expect(0x0001 & 0x1000).toBe(0x0000);
        expect(0x1000 & 0x0001).toBe(0x0000);
        expect(0x1000 & 0x1000).toBe(0x1000);
    });

    it("should bitwise xor", function() {
        expect(0x0001 ^ 0x0001).toBe(0x0000);
        expect(0x0001 ^ 0x1000).toBe(0x1001);
        expect(0x1000 ^ 0x0001).toBe(0x1001);
        expect(0x1000 ^ 0x1000).toBe(0x0000);
    });

    it("should bitwise or", function() {
        expect(0x0001 | 0x0001).toBe(0x0001);
        expect(0x0001 | 0x1000).toBe(0x1001);
        expect(0x1000 | 0x0001).toBe(0x1001);
        expect(0x1000 | 0x1000).toBe(0x1000);
    });

    it("should bitwise twos complement", function() {
        expect(~0x0000).toBe(-0x0001);
        expect(~0x0001).toBe(-0x0002);
        expect(~0x1000).toBe(-0x1001);
        expect(~0x1001).toBe(-0x1002);
    });

    it("should bitwise right shift", function() {
        expect(8 >> 1).toBe(4);
        expect(16 >> 1).toBe(8);
        expect(32 >> 1).toBe(16);
        expect(64 >> 1).toBe(32);
        expect(-64 >> 1).toBe(-32);
    });

    it("should bitwise left shift", function() {
        expect(8 << 1).toBe(16);
        expect(16 << 1).toBe(32);
        expect(32 << 1).toBe(64);
        expect(64 << 1).toBe(128);
        expect(-64 << 1).toBe(-128);
    });

    it("should bitwise logical right shift", function() {
        expect(8 >>> 1).toBe(4);
        expect(16 >>> 1).toBe(8);
        expect(32 >>> 1).toBe(16);
        expect(64 >>> 1).toBe(32);
        expect(-64 >>> 1).not().toBe(-32);
    });

});