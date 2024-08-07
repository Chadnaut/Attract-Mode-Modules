::fe.load_module("logplus");

local tlist = [];
::fe.add_transition_callback("_fe_display_transition_callback");
function _fe_display_transition_callback(ttype, var, ttime) {
    tlist.push({ ttype = ttype, var = var });
}

describe("Frontend Display Transition", function() {
    it("should have at least four displays to test", function() {
        expect(::fe.displays.len()).toBeGreaterThanOrEqual(4);
    });

    before("should next_display", function() {
        tlist.clear();
        ::fe.signal("next_display");
        wait();
    });
    it("should next_display ToNewList", function() {
        expect(tlist).toHaveLength(1);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewList, var = 0 });
    });

    before("should prev_display", function() {
        tlist.clear();
        ::fe.signal("prev_display");
        wait();
    });
    it("should prev_display ToNewList", function() {
        expect(tlist).toHaveLength(1);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewList, var = 0 });
    });

    before("should set_display", function() {
        tlist.clear();
        ::fe.set_display(::fe.list.display_index + 1, false, false);
        wait();
    });
    it("should set_display ToNewList", function() {
        expect(tlist).toHaveLength(1);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewList, var = 0 });
    });
});
