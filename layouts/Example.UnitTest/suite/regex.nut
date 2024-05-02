::fe.load_module("regex");

describe("Regex", function() {
    it("should create", function() {
        expect(("Regex" in getroottable())).toBeTrue();
        expect(Regex().tostring()).toBe("Regex");
    });

    it("should test", function() {
        expect(Regex("[A-Z][a-z]+").test("Cat")).toBeTrue();
        expect(Regex("[0-9][a-z]+").test("Cat")).toBeFalse();
    });

    it("should search", function() {
        expect(Regex("[A-Z]").search("Cat")).toBe(0);
        expect(Regex("[a-z]").search("Cat")).toBe(1);
        expect(Regex("[0-9]").search("Cat")).toBe(-1);
    });

    it("should match", function() {
        expect(Regex("([A-Z])([a-z]+)").match("Cat")).toEqual(["Cat"]);
        expect(Regex("([0-9])([a-z]+)").match("Cat")).toBeNull();
    });

    it("should match spaces", function() {
        expect(Regex(@"([A-Z][a-z]+)\s*([A-Z][a-z]+)").match("Cat    Dog")).toEqual(["Cat    Dog"]);
    });

    it("should match_all", function() {
        expect(Regex("([A-Z])([a-z]+)").match_all("Cat Dog")).toEqual([["Cat", "C", "at"], ["Dog", "D", "og"]]);
    });

    it("should match_all spaces", function() {
        // doesn't work as the ([^$]*) is greedier than ( +)
        expect(Regex(@"([^ ]+)(?: +)([^$]*)$").match_all("Cat   Dog")).not().toEqual([["Cat   Dog", "Cat", "Dog"]]);
        // by adding [^ ] this will work
        expect(Regex(@"([^ ]+)(?: +)([^ ][^$]*)$").match_all("Cat   Dog")).toEqual([["Cat   Dog", "Cat", "Dog"]]);
    });

    it("should replace", function() {
        expect(Regex("([A-Z][a-z]+)").replace("Cat Dog", "[$1]")).toBe("[Cat] Dog");
    });

    it("should replace spaces", function() {
        expect(Regex(" +").replace("Cat    Dog", "")).toBe("CatDog");
    });

    it("should replace_all", function() {
        expect(Regex("([A-Z][a-z]+)").replace_all("Cat Dog", "[$1]")).toBe("[Cat] [Dog]");
    });
});