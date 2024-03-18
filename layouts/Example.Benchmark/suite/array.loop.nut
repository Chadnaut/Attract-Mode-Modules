describe("Array vs Object Loop", function() {
    local arr1 = [1,2,3,4,5,6,7,8,9,0];
    local obj1 = {a=1,b=2,c=3,d=4,e=5,f=6,g=7,h=8,i=9,j=0};

    it("for", function () {
        local t = 0;
        for (local i=0, n=arr1.len(); i<n; i++) {
            t += arr1[i];
        }
        return t;
    });

    it("foreach", function () {
        local t = 0;
        foreach (i, v in arr1) {
            t += v;
        }
        return t;
    });

    it("object", function () {
        local t = 0;
        foreach (k, v in obj1) {
            t += v;
        }
        return t;
    });

});