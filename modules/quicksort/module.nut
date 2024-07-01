// Quicksort
//
// > Yielding Quicksort
// > Version 0.1.1
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

const MAX_LEVELS = 64;
local max_arr = array(MAX_LEVELS);
local compare_func = @(a, b) a <=> b;

::quicksort <- function(arr, comp = null) {
    local res;
    local gen = ::quicksort_generator(arr, comp);
    while (gen.getstatus() != "dead") res = resume gen;
    return res;
}

::quicksort_generator <- function(arr, comp = null) {
    local beg = clone max_arr;
    local end = clone max_arr;
    local piv, l, r, i = 0;
    if (!comp) comp = compare_func;

    beg[0] = 0;
    end[0] = arr.len();
    while (i >= 0) {
        l = beg[i];
        r = end[i];
        if (l + 1 < r--) {
            piv = arr[l];
            if (i == MAX_LEVELS - 1) return false;
            while (l < r) {
                while (comp(arr[r], piv) > 0 && l < r) r--;
                if (l < r) arr[l++] = arr[r];
                while (comp(piv, arr[l]) > 0 && l < r) l++;
                if (l < r) arr[r--] = arr[l];
            }
            arr[l] = piv;
            if (l - beg[i] > end[i] - r) {
                beg[i + 1] = l + 1;
                end[i + 1] = end[i];
                end[i++] = l;
            } else {
                beg[i + 1] = beg[i];
                end[i + 1] = l;
                beg[i++] = l + 1;
            }
        } else {
            i--;
        }
        yield;
    }
    return true;
}
