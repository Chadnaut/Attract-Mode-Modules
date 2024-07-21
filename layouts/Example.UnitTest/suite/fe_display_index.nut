describe("Frontend Display Index", function() {
    it("should have at least four displays to test", function() {
        expect(::fe.displays.len()).toBeGreaterThanOrEqual(4);
    });

    it("should set index instantly", function() {
        ::fe.set_display(0, false, false);
        expect(::fe.list.display_index).toBe(0);
        ::fe.set_display(1, false, false);
        expect(::fe.list.display_index).toBe(1);
    });

    it("should signal next_display without changing display_index", function() {
        ::fe.set_display(0, false, false);
        expect(::fe.list.display_index).toBe(0);
        ::fe.signal("next_display");
        expect(::fe.list.display_index).toBe(0);
        wait();
    });
    it("should update display_index the frame after next_display", function() {
        expect(::fe.list.display_index).toBe(1);
    });

    it("should signal prev_display without changing display_index", function() {
        ::fe.set_display(1, false, false);
        expect(::fe.list.display_index).toBe(1);
        ::fe.signal("prev_display");
        expect(::fe.list.display_index).toBe(1);
        wait();
    });
    it("should update display_index the frame after prev_display", function() {
        expect(::fe.list.display_index).toBe(0);
    });

    it("shouldn't wrap display_index to start (clamp instead)", function() {
        local size = ::fe.displays.len();
        ::fe.set_display(size - 1, false, false);
        expect(::fe.list.display_index).toBe(size - 1);
        ::fe.set_display(::fe.list.display_index + 1, false, false);
        // expect(::fe.list.display_index).toBe(0); // Should be this
        expect(::fe.list.display_index).toBe(size - 1);
    });

    it("shouldn't wrap display_index to end (clamp instead)", function() {
        local size = ::fe.displays.len();
        ::fe.set_display(0, false, false);
        expect(::fe.list.display_index).toBe(0);
        ::fe.set_display(-1, false, false);
        // expect(::fe.list.display_index).toBe(size - 1); // Should be this
        expect(::fe.list.display_index).toBe(0);
    });

    it("shouldn't jump display_index after start (clamp instead)", function() {
        local size = ::fe.displays.len();
        local jump = 3;
        ::fe.set_display(size - 1, false, false);
        expect(::fe.list.display_index).toBe(size - 1);
        ::fe.set_display(::fe.list.display_index + jump, false, false);
        // expect(::fe.list.display_index).toBe(jump - 1); // Should be this
        expect(::fe.list.display_index).toBe(size - 1);
    });

    it("shouldn't jump display_index before end (clamp instead)", function() {
        local size = ::fe.displays.len();
        local jump = 3;
        ::fe.set_display(0, false, false);
        expect(::fe.list.display_index).toBe(0);
        ::fe.set_display(::fe.list.display_index - jump, false, false);
        // expect(::fe.list.display_index).toBe(size - jump); // Should be this
        expect(::fe.list.display_index).toBe(0);
    });
});