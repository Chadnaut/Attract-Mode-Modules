describe("Frontend List Index", function() {
    it("should have at least four list items to test", function() {
        expect(::fe.list.size).toBeGreaterThanOrEqual(4);
    });

    it("should set index instantly", function() {
        ::fe.list.index = 0;
        expect(::fe.list.index).toBe(0);
        ::fe.list.index = 1;
        expect(::fe.list.index).toBe(1);
    });

    it("should signal next_game without changing index", function() {
        ::fe.list.index = 0;
        expect(::fe.list.index).toBe(0);
        ::fe.signal("next_game");
        expect(::fe.list.index).toBe(0);
        wait();
    });
    it("should update index the frame after next_game", function() {
        expect(::fe.list.index).toBe(1);
    });

    it("should signal prev_game without changing index", function() {
        ::fe.list.index = 1;
        expect(::fe.list.index).toBe(1);
        ::fe.signal("prev_game");
        expect(::fe.list.index).toBe(1);
        wait();
    });
    it("should update index the frame after prev_game", function() {
        expect(::fe.list.index).toBe(0);
    });

    it("should wrap index to start", function() {
        local size = ::fe.list.size;
        ::fe.list.index = size - 1;
        expect(::fe.list.index).toBe(size - 1);
        ::fe.list.index++;
        expect(::fe.list.index).toBe(0);
    });

    it("should wrap index to end", function() {
        local size = ::fe.list.size;
        ::fe.list.index = 0;
        expect(::fe.list.index).toBe(0);
        ::fe.list.index--;
        expect(::fe.list.index).toBe(size - 1);
    });

    it("should jump index after start", function() {
        local size = ::fe.list.size;
        local jump = 3;
        ::fe.list.index = size - 1;
        expect(::fe.list.index).toBe(size - 1);
        ::fe.list.index += jump;
        expect(::fe.list.index).toBe(jump - 1);
    });

    it("should jump index before end", function() {
        local size = ::fe.list.size;
        local jump = 3;
        ::fe.list.index = 0;
        expect(::fe.list.index).toBe(0);
        ::fe.list.index -= jump;
        expect(::fe.list.index).toBe(size - jump);
    });
});