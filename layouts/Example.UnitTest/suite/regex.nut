::fe.load_module("regex");

describe("Regex", function() {
    it("should create", function() {
        expect(("Regex" in getroottable())).toBeTrue();
        expect(Regex().tostring()).toBe("Regex");
    });

    it("should test", function() {
        expect(Regex("Cat").test("[A-Z][a-z]+")).toBeTrue();
        expect(Regex("Cat").test("[0-9][a-z]+")).toBeFalse();
    });

    it("should search", function() {
        expect(Regex("Cat").search("[A-Z]")).toBe(0);
        expect(Regex("Cat").search("[a-z]")).toBe(1);
        expect(Regex("Cat").search("[0-9]")).toBe(-1);
    });

    it("should match", function() {
        expect(Regex("Cat").match("([A-Z])([a-z]+)")).toEqual(["Cat"]);
        expect(Regex("Cat").match("([0-9])([a-z]+)")).toBeNull();
    });

    it("should match spaces", function() {
        expect(Regex("Cat    Dog").match(@"([A-Z][a-z]+)\s*([A-Z][a-z]+)")).toEqual(["Cat    Dog"]);
    });

    it("should match_all", function() {
        expect(Regex("Cat Dog").match_all("([A-Z])([a-z]+)")).toEqual([["Cat", "C", "at"], ["Dog", "D", "og"]]);
    });

    it("should match_all spaces", function() {
        // doesn't work as the ([^$]*) is greedier than ( +)
        expect(Regex("Cat   Dog").match_all(@"([^ ]+)(?: +)([^$]*)$")).not().toEqual([["Cat   Dog", "Cat", "Dog"]]);
        // by adding [^ ] this will work
        expect(Regex("Cat   Dog").match_all(@"([^ ]+)(?: +)([^ ][^$]*)$")).toEqual([["Cat   Dog", "Cat", "Dog"]]);
    });

    it("should replace", function() {
        expect(Regex("Cat Dog").replace("([A-Z][a-z]+)", "[$1]")).toBe("[Cat] Dog");
    });

    it("should replace spaces", function() {
        expect(Regex("Cat    Dog").replace(" +", "")).toBe("CatDog");
    });

    it("should replace_all", function() {
        expect(Regex("Cat Dog").replace_all("([A-Z][a-z]+)", "[$1]")).toBe("[Cat] [Dog]");
    });
});