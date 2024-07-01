// Regex
//
// > Regular Expression handler
// > Version 0.2.1
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

// Replace search in value
local str_replace = function(value, search, replace) {
    local search_len = search.len();
    local replace_len = replace.len();
    local index = 0;
    while ((index = value.find(search, index)) != null) {
        value = value.slice(0, index) + replace + value.slice(index + search_len);
        index += replace_len;
    }
    return value;
}

// Replace matches in value
local replace_inner = function(value, matches, replace) {
    local len = value.len();
    local match;
    if (replace.find("$") != null) for (local i=matches.len()-1; i>0; i--) {
        match = matches[i];
        replace = str_replace(replace, "$"+i, value.slice(match.begin, (match.end > len) ? len : match.end));
    }
    match = matches[0];
    return value.slice(0, match.begin) + replace + value.slice((match.end > len) ? len : match.end);
}

// BUG?: regexp occasionally returns out-of-range begin/end
// check the match is within the value
local in_range = function(matches, len) {
    if (!matches) return false;
    local m = matches[0];
    return m.begin >= 0
        && m.begin <= len
        && m.end >= 0
        && m.end <= len;
}

class Regex {

    rx = null;
    pattern = "";

    constructor(_pattern = ".") {
        pattern = _pattern;
        rx = regexp(_pattern);
    }

    function _tostring() {
        return "Regex";
    }

    // Return true if pattern matchs
    function test(value) {
        return !!rx.capture(value);
    }

    // Return index of pattern in value, or -1 if none
    function search(value, start = 0) {
        local matches = rx.capture(value, start);
        return in_range(matches, value.len()) ? matches[0].begin : -1;
    }

    // Return array of full-matches
    function match(value) {
        local groups = match_all(value);
        return (typeof groups == "array") ? groups.map(@(r) r[0]) : groups;
    }

    // Return array of group matches
    function match_all(value) {
        local matches = rx.capture(value, 0);
        local len = value.len();
        if (!in_range(matches, len)) return null;

        local groups = [];
        local group;

        // BUG?: regexp occasionally returns out-of-range begin/end
        while (in_range(matches, len)) {
            group = [];
            foreach (match in matches) group.push(value.slice(match.begin, match.end));
            groups.push(group);
            matches = (matches[0].end < len) ? rx.capture(value, matches[0].end) : null;
        }

        return groups;
    }

    // Replace first matching pattern
    function replace(value, replace) {
        local matches = rx.capture(value);
        return in_range(matches, value.len()) ? replace_inner(value, matches, replace) : value;
    }

    // Replace all matching patterns
    function replace_all(value, replace) {
        local val = value;
        local matches = rx.capture(val);
        local prev_len;

        while (in_range(matches, val.len())) {
            prev_len = val.len();
            val = replace_inner(val, matches, replace);
            matches = rx.capture(val, matches[0].begin + val.len() - prev_len);
        }

        return val;
    }
}