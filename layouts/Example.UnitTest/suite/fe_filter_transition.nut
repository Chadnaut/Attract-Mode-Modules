local tlist = [];
::fe.add_transition_callback("_fe_filter_transition_callback");
function _fe_filter_transition_callback(ttype, var, ttime) {
    tlist.push({ ttype = ttype, var = var });
}

describe("Frontend Filter Transition", function() {
    it("should have at least four filters to test", function() {
        expect(fe.filters.len()).toBeGreaterThanOrEqual(4);
    });

    before("should next_filter", function() {
        tlist.clear();
        fe.signal("next_filter");
        wait();
    });
    it("should next_filter ToNewList", function() {
        expect(tlist).toHaveLength(1);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewList, var = 1 });
    });

    before("should prev_filter", function() {
        tlist.clear();
        fe.signal("prev_filter");
        wait();
    });
    it("should prev_filter ToNewList", function() {
        expect(tlist).toHaveLength(1);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewList, var = -1 });
    });

    before("should set filter_index", function() {
        tlist.clear();
        fe.list.filter_index++;
        wait();
    });
    it("should set filter_index ToNewList", function() {
        expect(tlist).toHaveLength(1);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewList, var = 1 });
    });
});
