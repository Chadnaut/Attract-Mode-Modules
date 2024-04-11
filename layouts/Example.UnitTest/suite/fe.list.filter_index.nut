describe("Frontend List Filter Index", function() {
    it("should have at least four filters to test", function() {
        expect(fe.filters.len()).toBeGreaterThanOrEqual(4);
    });

    it("should set index instantly", function() {
        fe.list.filter_index = 0;
        expect(fe.list.filter_index).toBe(0);
        fe.list.filter_index = 1;
        expect(fe.list.filter_index).toBe(1);
    });

    it("should signal next_filter without changing filter_index", function() {
        fe.list.filter_index = 0;
        expect(fe.list.filter_index).toBe(0);
        fe.signal("next_filter");
        expect(fe.list.filter_index).toBe(0);
        wait();
    });
    it("should update filter_index the frame after next_filter", function() {
        expect(fe.list.filter_index).toBe(1);
    });

    it("should signal prev_filter without changing filter_index", function() {
        fe.list.filter_index = 1;
        expect(fe.list.filter_index).toBe(1);
        fe.signal("prev_filter");
        expect(fe.list.filter_index).toBe(1);
        wait();
    });
    it("should update filter_index the frame after prev_filter", function() {
        expect(fe.list.filter_index).toBe(0);
    });

    it("should wrap filter_index to start", function() {
        local size = fe.filters.len();
        fe.list.filter_index = size - 1;
        expect(fe.list.filter_index).toBe(size - 1);
        fe.list.filter_index++;
        expect(fe.list.filter_index).toBe(0);
    });

    it("should wrap filter_index to end", function() {
        local size = fe.filters.len();
        fe.list.filter_index = 0;
        expect(fe.list.filter_index).toBe(0);
        fe.list.filter_index--;
        expect(fe.list.filter_index).toBe(size - 1);
    });

    it("shouldn't jump filter_index after start (just wraps)", function() {
        local size = fe.filters.len();
        local jump = 3;
        fe.list.filter_index = size - 1;
        expect(fe.list.filter_index).toBe(size - 1);
        fe.list.filter_index += jump;
        // expect(fe.list.filter_index).toBe(jump - 1); // Should be this
        expect(fe.list.filter_index).toBe(0);
    });

    it("shouldn't jump filter_index before end (just wraps)", function() {
        local size = fe.filters.len();
        local jump = 3;
        fe.list.filter_index = 0;
        expect(fe.list.filter_index).toBe(0);
        fe.list.filter_index -= jump;
        // expect(fe.list.filter_index).toBe(size - jump); // Should be this
        expect(fe.list.filter_index).toBe(size - 1);
    });
});