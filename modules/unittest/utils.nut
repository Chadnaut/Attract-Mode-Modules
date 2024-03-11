// True if arr contains item equal to val
::contains_equal <- function (arr, val) {
    foreach (v in arr) if (close_to(v, val, 0)) return true;
    return false;
}

// True if array contains item close_to val
::contains_close_to <- function (arr, val, delta = 0.0001) {
    foreach (v in arr) if (close_to(v, val, delta)) return true;
    return false;
}

// True if array contains subset
::array_contains <- function (arr, subset) {
    foreach (v in subset) if (arr.find(v) == null) return false;
    return true;
}

// True if string matches pattern
::regex_test <- function (str, pattern) {
    return !!regexp(pattern).capture(str);
}

// True if a within delta of b, used for float comparison
// - also deep-checks floats within arrays and tables
::close_to <- function (a, b, delta = 0) {
    if (typeof a != typeof b) return false;
    switch (typeof a) {
        case "array":
            if (a.len() != b.len()) return false;
            foreach (i, v in a) if (!close_to(v, b[i], delta)) return false;
            return true;
        case "table":
            if (a.len() != b.len()) return false;
            foreach (k, v in a) if (!(k in b) || !close_to(v, b[k], delta)) return false;
            return true;
        case "float":
            return (a + delta >= b) && (a - delta <= b);
        default:
            return a == b;
    }
}