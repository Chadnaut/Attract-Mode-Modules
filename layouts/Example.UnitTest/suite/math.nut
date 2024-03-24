describe("Math", function() {

    // =====================================================
    // These should be in a module, but are here as examples

    // positive modulo
    local modulo = @(v, m) m ? (v % m + m) % m : 0;

    // random number (inclusive) returns same type as args (int/float)
    local random = @(min, max) min + rand() * (max - min) / RAND_MAX;

    // =====================================================

    it("should modulus (positive)", function() {
        expect(modulo(0, 0)).toBe(0);
        expect(modulo(0, 1)).toBe(0);
        expect(modulo(1, 1)).toBe(0);
        expect(modulo(10, 2)).toBe(0);
        expect(modulo(11, 2)).toBe(1);
        expect(modulo(11, 3)).toBe(2);
        expect(modulo(-10, 2)).toBe(0);
        expect(modulo(-11, 2)).toBe(1); // <-- fixed!
        expect(modulo(-11, 3)).toBe(1); // <-- fixed!
    });

    it("should random float", function() {
        srand(0);
        local n = RAND_MAX * 10;
        local min = 0.0;
        local max = 100.0;

        local min_r = null;
        local max_r = null;
        local r;
        for (local i=0; i<n; i++) {
            r = random(min, max);
            if (min_r == null || r < min_r) min_r = r;
            if (max_r == null || r > max_r) max_r = r;
            if (min_r == min && max_r == max) break;
        }
        expect(min_r).toBeInstanceOf(typeof min);
        expect(min_r).toEqual(min);
        expect(max_r).toBeInstanceOf(typeof max);
        expect(max_r).toEqual(max);
    });

    it("should random int", function() {
        srand(0);
        local n = RAND_MAX * 10;
        local min = 0;
        local max = 100;

        local min_r = null;
        local max_r = null;
        local r;
        for (local i=0; i<n; i++) {
            r = random(min, max);
            if (min_r == null || r < min_r) min_r = r;
            if (max_r == null || r > max_r) max_r = r;
            if (min_r == min && max_r == max) break;
        }
        expect(min_r).toBeInstanceOf(typeof min);
        expect(min_r).toEqual(min);
        expect(max_r).toBeInstanceOf(typeof max);
        expect(max_r).toEqual(max);
    });
});