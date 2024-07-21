local tlist = [];
::fe.add_transition_callback("_fe_overlay_transition_callback");
function _fe_overlay_transition_callback(ttype, var, ttime) {
    tlist.push({ ttype = ttype, var = var });
}

function keypress(key) {
    ::fe.plugin_command_bg("python", format("%s %s Attract-Mode SFML_Window", FeConfigDirectory + "scripts/keypress/keypress.py", key));
}

describe("Frontend Overlay Transition", function() {

    before("should overlay show", function() {
        tlist.clear();
        ::fe.signal("filters_menu");
        wait(10);
    });
    before("should overlay exit", function() {
        keypress("VK_ESCAPE");
        wait(10);
    });
    it("should overlay ShowOverlay > HideOverlay", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0].ttype).toBe(Transition.ShowOverlay);
        expect(tlist[1].ttype).toBe(Transition.HideOverlay);
    });

    before("should overlay-select", function() {
        tlist.clear();
        ::fe.signal("filters_menu");
        wait(10);
    });
    before("should overlay-select move", function() {
        keypress("VK_DOWN");
        wait(10);
    });
    before("should overlay-select exit", function() {
        keypress("VK_ESCAPE");
        wait(10);
    });
    it("should overlay-select ShowOverlay > NewSelOverlay > HideOverlay", function() {
        expect(tlist).toHaveLength(3);
        expect(tlist[0].ttype).toBe(Transition.ShowOverlay);
        expect(tlist[1].ttype).toBe(Transition.NewSelOverlay);
        expect(tlist[2].ttype).toBe(Transition.HideOverlay);
    });

    before("should add_tags show", function() {
        tlist.clear();
        ::fe.signal("add_tags");
        wait(10);
    });
    before("should add_tags exit", function() {
        keypress("VK_ESCAPE");
        wait(10);
    });
    it("should add_tags ShowOverlay > HideOverlay", function() {
        expect(tlist).toHaveLength(2);
        expect(tlist[0].ttype).toBe(Transition.ShowOverlay);
        expect(tlist[1].ttype).toBe(Transition.HideOverlay);
    });

    before("should configure show", function() {
        tlist.clear();
        ::fe.signal("configure");
        wait(10);
    });
    before("should configure exit", function() {
        keypress("VK_ESCAPE");
        wait(10);
    });
    it("should configure zero transitions", function() {
        expect(tlist).toHaveLength(0);
    });

});
