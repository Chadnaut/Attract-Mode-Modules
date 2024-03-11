fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

// fe.load_module("logfile");
// ::console <- Logfile();
// ::console.log(this);


fe.load_module("unittest");


describe("Datatypes", function() {
    it("should run toBeTrue", function() {
        expect(true).toBeTrue();

        expect(false).not().toBeTrue();
        expect(1).not().toBeTrue();
        expect(0).not().toBeTrue();
        expect(1.0).not().toBeTrue();
        expect(0.0).not().toBeTrue();
        expect(null).not().toBeTrue();
        expect("").not().toBeTrue();
        expect("a").not().toBeTrue();
        expect({}).not().toBeTrue();
        expect({a=1}).not().toBeTrue();
        expect([]).not().toBeTrue();
        expect([1]).not().toBeTrue();
        // expect(myClass()).not().toBeTrue();
        expect(function() {}).not().toBeTrue();
    });

    it("should run1", function() {
        expect(true).toBeTrue();
    });

    it("should run2", function() {
        expect(true).toBeTrue();
    });

    it("should run3", function() {
        expect(true).toBeTrue();
    });

    it("should run4", function() {
        expect(true).toBeTrue();
    });
});

describe("More here1", function() {
    it("should run4", function() {
        expect(true).toBeTrue();
    });
});

describe("More here2", function() {
    it("should run4", function() {
        expect(true).toBeTrue();
    });
});

describe("More here3", function() {
    it("should run4", function() {
        expect(true).toBeTrue();
    });
});

describe("More here4", function() {
    it("should run4", function() {
        expect(false).toBeTrue();
    });
});

describe("More here5", function() {
    it("should run4", function() {
        expect(true).toBeTrue();
    });
});

fdescribe("Signal next_game", function() {
    it("should signal", function() {
        fe.list.index = 0
        expect(fe.list.index).toBe(0)
        fe.signal("next_game")
        // DevLog.time("signal", fe.list.index)
        wait()
    })

    it("should next_game", function() {
        // DevLog.time("next_game", fe.list.index)
        expect(fe.list.index).toBe(1)
        fe.signal("next_game")
        wait()
    })

    it("should next next_game", function() {
        // DevLog.time("next next_game", fe.list.index)
        expect(fe.list.index).toBe(2)
    })
})

UnitTest.test();
// UnitTest.benchmark(0);
