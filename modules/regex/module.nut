/*################################################
# Regex
#
# Regular Expression handler
# Version 0.2.0
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
################################################*/

// Replace search in value
local str_replace = function(value, search, replace) {
    local search_len = search.len();
    local replace_len = replace.len();
    local index = 0;
    while ((index = value.find(search, index)) != null) {
        value = format("%s%s%s", value.slice(0, index), replace, value.slice(index + search_len));
        index += replace_len;
    }
    return value;
}

// Replace matches in value
local replace_inner = function(value, match, replace) {
    local len = value.len();
    local item;
    for (local i=match.len()-1; i>0; i--) {
        item = match[i];
        replace = str_replace(replace, "$"+i, value.slice(item.begin, (item.end > len) ? len : item.end));
    }
    item = match[0];
    return format("%s%s%s", value.slice(0, item.begin), replace, value.slice((item.end > len) ? len : item.end));
}

class Regex {

    rx = null;

    constructor(pattern = ".") {
        rx = regexp(pattern);
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
        local match = rx.capture(value, start);
        return match ? match[0].begin : -1;
    }

    // Return array of full-matches
    function match(value) {
        local groups = match_all(value);
        return (typeof groups == "array") ? groups.map(@(r) r[0]) : groups;
    }

    // Return array of group matches
    function match_all(value) {
        local match = rx.capture(value, 0);
        if (!match) return null;

        local len = value.len();
        local groups = [];
        local group;

        while (match) {
            group = [];
            foreach (item in match) group.push(value.slice(item.begin, (item.end > len) ? len : item.end));
            groups.push(group);
            match = (match[0].end < len) ? rx.capture(value, match[0].end) : null;
        }

        return groups;
    }

    // Replace first matching pattern
    function replace(value, replace) {
        local match = rx.capture(value);
        return match ? replace_inner(value, match, replace) : value;
    }

    // Replace all matching patterns
    function replace_all(value, replace) {
        local val = value;
        local match = rx.capture(val);
        local len;

        while (match) {
            len = val.len();
            val = replace_inner(val, match, replace);
            match = rx.capture(val, match[0].begin + val.len() - len);
        }

        return val;
    }
}