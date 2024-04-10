local tlist = [];
::fe.add_transition_callback("_fe_transition_callback");
function _fe_transition_callback(ttype, var, ttime) {
    tlist.push({ ttype = ttype, var = var });
}

describe("Frontend Transition", function() {
    it("should have >= 4 items & filters to test", function() {
        expect(fe.list.size).toBeGreaterThanOrEqual(4);
        expect(fe.filters.len()).toBeGreaterThanOrEqual(4);
    });

    it("should init StartLayout > ToNewList", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0]).toEqual({ ttype = Transition.StartLayout, var = 0 });
        expect(tlist[1]).toEqual({ ttype = Transition.ToNewList, var = 0 });
    });

    it("should next_game", function() {
        tlist.clear();
        fe.signal("next_game");
        wait();
    });
    it("should next_game ToNewSelection > FromOldSelection", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewSelection, var = 1 });
        expect(tlist[1]).toEqual({ ttype = Transition.FromOldSelection, var = -1 });
    });

    it("should prev_game", function() {
        tlist.clear();
        fe.signal("prev_game");
        wait();
    });
    it("should prev_game ToNewSelection > FromOldSelection", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewSelection, var = -1 });
        expect(tlist[1]).toEqual({ ttype = Transition.FromOldSelection, var = 1 });
    });

    it("should fe.list.index", function() {
        tlist.clear();
        fe.list.index++;
        wait();
    });
    it("should fe.list.index ToNewSelection > FromOldSelection > EndNavigation", function() {
        expect(tlist).toHaveLength(3);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewSelection, var = 1 });
        expect(tlist[1]).toEqual({ ttype = Transition.FromOldSelection, var = -1 });
        expect(tlist[2]).toEqual({ ttype = Transition.EndNavigation, var = 0 });
    });

    it("should next_page", function() {
        tlist.clear();
        fe.layout.page_size = 10;
        fe.signal("next_page");
        wait();
    });
    it("should next_page ToNewSelection > FromOldSelection", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewSelection, var = 10 });
        expect(tlist[1]).toEqual({ ttype = Transition.FromOldSelection, var = -10 });
    });

    it("should prev_page", function() {
        tlist.clear();
        fe.layout.page_size = 10;
        fe.signal("prev_page");
        wait();
    });
    it("should prev_page ToNewSelection > FromOldSelection", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewSelection, var = -10 });
        expect(tlist[1]).toEqual({ ttype = Transition.FromOldSelection, var = 10 });
    });

    it("should next_filter", function() {
        tlist.clear();
        fe.signal("next_filter");
        wait();
    });
    it("should next_filter ToNewList", function() {
        expect(tlist).toHaveLength(1);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewList, var = 1 });
    });

    it("should prev_filter", function() {
        tlist.clear();
        fe.signal("prev_filter");
        wait();
    });
    it("should prev_filter ToNewList", function() {
        expect(tlist).toHaveLength(1);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewList, var = -1 });
    });

    it("should fe.list.filter_index", function() {
        tlist.clear();
        fe.list.filter_index++;
        wait();
    });
    it("should fe.list.filter_index ToNewList", function() {
        expect(tlist).toHaveLength(1);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewList, var = 1 });
    });

    it("should random_game", function() {
        tlist.clear();
        fe.signal("random_game");
        wait();
    });
    it("should random_game ToNewSelection > FromOldSelection > EndNavigation", function() {
        expect(tlist).toHaveLength(3);
        expect(tlist[0].ttype).toBe(Transition.ToNewSelection);
        expect(tlist[1].ttype).toBe(Transition.FromOldSelection);
        expect(tlist[2]).toEqual({ ttype = Transition.EndNavigation, var = 0 });
    });

    it("should add_favourite", function() {
        tlist.clear();
        fe.signal("add_favourite");
        wait();
    });
    it("should add_favourite ToNewList > ChangedTag", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0]).toEqual({ ttype = Transition.ToNewList, var = 0 });
        expect(tlist[1]).toEqual({ ttype = Transition.ChangedTag, var = 21 });
    });

    it("should next_favourite", function() {
        tlist.clear();
        fe.signal("next_favourite");
        wait();
    });
    it("should next_favourite ToNewSelection > FromOldSelection", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0].ttype).toBe(Transition.ToNewSelection);
        expect(tlist[1].ttype).toBe(Transition.FromOldSelection);
    });

    it("should prev_favourite", function() {
        tlist.clear();
        fe.signal("prev_favourite");
        wait();
    });
    it("should prev_favourite ToNewSelection > FromOldSelection", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0].ttype).toBe(Transition.ToNewSelection);
        expect(tlist[1].ttype).toBe(Transition.FromOldSelection);
    });

    it("should next_letter", function() {
        tlist.clear();
        fe.signal("next_letter");
        wait();
    });
    it("should next_letter ToNewSelection > FromOldSelection", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0].ttype).toBe(Transition.ToNewSelection);
        expect(tlist[1].ttype).toBe(Transition.FromOldSelection);
    });

    it("should prev_letter", function() {
        tlist.clear();
        fe.signal("prev_letter");
        wait();
    });
    it("should prev_letter ToNewSelection > FromOldSelection", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0].ttype).toBe(Transition.ToNewSelection);
        expect(tlist[1].ttype).toBe(Transition.FromOldSelection);
    });
});
